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
	git clone https://github.com/Araq/Nimrod.git && \
	cd Nimrod && \
	git checkout 2d43fcafe0cedd4f78611dddccc31e1bef432aab
RUN \
	cd /root/nim/Nimrod && \
	git clone --depth 1 git://github.com/nim-lang/csources && \
	cd csources && \
	git checkout 2c54ca57bf15b810e944a0ea35a6296d1482f7b6 && \
	sh build.sh && \
	cd .. && \
	bin/nim c koch && \
	./koch boot -d:release
RUN ln -s /root/nim/Nimrod/bin/nim /usr/local/bin/nim

# Install Nimble (Nim package manager)
RUN \
	cd /root/nim/ && \
	git clone https://github.com/nim-lang/nimble.git && \
	cd nimble && \
	git checkout b208b6674960f696226a8c480bb0f5b1f227433a
RUN \
	cd /root/nim/nimble && \
	nim c -r src/nimble install
RUN ln -s /root/.nimble/bin/nimble /usr/local/bin/nimble
RUN nimble update

# Integration tests
ADD test /tmp/test
RUN bats /tmp/test
