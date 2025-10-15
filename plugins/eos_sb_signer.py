"""
BuildStream plugin for signing UEFI binaries using the eos-sb-signer service.

This plugin takes a binary and its existing signature from a dependency element
and sends them to a REST signing service to add UEFI Secure Boot signatures.
The signed binary is then stored in this element's artifact.

The signature file is required as the signing service needs to verify the
existing signature before applying new signatures.
"""

import os
import requests
from buildstream import Element, ElementError
from pathlib import Path

from pgpy import PGPKey


class EosSbSignerElement(Element):

    BST_MIN_VERSION = "2.0"
    BST_FORBID_RDEPENDS = True
    BST_FORBID_SOURCES = True

    def configure(self, node):
        node.validate_keys(['input', 'endpoint', 'output', 'private-key-file', 'timeout', 'certificate'])

        self.input_path = node.get_str('input')
        self.endpoint = node.get_str('endpoint')
        self.output_path = node.get_str('output')
        self.private_key_file = node.get_str('private-key-file')
        self.timeout = node.get_int('timeout', default=30)
        self.certificate = node.get_str('certificate', default="eos_uefi")

        if not self.input_path:
            raise ElementError("'input' configuration is required")
        if not self.endpoint:
            raise ElementError("'endpoint' configuration is required")
        if not self.private_key_file:
            raise ElementError("'private-key-file' configuration is required")

    def preflight(self):
        if not Path(self.private_key_file).is_file():
            raise ElementError(f"Missing private key file {self.private_key_file}")

    def get_unique_key(self):
        private_key, _ = PGPKey.from_file(self.private_key_file)
        fingerprint = private_key.fingerprint
        key = {
            'input': self.input_path,
            'endpoint': self.endpoint,
            'output': self.output_path,
            'key-fingerprint': fingerprint,
            'certificate': self.certificate,
        }
        return key

    def configure_sandbox(self, sandbox):
        pass

    def stage(self, sandbox):
        # Stage all dependencies into the sandbox.
        for dependency in self.dependencies():
            dependency.stage_artifact(sandbox)

    def assemble(self, sandbox):
        basedir = sandbox.get_virtual_directory()

        input_relative = self.input_path.strip(os.sep)
        output_relative = self.output_path.strip(os.sep)

        self.log(f"Reading input binary in sandbox: {input_relative}")
        try:
            with basedir.open_file(input_relative, mode='rb') as f:
                binary_data = f.read()
        except FileNotFoundError:
            raise ElementError(f"Input file not found: {self.input_path}")

        self.log(f"Reading private key from host file {self.private_key_file}")
        private_key, _ = PGPKey.from_file(self.private_key_file)

        # It goes without saying, but never log the actual private key anywhere.
        # Its fingerprint is safe to log and is useful to confirm which key
        # is being used.
        self.info(f"Loaded private key with fingerprint {private_key.fingerprint}")

        self.log("Creating signature")
        signature = private_key.sign(binary_data)

        files = {
            'file': ('binary.efi', binary_data, 'application/octet-stream'),
            'signature': ('signature.sig', bytes(signature), 'application/octet-stream'),
        }
        data = {
            'certificate': self.certificate
        }

        signing_url = f"{self.endpoint.rstrip('/')}/api/sign"
        self.info(f"Sending POST request to signer service at {signing_url}")

        try:
            response = requests.post(
                signing_url,
                data=data,
                files=files,
                timeout=self.timeout
            )
            response.raise_for_status()
            signed_binary = response.content

        except requests.exceptions.RequestException as e:
            raise ElementError(
                f"Failed to contact secure boot signing service at {self.endpoint}",
                detail=str(e)
            )

        # Write the signed (or unsigned) binary to the output location.
        output_dir = os.path.dirname(output_relative)
        if output_dir:
            basedir.open_directory(output_dir, create=True)

        with basedir.open_file(output_relative, mode='wb') as f:
            f.write(signed_binary)
            # Ensure the binary is executable.
            os.chmod(f.fileno(), 0o755)

        self.info(f"Signed binary written to {self.output_path}")

        # Return the payload.
        return self.get_variable("install-root")


def setup():
    return EosSbSignerElement
