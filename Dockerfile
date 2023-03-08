FROM debian:11-slim AS openWrtBuilder
RUN apt-get update
RUN apt-get install subversion build-essential git-core libncurses5-dev zlib1g-dev gawk flex quilt libssl-dev xsltproc libxml-parser-perl mercurial bzr ecj cvs unzip git wget -y
RUN git clone https://github.com/domino-team/openwrt-cc.git
RUN cd openwrt-cc && ./scripts/feeds update -a && ./scripts/feeds install -a

WORKDIR /root/

RUN git clone https://github.com/gl-inet/gl-infra-builder.git && gl-infra-builder && git clone https://github.com/gl-inet/glinet4.x.git 
RUN cd gl-infra-builder && python3 setup.py -c configs/config-22.03.2.yml
COPY app .