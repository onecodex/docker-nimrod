FROM quay.io/refgenomics/docker-ubuntu:14.04

MAINTAINER Nick Greenfield <nick@refgenomics.com>

# Install Nim (v0.10 devel, near release)
RUN mkdir /root/nim/
RUN \
	cd /root/nim/ && \
	git clone https://github.com/Araq/Nimrod.git && \
	cd Nimrod && \
	git checkout 201d3c9ed0dac94a337f23416c556b45f7fc1138
RUN \
	cd /root/nim/Nimrod && \
	git clone -b bigbreak --depth 1 git://github.com/nimrod-code/csources && \
	cd csources && \
	git checkout b0bcf88e26730b23d22e2663adf1babb05bd5a71 && \
	sh build.sh && \
	cd .. && \
	bin/nimrod c koch && \
	./koch boot -d:release
RUN ln -s /root/nim/Nimrod/bin/nim /usr/local/bin/nim

# Install Nimble (Nim package manager)
RUN \
	cd /root/nim/ && \
	git clone https://github.com/nimrod-code/nimble.git && \
	cd nimble && \
	git checkout ecd78e0e0300a8178db320d83014d3eb47a89b4c
RUN \
	cd /root/nim/nimble && \
	nim c -r src/nimble install
RUN ln -s /.nimble/bin/nimble /usr/local/bin/nimble
RUN nimble update

# Install mercurial (dependency for some Babel packages)
RUN apt-get install -y mercurial

# Install Git
RUN apt-get install -y git

# Integration tests
ADD test /tmp/test
RUN bats /tmp/test
