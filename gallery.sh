#!/bin/bash

PREVIEW_SUBDIR='preview'
PREVIEW_SIZE='1600'
PREVIEW_FORMAT='jpg'
THUMB_SUBDIR='thumbnail'
THUMB_SIZE='400'
ORIGINAL_SUBDIR='original'
INDEX_NAME='index'
ALBUM_THUMBNAIL_NAME='album_thumbnail.jpg'

if [ ! -d "$1" ]; then
  echo 'Specify the directory of the pictures (absolute, or relative to cwd)'
  exit 1
fi

SOURCE_DIR="${1%/}"
CURRENT_DIR="`pwd`"

ALBUM_TITLE="${SOURCE_DIR##*/}"
DEST_DIR_NAME="${ALBUM_TITLE//[ \'\.]/-}"

cd "$SOURCE_DIR"
cd ..

WEB_DIR="`pwd`/web/"
DEST_DIR="${WEB_DIR}${DEST_DIR_NAME}"

mkdir -p "$DEST_DIR"

cd "$CURRENT_DIR"

# Debug
# echo "$ALBUM_TITLE"
# echo "$DEST_DIR_NAME"
# echo "$SOURCE_DIR"
# echo "$DEST_DIR"
# echo "$WEB_DIR"
# echo ""


DEST_ZIP="$DEST_DIR/${DEST_DIR_NAME}.zip"
PREVIEW_DIR="${DEST_DIR}/${PREVIEW_SUBDIR}"
THUMB_DIR="${DEST_DIR}/${THUMB_SUBDIR}"
ORIGINAL_DIR="${DEST_DIR}/${ORIGINAL_SUBDIR}"


[ -e "$DEST_DIR" ] || mkdir -p "$DEST_DIR"
[ -e "$PREVIEW_DIR" ] || mkdir "$PREVIEW_DIR"
[ -e "$ORIGINAL_DIR" ] || mkdir "$ORIGINAL_DIR"
[ -e "$THUMB_DIR" ] || mkdir "$THUMB_DIR"
if [ -d "$PREVIEW_DIR" -a -d "$THUMB_DIR" ]; then
  # make preview and thumbnail images
  PHOTO_COUNT=0

  while IFS= read -d $'\0' -r SRC_IMAGE ; do
    zip -j -1 -u $DEST_ZIP "$SRC_IMAGE"

    CURF=${SRC_IMAGE##*/}
    DEST_PREVIEW="$PREVIEW_DIR/$CURF"
    DEST_THUMB="$THUMB_DIR/$CURF"
    DEST_ORIGINAL="$ORIGINAL_DIR/$CURF"
    
    cp "$SRC_IMAGE" "$DEST_ORIGINAL"

    [ "$SRC_IMAGE" -nt "$DEST_PREVIEW" ] && echo "$DEST_PREVIEW" && convert "$SRC_IMAGE" \
      -auto-orient \
      -resize ${PREVIEW_SIZE}x${PREVIEW_SIZE} \
      "$DEST_PREVIEW"
    [ "$SRC_IMAGE" -nt "$DEST_THUMB" ] && echo "$DEST_THUMB" && convert "$SRC_IMAGE" \
      -auto-orient \
      -resize ${THUMB_SIZE}x${THUMB_SIZE} \
      "$DEST_THUMB"
    PHOTO_LIST[$PHOTO_COUNT]=$CURF
    PHOTO_COUNT=$((PHOTO_COUNT+1))
  done < <(find -L "$SOURCE_DIR" -maxdepth 1 \( -iname '*.jpg' \
     -o -iname '*.jpeg' \
     -o -iname '*.png' \) \
     -a -type f -print0 | sort -z )

  # make album thumbnail
  if [ 0 -lt $PHOTO_COUNT ]; then
    SRC_IMAGE="$SOURCE_DIR/${PHOTO_LIST[0]}"
    DEST_IMAGE="$DEST_DIR/$ALBUM_THUMBNAIL_NAME"
    [ "$SRC_IMAGE" -nt "$DEST_IMAGE" ] && echo "$DEST_IMAGE" && convert "$SRC_IMAGE" \
      -auto-orient \
      -resize ${THUMB_SIZE}x${THUMB_SIZE} \
      "$DEST_IMAGE"
  fi



  # make sub-albums
  #DIR_COUNT=0
  #while IFS= read -d $'\0' -r SRC_DIR ; do
  #  DIR=${SRC_DIR##*/}
  #  $0 "$ROOT_DIR" "$SRC_REL_DIR/$DIR" "$DEST_REL_DIR/$DIR" "${DEST_REL_DIR##*/}"
  #  DIR_LIST[$DIR_COUNT]="$DIR"
  #  DIR_COUNT=$((DIR_COUNT+1))
  #done < <(find -L "$SOURCE_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z) 

  # output preview pages
  for (( CUR_PHOTO=0 ; $CUR_PHOTO < $PHOTO_COUNT ; CUR_PHOTO=$((CUR_PHOTO+1)) )) do
    CUR_PHOTO_NAME=${PHOTO_LIST[$CUR_PHOTO]}
    CUR_PHOTO_REF=$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "${CUR_PHOTO_NAME}")
    SRC_IMAGE="$ORIGINAL_SUBDIR/$CUR_PHOTO_REF"
    DEST_PREVIEW="$PREVIEW_SUBDIR/$CUR_PHOTO_REF"
    DEST_THUMB="$THUMB_SUBDIR/$CUR_PHOTO_REF"
    NAME=${CUR_PHOTO_NAME%.*}
    PREVIEW_XML=$DEST_DIR/$NAME.xml
    echo "$PREVIEW_XML"
    cat > "$PREVIEW_XML" <<EOF
