kind: autotools
description: |
  GnuPG keys for Endless OS.

  * eos-keyring: Contains signing keys for EOS including ostree updates, apt
    repos and any other deliverables. A copy of the Endless SSL CA certificate
    is included. The endless-ca-trust-system and endless-ca-trust-user scripts
    can be used for manually trusting it at the system and user levels.
  * eos-image-keyring: Contains the EOS image signing keys for EOS developrs.
  * eos-infra-keyring: Contains the Endless infrastructure repository signing
    key. It's only useful on Endless servers.
  * endless-ca-cert: Contains the root certificate for the Endless SSL
    certificate authority (CA). This CA provides SSL certificates for internal
    Endless services. Installing this package will add it to the system's
    trusted certificate authorities. You will also need to run
    endless-ca-trust-user to add the certificate to the user's NSS database for
    chromium and chrome. The /etc/profile.d/endless-ca-trust-user.sh profile
    script does this automatically at login.

sources:
- kind: git_repo
  url: github:endlessm/eos-keyring.git
  track: 174-use-update-ca-trust
  ref: c9c7fb95fc34d91c69efa057ae7392435491a1a9

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst

depends:
- freedesktop-sdk.bst:components/gnupg.bst
- freedesktop-sdk.bst:components/openssl.bst

runtime-depends:
- freedesktop-sdk.bst:components/ca-certificates.bst
- freedesktop-sdk.bst:components/nss.bst

public:
  bst:
    split-rules:
      eos-keyring:
        - '%{sysconfdir}/apt/trusted.gpg.d/eos-archive-keyring.gpg'
        - '%{sysconfdir}/apt/trusted.gpg.d/eos-pub-archive-keyring.gpg'
        - '%{bindir}/endless-ca-trust-system'
        - '%{bindir}/endless-ca-trust-user'
        - '%{datadir}/eos-keyring/endless-ca.crt'
        - '%{datadir}/keyrings/eos-archive-keyring.gpg'
        - '%{datadir}/keyrings/eos-codecs-keyring.gpg'
        - '%{datadir}/keyrings/eos-flatpak-keyring.gpg'
        - '%{datadir}/keyrings/eos-master-keyring.gpg'
        - '%{datadir}/keyrings/eos-ostree-keyring.gpg'
        - '%{datadir}/keyrings/eos-pub-archive-keyring.gpg'
        - '%{datadir}/ostree/trusted.gpg.d'
      eos-image-keyring:
        - '%{datadir}/keyrings/eos-image-keyring.gpg'
      eos-infra-keyring:
        - '%{sysconfdir}/apt/trusted.gpg.d/eos-infra-archive-keyring.gpg'
        - '%{datadir}/keyrings/eos-infra-archive-keyring.gpg'
      endless-ca-cert:
        - '%{sysconfdir}/profile.d/endless-ca-trust-user.sh'
        - '%{datadir}/share/ca-certificates/endless/'
