kind: autotools

sources:
- kind: git_repo
  url: github:endlessm/eos-keyring.git
  track: Release_*
  ref: Release_6.0.7-0-g99f6609b0d799f7463c87fec45e5a9e1a9a36994

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-autotools.bst

depends:
- freedesktop-sdk.bst:components/ca-certificates.bst
- freedesktop-sdk.bst:components/gnupg.bst
- freedesktop-sdk.bst:components/nss.bst
- freedesktop-sdk.bst:components/openssl.bst

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
