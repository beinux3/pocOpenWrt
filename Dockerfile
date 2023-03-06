FROM debian:11-slim AS openWrtBuilder
RUN apt update
RUN apt install build-essential clang flex bison g++ gawk gcc-multilib g++-multilib gettext git -y 
RUN apt install libncurses5-dev libssl-dev python3-distutils rsync unzip zlib1g-dev file wget -y

COPY app .