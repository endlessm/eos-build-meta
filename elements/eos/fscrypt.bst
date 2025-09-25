# Wrapper for freedesktop-sdk fscrypt element to fix PAM module location
# and add configuration file
kind: script

build-depends:
- freedesktop-sdk.bst:components/fscrypt.bst

config:
  commands:
  # Debug: Check what we have from the fscrypt element
  - |
    echo "Looking for pam_fscrypt.so in the build environment:" >&2
    find / -name "pam_fscrypt.so" 2>/dev/null || echo "No pam_fscrypt.so found!" >&2
    echo "Looking for fscrypt binary:" >&2
    find / -name "fscrypt" -type f -executable 2>/dev/null || echo "No fscrypt binary found!" >&2

  # Copy only fscrypt-specific files
  - |
    # Copy the fscrypt binary
    if [ -f /usr/bin/fscrypt ]; then
      mkdir -p "%{install-root}%{bindir}"
      cp /usr/bin/fscrypt "%{install-root}%{bindir}/"
    fi

  # Copy the PAM module to the correct multiarch location
  - |
    # First check where the PAM module is
    PAM_MODULE=$(find /usr -name "pam_fscrypt.so" 2>/dev/null | head -1)
    if [ -n "$PAM_MODULE" ]; then
      echo "Found PAM module at: $PAM_MODULE" >&2
      mkdir -p "%{install-root}%{libdir}/security"
      cp "$PAM_MODULE" "%{install-root}%{libdir}/security/pam_fscrypt.so"
      echo "Copied PAM module to %{install-root}%{libdir}/security/pam_fscrypt.so" >&2
    else
      echo "ERROR: pam_fscrypt.so not found in the build environment!" >&2
    fi

  # Install default fscrypt configuration
  - |
    mkdir -p "%{install-root}%{sysconfdir}"
    cat > "%{install-root}%{sysconfdir}/fscrypt.conf" <<'EOF'
    {
      "source": "custom_passphrase",
      "hash_costs": {
        "time": 52,
        "memory": 131072,
        "parallelism": 32
      },
      "compatibility": "",
      "options": {
        "padding": "32",
        "contents": "AES_256_XTS",
        "filenames": "AES_256_CTS",
        "policy_version": "2"
      },
      "use_fs_keyring_for_v1_policies": false,
      "allow_cross_user_metadata": false
    }
    EOF