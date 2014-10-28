FROM quay.io/refgenomics/docker-ubuntu:14.04

MAINTAINER Nick Greenfield <nick@refgenomics.com>

# Install Git
RUN apt-get install -y git

# Install mercurial (dependency for some Babel packages)
RUN apt-get install -y mercurial

# Install Nim (v0.9.6 with patch, near v0.9.8 release)
RUN mkdir /root/nim/
RUN \
	cd /root/nim/ && \
	git clone https://github.com/Araq/Nimrod.git && \
	cd Nimrod && \
	git checkout d5b94390dcfe61c645b43305e3673b6c696b39c7
RUN \
	cd /root/nim/Nimrod && \
	git clone --depth 1 git://github.com/nimrod-code/csources && \
	cd csources && \
	git checkout ddcc0f31f02d9ea5fe1e54e4fb20b8e185988d75 && \
	sh build.sh && \
	cd .. && \
	bin/nimrod c koch && \
	./koch boot -d:release
RUN ln -s /root/nim/Nimrod/bin/nimrod /usr/local/bin/nimrod && ln -s /root/nim/Nimrod/bin/nimrod /usr/local/bin/nim

# Install Nimble (Nim package manager)
RUN \
	cd /root/nim/ && \
	git clone https://github.com/nimrod-code/nimble.git && \
	cd nimble && \
	git checkout v0.4
RUN \
	cd /root/nim/nimble && \
	nimrod c -r src/babel install
RUN ln -s /root/.babel/bin/babel /usr/local/bin/babel
RUN babel update

# Integration tests
ADD test /tmp/test
RUN bats /tmp/test
