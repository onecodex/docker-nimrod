FROM quay.io/refgenomics/docker-ubuntu:14.04

MAINTAINER Nick Greenfield <nick@refgenomics.com>

# Install Git
RUN apt-get install -y git

# Install mercurial (dependency for some Babel packages)
RUN apt-get install -y mercurial

# Install Nim (v0.10 devel, near release)
RUN mkdir /root/nim/
RUN \
	cd /root/nim/ && \
	git clone -b master https://github.com/Araq/Nim.git && \
	cd Nim && \
	git checkout 92c873154a36d34ff8e18de6b2d1a0eb1b611860
RUN \
	cd /root/nim/Nim && \
	git clone -b master --depth 1 git://github.com/nim-lang/csources && \
	cd csources && \
	git checkout 96a5b7fe23eb1964f2e68e455f14246b390b9507 && \
	sh build.sh && \
	cd .. && \
	bin/nim c koch && \
	./koch boot -d:release
RUN ln -s /root/nim/Nim/bin/nim /usr/local/bin/nim

# Install Nimble (Nim package manager, v0.6)
RUN \
	cd /root/nim/ && \
	git clone https://github.com/nim-lang/nimble.git && \
	cd nimble && \
	git checkout 875786d34fc4e342eb2fdc849d6d84718c615e84
RUN \
	cd /root/nim/nimble && \
	nim c -r src/nimble install
RUN ln -s /root/.nimble/bin/nimble /usr/local/bin/nimble
RUN nimble update

# Integration tests
ADD test /tmp/test
RUN bats /tmp/test
