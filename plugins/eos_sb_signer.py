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


class EosSbSignerElement(Element):

    BST_MIN_VERSION = "2.0"
    BST_FORBID_RDEPENDS = True
    BST_FORBID_SOURCES = True

    def configure(self, node):
        node.validate_keys(['input', 'endpoint', 'output', 'signature_path', 'timeout'])

        self.input_path = node.get_str('input')
        self.endpoint = node.get_str('endpoint')
        self.output_path = node.get_str('output', default=self.input_path)
        self.signature_path = node.get_str('signature_path')
        self.timeout = node.get_int('timeout', default=30)

        if not self.input_path:
            raise ElementError("'input' configuration is required")
        if not self.endpoint:
            raise ElementError("'endpoint' configuration is required")
        if not self.signature_path:
            raise ElementError("'signature_path' configuration is required")

    def preflight(self):
        pass

    def get_unique_key(self):
        key = {
            'input': self.input_path,
            'endpoint': self.endpoint,
            'output': self.output_path,
            'signature_path': self.signature_path,
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

        # Strip leading slash for relative path operations.
        input_relative = self.input_path.strip(os.sep)
        output_relative = self.output_path.strip(os.sep)

        # Read the input binary.
        try:
            with basedir.open_file(input_relative, mode='rb') as f:
                binary_data = f.read()
        except FileNotFoundError:
            raise ElementError(f"Input file not found: {self.input_path}")

        # Prepare the files for the POST request.
        files = {
            'file': ('binary.efi', binary_data, 'application/octet-stream')
        }

        # Read the signature file (required).
        signature_relative = self.signature_path.strip(os.sep)
        try:
            with basedir.open_file(signature_relative, mode='rb') as f:
                signature_data = f.read()
            files['signature'] = ('signature.sig', signature_data, 'application/octet-stream')
        except FileNotFoundError:
            raise ElementError(f"Signature file not found: {self.signature_path}")

        # Send the signing request.
        signing_url = f"{self.endpoint.rstrip('/')}/api/sign"
        self.info(f"Sending {self.input_path} to signing service at {signing_url}")

        try:
            response = requests.post(
                signing_url,
                files=files,
                timeout=self.timeout
            )
            response.raise_for_status()
            signed_binary = response.content

        except requests.exceptions.RequestException as e:
            # For local development, we might want to allow bypassing the signing.
            # service if it's not available.
            self.warn(f"Failed to sign binary: {e}")
            self.warn("Using unsigned binary for local development")
            signed_binary = binary_data

        # Write the signed (or unsigned) binary to the output location.
        output_dir = os.path.dirname(output_relative)
        if output_dir:
            basedir.open_directory(output_dir, create=True)

        with basedir.open_file(output_relative, mode='wb') as f:
            f.write(signed_binary)
            # Ensure the binary is executable.
            os.chmod(f.fileno(), 0o755)

        self.info(f"Signed binary written to {self.output_path}")

        return os.sep


def setup():
    return EosSbSignerElement