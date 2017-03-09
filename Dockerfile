FROM quay.io/refgenomics/docker-ubuntu:14.04

MAINTAINER Nick Greenfield <nick@refgenomics.com>

# Update
RUN apt-get update -y

# Install Git
RUN apt-get install -y git

# Install mercurial (dependency for some Babel packages)
RUN apt-get install -y mercurial

# Install Nim (v0.16 release)
RUN mkdir /root/nim/
RUN \
	cd /root/nim/ && \
	git clone -b master https://github.com/nim-lang/Nim.git && \
	cd Nim && \
	git checkout b040f74356748653dab491e0c2796549c1db4ac3
RUN \
	cd /root/nim/Nim && \
	git clone -b master --depth 1 git://github.com/nim-lang/csources && \
	cd csources && \
	git checkout cdd0f3ff527a6a905fd9e821f381983af45b65de && \
	sh build.sh && \
	cd .. && \
	bin/nim c koch && \
	./koch boot -d:release
RUN ln -s /root/nim/Nim/bin/nim /usr/local/bin/nim

# Install Nimble (Nim package manager, v0.8.4)
RUN \
	cd /root/nim/ && \
	git clone https://github.com/nim-lang/nimble.git && \
	cd nimble && \
	git checkout 0a280aa6dd0c7566fbf70775b69f33b100f2d1de
RUN \
	cd /root/nim/nimble && \
	nim c -r src/nimble install -y
RUN ln -s /root/.nimble/bin/nimble /usr/local/bin/nimble
RUN nimble update

# Integration tests
ADD test /tmp/test
RUN bats /tmp/test
