# This Makefile is a convenience tool to generate local-only OSTree signing keys
# for the Endless OS build output. It's used only for the local development
# workflow.
#
# See the README.md for intended use.
#
# These targets are based on the Makefile from Freedesktop SDK 24.08.22:
# <https://gitlab.com/freedesktop-sdk/freedesktop-sdk/-/blob/freedesktop-sdk-24.08.22/Makefile?ref_type=tags>

BST=bst

define OSTREE_GPG_CONFIG
Key-Type: DSA
Key-Length: 1024
Subkey-Type: ELG-E
Subkey-Length: 1024
Name-Real: Insecure OSTree signing key for local development use only.
Expire-Date: 0
%no-protection
%commit
%echo finished
endef

export OSTREE_GPG_CONFIG
ostree-gpg:
	rm -rf ostree-gpg.tmp
	mkdir ostree-gpg.tmp
	chmod 0700 ostree-gpg.tmp
	echo "$${OSTREE_GPG_CONFIG}" >ostree-gpg.tmp/key-config
	gpg --batch --homedir=ostree-gpg.tmp --generate-key ostree-gpg.tmp/key-config
	gpg --homedir=ostree-gpg.tmp -k --with-colons | sed '/^fpr:/q;d' | cut -d: -f10 >ostree-gpg.tmp/default-id
	mv ostree-gpg.tmp ostree-gpg

files/ostree-config/eos.gpg: ostree-gpg
	gpg --homedir=ostree-gpg --export --armor >"$@"

OSTREE_BRANCH=eos-buildstream

update-ostree: ostree-gpg files/ostree-config/eos.gpg
	env BST="$(BST)" utils/update-repo.sh      \
	  --gpg-homedir=ostree-gpg                 \
	  --gpg-sign=$$(cat ostree-gpg/default-id) \
	  --collection-id=com.endlessm.Os          \
	  ostree-repo eos/repo.bst                 \
	  $(OSTREE_BRANCH)

ostree-repo:
	$(MAKE) update-ostree

ostree-serve: ostree-repo
	utils/run-local-repo.sh

.PHONY: ostree-repo update-ostree
