FROM quay.io/refgenomics/docker-ubuntu:14.04

MAINTAINER Nick Greenfield <nick@refgenomics.com>

# Install Git
RUN apt-get install -y git

# Install mercurial (dependency for some Babel packages)
RUN apt-get install -y mercurial

# Install Nim (v0.11.2 release)
RUN mkdir /root/nim/
RUN \
	cd /root/nim/ && \
	git clone -b master https://github.com/Araq/Nim.git && \
	cd Nim && \
	git checkout 45b6082c12dd6fc90a3dd3ca97e1ba157c3d6464
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
	git checkout f7114ca7884d75d1ffc0f2c6e07d8c9a904ebab2
RUN \
	cd /root/nim/nimble && \
	nim c -r src/nimble install
RUN ln -s /root/.nimble/bin/nimble /usr/local/bin/nimble
RUN nimble update

# Integration tests
ADD test /tmp/test
RUN bats /tmp/test
