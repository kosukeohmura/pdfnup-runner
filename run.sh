#!/bin/bash

if [ "$1" = '' ]; then
  echo "Give one or more pdf file paths." 1>&2
  exit 1
fi

IMAGE_NAME=pdfnup-runner

if [ "$(docker images --format "{{.Repository}}" | grep $IMAGE_NAME)" = '' ]; then
  echo "Docker image not found. Building..."
  docker build -t $IMAGE_NAME "$(dirname "$0")"
fi

OUTPUT_DIR=nuped
SHOULD_NUP=false

if [ -e $OUTPUT_DIR ]; then
  echo "$pwd/$OUTPUT_DIR already exists. Override? [Y/n]"
  read answer
  answer=`echo $answer | tr y Y | tr -d '[\[\]]'`
  case $answer in
    Y* ) SHOULD_NUP=true;;
    *  ) SHOULD_NUP=false;;
  esac
else
  SHOULD_NUP=true
fi

if [ $SHOULD_NUP = true ]; then
  TMP_PDF_DIR=$(cd "$(dirname "$0")" && pwd)/tmp_pdfs
  rm -r $TMP_PDF_DIR 2> /dev/null
  mkdir $TMP_PDF_DIR

  for src_pdf in "$@"; do
    cp $src_pdf $TMP_PDF_DIR
  done

  rm -rf $OUTPUT_DIR
  mkdir $OUTPUT_DIR && \
    docker run --rm -v $TMP_PDF_DIR:/tmp/pdfs $IMAGE_NAME pdfnup --nup 2x4 --scale 0.96 --a4paper --no-landscape --batch --quiet `ls $TMP_PDF_DIR` && \
    cp $TMP_PDF_DIR/*-nup.pdf $OUTPUT_DIR/

  rm -r $TMP_PDF_DIR
fi
