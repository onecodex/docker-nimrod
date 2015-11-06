FROM quay.io/refgenomics/docker-ubuntu:14.04

MAINTAINER Nick Greenfield <nick@refgenomics.com>

# Update
RUN apt-get update -y

# Install Git
RUN apt-get install -y git

# Install mercurial (dependency for some Babel packages)
RUN apt-get install -y mercurial

# Install Nim (v0.12.0 release)
RUN mkdir /root/nim/
RUN \
	cd /root/nim/ && \
	git clone -b master https://github.com/Araq/Nim.git && \
	cd Nim && \
	git checkout 30cc353831a9727cfc6b4e7c379d9920b7041059
RUN \
	cd /root/nim/Nim && \
	git clone -b master --depth 1 git://github.com/nim-lang/csources && \
	cd csources && \
	git checkout 15724e2e1f3e7749d508dfcd995e84fea2850802 && \
	sh build.sh && \
	cd .. && \
	bin/nim c koch && \
	./koch boot -d:release
RUN ln -s /root/nim/Nim/bin/nim /usr/local/bin/nim

# Install Nimble (Nim package manager, v0.6+)
RUN \
	cd /root/nim/ && \
	git clone https://github.com/nim-lang/nimble.git && \
	cd nimble && \
	git checkout ffbd5f5b3ec85a68e179233275ff4ef54cc280a3
RUN \
	cd /root/nim/nimble && \
	nim c -r src/nimble install
RUN ln -s /root/.nimble/bin/nimble /usr/local/bin/nimble
RUN nimble update

# Integration tests
ADD test /tmp/test
RUN bats /tmp/test
