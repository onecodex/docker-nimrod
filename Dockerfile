FROM quay.io/refgenomics/docker-ubuntu:14.04

MAINTAINER Nick Greenfield <nick@refgenomics.com>

# Install Nimrod
RUN mkdir /root/nimrod/ && mkdir /root/nimrod-deprecated/
RUN \
	cd /root/nimrod/ && \
	git clone https://github.com/Araq/Nimrod.git && \
	cd Nimrod && \
	git checkout ba394e6d3649839d73c5ae3a12e6f1ff6d66e802
RUN \
	cd /root/nimrod/Nimrod && \
	git clone --depth 1 git://github.com/nimrod-code/csources && \
	cd csources && \
	sh build.sh && \
	cd .. && \
	bin/nimrod c koch && \
	./koch boot -d:release
RUN ln -s /root/nimrod/Nimrod/bin/nimrod /usr/local/bin/nimrod

# Install Babel (Nimrod package manager)
RUN \
	cd /root/nimrod/ && \
	git clone https://github.com/nimrod-code/babel.git && \
	cd babel && \
	git checkout d30928a97ed3bf957c2e2c15c37174854d38b7e3
RUN \
	cd /root/nimrod/babel && \
	nimrod c -r src/babel install
RUN ln -s /.babel/bin/babel /usr/local/bin/babel
RUN babel update

# Install mercurial (dependency for some Babel packages)
RUN apt-get install -y mercurial

# Integration tests
ADD test /tmp/test
RUN bats /tmp/test
