#!/bin/bash

if [ ! -f "$1" -o ! -d "$2" -o ! -d "$2/$3" ]; then
  echo 'Specify an XSL stylesheet transform'
  echo 'Specify the root directory of the web (absolute, or relative to cwd)'
  echo 'Specify a destination directory relative to the root of the web'
  exit 1
fi

TRANSFORM="$1"
ROOT_DIR="$2"
DEST_REL_DIR="$3"
DEST_DIR="${ROOT_DIR}/${DEST_REL_DIR}"

IFS="|"
for f in $(find "$DEST_DIR" -maxdepth 1 -iname '*.xml' -a -type f -printf "%f|")
do
  SRC_XML="$DEST_DIR/$f"
  DEST_HTML="$DEST_DIR/${f%'xml'}html"
  if [ ! -f "$DEST_HTML" -o "$SRC_XML" -nt "$DEST_HTML" ] ; then
    echo "$DEST_HTML"
    xalan -xsl "$TRANSFORM" -in "$SRC_XML" -out "$DEST_HTML"
  fi
done

for d in $(find "$DEST_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%f|")
do
  $0 "$TRANSFORM" "$DEST_DIR" "$d"
done
