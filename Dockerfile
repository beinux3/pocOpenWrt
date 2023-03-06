FROM ubuntu:lunar AS openWrtBuilder
RUN apt update
RUN apt install build-essential clang flex bison g++ gawk gcc-multilib g++-multilib gettext git -y 
RUN apt install libncurses5-dev libssl-dev python3-distutils rsync unzip zlib1g-dev file wget -y
RUN apt install binutils bzip2 grep perl subversion ocaml sharutils re2c -y

WORKDIR /root/

RUN git clone https://github.com/gl-inet/gl-infra-builder.git && gl-infra-builder && git clone https://github.com/gl-inet/glinet4.x.git 
RUN cd gl-infra-builder && python3 setup.py -c configs/config-22.03.2.yml
COPY app .