#!/bin/sh

# Updates some BuildStream elements to a new gnome-build-meta tag.
#
# Usage: utils/update-elements.sh <gnome-build-meta-tag>
#
# This script assumes all elements are in the elements/ directory, their
# path is the location within this directory. E.g. it
# expects gnome-build-meta.bst, not elements/gnome-build-meta.bst.
#
# It also assumes the gnome-build-meta and freedesktop-sdk remotes
# and their tags are available and up-to-date.
#
# FIXME It doesn't support removed elements.
# FIXME It doesn't update any other files than the ones in elements/.
#
# This script first updates the gnome-build-meta.bst junction element's
# 'track' and 'ref' fields. Then it updates all refular files in the
# 'elements' directory which start with this header:
# # utils/update-elements.sh: Derived from <junctioned-element> <junctioned-tag> <overridden-element>
#
# - <junctioned-element> is the junction element in this repository.
# - <junctioned-tag> is the tag of the junctionned project from which
#   the element has been last updated.
# - <overridden-element> is the element that is overriden, it may have a
#   different location in this repository.
#
# The tag of the new version to update the element to will be extracted
# from <junctioned-element> once it has been updated. The elements are
# updated with a 3-way merge, comparing the overridden element, the
# element from the old tag, and the one from the new tag.
#
# As diff3 is used, conflicting lines will be marked as diff3 does:
# <<<<<<< elements/<local-element>
# Conflicting lines.
# ||||||| .updates/old/<junctioned-element>/<junctioned-tag>/elements/<overridden-element>
# What they are in the previous source version.
# =======
# What they are in the new source version.
# >>>>>>> .updates/new/<junctioned-element>/<junctioned-tag>/elements/<overridden-element>
#
# Junctions will be updated before the elements deriving from them.
#
# While we are calling them junctions and overridden elements, this
# script doesn't care whether they actually are junctions and overriden
# elements as per BuildStream, and it uses its own hierarchy defined in
# the headers. This allows files to be updated whether they are
# overridden elements or simply elements borrowed from elsewhere.
#
# The script uses .updates/ as its working directory, it creates it when
# needed and removes it at the end of a successful update.

GNOME_BUILD_META_TAG=$1

declare -A ELEMENT_TAG

FREEDESKTOP_SDK_TAG=unknown-tag

# Used to match a Git tag.
TAG_REGEX='[-.a-z0-9]+'

# Used to match a BuildStream element path, or other files in elements/.
ELEMENT_REGEX='[-./a-z0-9]+'

function escape {
	echo $1 | sed 's|/|\\/|g'
}

function ensure_tag {
	local TAG=$1
	local PROJECT=$2

	if ! git show-ref refs/tags/$TAG > /dev/null; then
		echo "Error: Couldn't get tag '$TAG' for project $PROJECT. Is the remote for it available, up-to-date, and are its tags available?" >&2
		exit 1
	fi
}

function ref {
	# FIXME Should handle other formats than tag-n-commit.
	grep --extended-regexp --max-count 1 --only-matching "ref: $TAG_REGEX" $1 | sed --regexp-extended 's/ref: ([-.a-z0-9]+)-[0-9]+-g[a-f0-9]{40}/\1/g'
}

function update_gnome_build_meta {
	echo "Updating gnome-build-meta.bst"

	ensure_tag $GNOME_BUILD_META_TAG gnome-build-meta.bst

	local GNOME_BUILD_META_COMMIT=`git log -1 --format=format:"%H" refs/tags/$GNOME_BUILD_META_TAG`
	local GNOME_BUILD_META_REF=`echo $GNOME_BUILD_META_TAG-0-g$GNOME_BUILD_META_COMMIT`
	local GNOME_BUILD_META_TRACK=`echo $GNOME_BUILD_META_TAG | cut --delimiter '.' --fields 1`

	sed --in-place "0,/track: .*/s//track: $GNOME_BUILD_META_TRACK*/" elements/gnome-build-meta.bst
	sed --in-place "0,/ref: .*/s//ref: $GNOME_BUILD_META_REF/" elements/gnome-build-meta.bst

	git add elements/gnome-build-meta.bst

	ELEMENT_TAG['gnome-build-meta.bst']=$GNOME_BUILD_META_TAG
}

