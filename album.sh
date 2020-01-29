#!/bin/bash

SOURCE_DIR="${1%/}"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ALBUM_TITLE="${SOURCE_DIR##*/}"
DEST_DIR_NAME="${ALBUM_TITLE//[ \'\.]/-}"
WEB_DIR="${SOURCE_DIR}/web/"
DEST_DIR="${WEB_DIR}${DEST_DIR_NAME}"


echo ""
echo "DEST_DIR $DEST_DIR"
echo ""

$SCRIPT_DIR/gallery.sh "$SOURCE_DIR";
$SCRIPT_DIR/c_transform.sh "$DEST_DIR"
