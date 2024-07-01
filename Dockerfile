FROM ubuntu:18.04

COPY entrypoint.sh /entrypoint.sh

# baseline dependencies for all versions
RUN apt update && apt install -y software-properties-common lsb-release \
    sudo wget curl build-essential jq autoconf automake \
    pkg-config ca-certificates rpm

# arm64-specific dependencies
RUN apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu binutils-aarch64-linux-gnu

ENV AS=aarch64-linux-gnu-as
ENV STRIP=aarch64-linux-gnu-strip
ENV AR=aarch64-linux-gnu-ar
ENV CC=aarch64-linux-gnu-gcc
ENV CPP=aarch64-linux-gnu-cpp
ENV CXX=aarch64-linux-gnu-g++
ENV LD=aarch64-linux-gnu-ld
ENV FC=aarch64-linux-gnu-gfortran
ENV PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig
ENV npm_config_arch=arm64

# This version supports older GLIBC (official builds required a minimum of GLIBC 2.28)
# this should be the same major version as is used in desktop/desktop
# https://github.com/desktop/desktop/blob/development/.node-version
#
# See https://github.com/nodejs/unofficial-builds/ for more information on these versions.
#
RUN curl -sL 'https://unofficial-builds.nodejs.org/download/release/v20.11.1/node-v20.11.1-linux-x64-glibc-217.tar.xz' | xzcat | tar -vx  --strip-components=1 -C /usr/local/
RUN npm install --global yarn

# install new enough git to work with repository
RUN add-apt-repository ppa:git-core/ppa -y
RUN apt update && apt install -y git
RUN git --version

ENTRYPOINT ["/entrypoint.sh"]
