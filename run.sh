#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Give an path of directory that includes pdfs." 1>&2
  exit 1
fi

SRC_DIR=$(cd $1 && pwd) # 相対パス -> 絶対パス

if [ "$(ls "$SRC_DIR"/*.pdf)" = '' ]; then
  echo "No pdf files in $SRC_DIR."
  exit 1
fi

IMAGE_NAME=pdfnup-runner

if [ "$(docker images --format "{{.Repository}}" | grep $IMAGE_NAME)" = '' ]; then
  echo "Docker image not found. Building..."
  docker build -t $IMAGE_NAME "$(dirname "$0")"
fi

cp "$SRC_DIR"/*.pdf "$(dirname "$0")"/tmp_pdfs

cd "$(dirname "$0")" && \
  docker run --rm -v `pwd`/tmp_pdfs:/tmp/pdfs $IMAGE_NAME pdfnup --nup 2x4 --scale 0.96 --no-landscape --batch `ls tmp_pdfs` && \
  cp tmp_pdfs/*-nup.pdf $SRC_DIR/

rm -f "$(dirname "$0")"/tmp_pdfs/*.pdf
cd -
