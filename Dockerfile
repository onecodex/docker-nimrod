FROM quay.io/refgenomics/docker-ubuntu:14.04

MAINTAINER Nick Greenfield <nick@refgenomics.com>

# Update
RUN apt-get update -y

# Install Git
RUN apt-get install -y git

# Install mercurial (dependency for some Babel packages)
RUN apt-get install -y mercurial

# Install Nim (v0.13.0 release)
RUN mkdir /root/nim/
RUN \
	cd /root/nim/ && \
	git clone -b master https://github.com/Araq/Nim.git && \
	cd Nim && \
	git checkout a121c3f9eb2a348b9d6ae03ffd01aab26a238c30
RUN \
	cd /root/nim/Nim && \
	git clone -b master --depth 1 git://github.com/nim-lang/csources && \
	cd csources && \
	git checkout 9b74185793b50993caac9e358e185f04a84dfc82 && \
	sh build.sh && \
	cd .. && \
	bin/nim c koch && \
	./koch boot -d:release
RUN ln -s /root/nim/Nim/bin/nim /usr/local/bin/nim

# Install Nimble (Nim package manager, v0.7.0)
RUN \
	cd /root/nim/ && \
	git clone https://github.com/nim-lang/nimble.git && \
	cd nimble && \
	git checkout 80a418e68063eeb32f311341573567bf545dc8d9
RUN \
	cd /root/nim/nimble && \
	nim c -r src/nimble install
RUN ln -s /root/.nimble/bin/nimble /usr/local/bin/nimble
RUN nimble update

# Integration tests
ADD test /tmp/test
RUN bats /tmp/test
