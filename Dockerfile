FROM debian:11-slim AS openWrtBuilder
RUN apt-get update
RUN apt-get install subversion build-essential git-core libncurses5-dev zlib1g-dev gawk flex quilt libssl-dev xsltproc libxml-parser-perl mercurial bzr ecj cvs unzip git wget -y
RUN git clone https://github.com/domino-team/openwrt-cc.git
RUN cd openwrt-cc && ./scripts/feeds update -a && ./scripts/feeds install -a

COPY app .