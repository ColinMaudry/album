#!/bin/bash

if [ ! -d "$1" ]; then
echo $1
  echo 'Specify the root directory of the web (absolute, or relative to cwd)'
  exit 1
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

TRANSFORM="${SCRIPT_DIR}/xslt/site.xsl"
DEST_DIR="$1"

while IFS= read -d $'\0' -r SRC_XML ; do
  DEST_HTML="${SRC_XML%'xml'}html"
  if [ ! -f "$DEST_HTML" -o "$SRC_XML" -nt "$DEST_HTML" ] ; then
    echo "$DEST_HTML"
    Xalan "$SRC_XML" "$TRANSFORM" > "$DEST_HTML"
  fi
done < <(find "${DEST_DIR}" -maxdepth 1 -iname '*.xml' -a -type f -print0)

# while IFS= read -d $'\0' -r DIR ; do
#   $0 "$TRANSFORM" "${DEST_DIR}" "${DIR##*/}"
# done < <(find "${DEST_DIR}" -mindepth 1 -maxdepth 1 -type d -print0)

cd "$DEST_DIR"
cd ..
WEB_DIR=`pwd`

cp -r "$SCRIPT_DIR/assets" "$WEB_DIR" 