<?xml version='1.0' ?>
<image-preview albumTitle="${ALBUM_TITLE}" pathName="${DEST_DIR_NAME}">
  <thumbnail src="$DEST_THUMB"/>
  <image src="$DEST_PREVIEW"/>
  <full-size src="$SRC_IMAGE"/>
  <index loc="$INDEX_NAME.html#photo$CUR_PHOTO"/>
EOF
    if [ $CUR_PHOTO -gt 0 ]; then
      PREVIOUS=${PHOTO_LIST[(($CUR_PHOTO-1))]}
      PREVIOUS_REF=$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "${PREVIOUS}")
      cat >> "$PREVIEW_XML" <<EOF
  <previous loc="${PREVIOUS_REF%.*}.html">
    <thumbnail src="$THUMB_SUBDIR/$PREVIOUS_REF">&lt;&lt;</thumbnail>
  </previous>
EOF
    fi
    if [ $CUR_PHOTO -lt $((PHOTO_COUNT-1)) ]; then
      NEXT=${PHOTO_LIST[(($CUR_PHOTO+1))]}
      NEXT_REF=$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "${NEXT}")
      cat >> "$PREVIEW_XML" <<EOF
  <next loc="${NEXT_REF%.*}.html">
    <thumbnail src="$THUMB_SUBDIR/$NEXT_REF">&gt;&gt;</thumbnail>
  </next>
EOF
    fi
    cat >> "$PREVIEW_XML" <<EOF
</image-preview>
EOF
  done # for CUR_PHOTO

  # output index page
  INDEX_XML="$DEST_DIR/$INDEX_NAME.xml"
  echo "$INDEX_XML"
  cat > "$INDEX_XML" <<EOF
<?xml version='1.0' ?>
<album albumTitle="${ALBUM_TITLE}" pathName="${DEST_DIR_NAME}">
EOF

#   # output parent
#   if [ 0 -lt $# ]; then
#     cat >> "$INDEX_XML" <<EOF
#   <parent title="$1" link="../${INDEX_NAME}.html"/>
# EOF
#   fi

#   for (( CUR_DIR=0 ; $CUR_DIR < $DIR_COUNT ; CUR_DIR=$((CUR_DIR+1)) )) do
#     CUR_DIR_NAME=${DIR_LIST[$CUR_DIR]}
#     cat >> "$INDEX_XML" <<EOF
#   <sub-album loc="$CUR_DIR_NAME/$INDEX_NAME.html">
#     <thumbnail src="$CUR_DIR_NAME/$ALBUM_THUMBNAIL_NAME">
#       $CUR_DIR_NAME
#     </thumbnail>
#   </sub-album>
# EOF
#   done

  for (( CUR_PHOTO=0 ; $CUR_PHOTO < $PHOTO_COUNT ; CUR_PHOTO=$((CUR_PHOTO+1)) )) do
    CUR_PHOTO_NAME=${PHOTO_LIST[$CUR_PHOTO]}
    CUR_PHOTO_REF=$(perl -MURI::Escape -e 'print uri_escape($ARGV[0]);' "${CUR_PHOTO_NAME}")
    DEST_THUMB="$THUMB_SUBDIR/$CUR_PHOTO_REF"
    NAME=${CUR_PHOTO_REF%.*}
    PREVIEW_NAME="$NAME.html"
    cat >> "$INDEX_XML" <<EOF
  <preview
    id="photo$CUR_PHOTO"
    loc="$PREVIEW_NAME">
    <thumbnail src="$DEST_THUMB">
      $(echo ${CUR_PHOTO_NAME%.*} | sed -e 's/&/&amp;/g')
    </thumbnail>
  </preview>
EOF
  done
  cat >> "$INDEX_XML" <<EOF
</album>
EOF

else
  echo 'failed to create scaled image directory. file in the way?'
fi