function update_element {
	# The path of the element in this repo, without the 'elements/' prefix.
	# It may differ from the path to the element in the source repo.
	local DST_ELEMENT=$1

	# If the element has already been updated, don't update it anew.
	if [ -n "${ELEMENT_TAG[$DST_ELEMENT]}" ]; then
		return
	fi

	# The header used by this script to track the source of the
	# element.
	local OLD_HEADER=`head --lines 1 elements/$DST_ELEMENT | grep --extended-regexp --max-count 1 --line-regex "# utils/update-elements.sh: Derived from $ELEMENT_REGEX $TAG_REGEX $ELEMENT_REGEX"`

	# We only handle elements with a header.
	if [ -z "$OLD_HEADER" ]; then
		return
	fi

	local SRC_PROJECT=`echo $OLD_HEADER | cut --delimiter ' ' --fields 5`
	local OLD_TAG=`echo $OLD_HEADER | cut --delimiter ' ' --fields 6`
	local OLD_SRC_ELEMENT=`echo $OLD_HEADER | cut --delimiter ' ' --fields 7`

	ensure_tag $OLD_TAG $SRC_PROJECT

	# If the source project hasn't been updated yet, update it to we
	# can get its new tag.
	if [ -z "${ELEMENT_TAG[$SRC_PROJECT]}" ]; then
		update_element $SRC_PROJECT
	fi

	# If the source project was up-to-date before running the
	# script, its ref won't be stored and we should fetch it.
	if [ -z "${ELEMENT_TAG[$SRC_PROJECT]}" ]; then
		ELEMENT_TAG["$SRC_PROJECT"]=`ref elements/$SRC_PROJECT`
	fi

	local NEW_TAG="${ELEMENT_TAG[$SRC_PROJECT]}"
	if [ -z "$NEW_TAG" ]; then
		echo "Error: Couldn't get the tag for source junction project '$SRC_PROJECT'." >&2
		exit 1
	fi

	ensure_tag $NEW_TAG $SRC_PROJECT

	# Only update elements borrowed from older versions.
	if [[ "$OLD_TAG" > "$NEW_TAG" ]]; then
		echo "Skipping $DST_ELEMENT: $SRC_PROJECT $OLD_TAG > $NEW_TAG"
		return
	fi

	# Only update elements borrowed from older versions.
	if [[ "$OLD_TAG" == "$NEW_TAG" ]]; then
		echo "Skipping $DST_ELEMENT: $SRC_PROJECT $OLD_TAG = $NEW_TAG"
		return
	fi

	echo "Updating $DST_ELEMENT: $SRC_PROJECT $OLD_TAG → $NEW_TAG"

	# Detect renamed elements.
	local NEW_SRC_ELEMENT=$OLD_SRC_ELEMENT
	local RENAMED_ELEMENT=`git diff --name-status refs/tags/$OLD_TAG..refs/tags/$NEW_TAG | grep --extended-regexp --max-count 1 "^R[0-9]{3}\s$OLD_SRC_ELEMENT\s[-./a-z0-9]+" | cut --fields 3`
	if [ -n "$RENAMED_ELEMENT" ]; then
		NEW_SRC_ELEMENT=${RENAMED_ELEMENT#elements/}
		echo "Renamed: $OLD_SRC_ELEMENT → $NEW_SRC_ELEMENT"
	fi

	local OLD_DIR=.update/old/$SRC_PROJECT/$OLD_TAG
	local NEW_DIR=.update/new/$SRC_PROJECT/$NEW_TAG

	local OLD_ELEMENT=$OLD_DIR/elements/$OLD_SRC_ELEMENT
	local NEW_ELEMENT=$NEW_DIR/elements/$NEW_SRC_ELEMENT
	local MERGED_ELEMENT=.update/merged/elements/$DST_ELEMENT

	mkdir -p `dirname $OLD_ELEMENT`
	mkdir -p `dirname $NEW_ELEMENT`
	mkdir -p `dirname $MERGED_ELEMENT`

	git --work-tree=$OLD_DIR checkout refs/tags/$OLD_TAG -- elements/$OLD_SRC_ELEMENT
	git --work-tree=$NEW_DIR checkout refs/tags/$NEW_TAG -- elements/$NEW_SRC_ELEMENT

	diff3 --merge elements/$DST_ELEMENT $OLD_ELEMENT $NEW_ELEMENT > $MERGED_ELEMENT
	local NEW_HEADER="# utils/update-elements.sh: Derived from $SRC_PROJECT $NEW_TAG $NEW_SRC_ELEMENT"
	sed --in-place "0,/`escape "$OLD_HEADER"`/s//`escape "$NEW_HEADER"`/" $MERGED_ELEMENT
	cp $MERGED_ELEMENT elements/$DST_ELEMENT

	git add elements/$OLD_SRC_ELEMENT elements/$DST_ELEMENT

	# Get the tag from the newer version of the element.
	ELEMENT_TAG["$DST_ELEMENT"]=`ref $NEW_ELEMENT`
}

function update_all_elements {
	find elements -type f | while read ELEMENT; do
		update_element ${ELEMENT#elements/}
	done
}

update_gnome_build_meta
update_all_elements

rm -rf .update
