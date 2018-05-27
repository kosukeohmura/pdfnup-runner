FROM ubuntu:xenial

RUN \
  apt-get -y update && \
  apt-get -y upgrade && \
  apt-get install -y --no-install-recommends texlive-lang-japanese \
    texlive-lang-cjk \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-extra-utils \
    texlive-latex-recommended \
  && mkdir /tmp/pdfs
WORKDIR /tmp/pdfs
