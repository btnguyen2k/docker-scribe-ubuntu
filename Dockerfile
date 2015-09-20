# Dockerfile to build a Facebook Scribe server
# by Thanh Nguyen <btnguyen2k@gmail.com>

# Script to build Fb Scribed on Ubuntu: https://bitbucket.org/agallego/ubuntuscribe/src/d1165abb9cc0/scribe.bash?fileviewer=file-view-default

FROM ubuntu:14.04
MAINTAINER Thanh Nguyen <btnguyen2k@gmail.com>

RUN mkdir -p /tmp

RUN \
	cd /tmp && \
	apt-get update && \
	apt-get install -y --no-install-recommends ca-certificates wget make flex bison libtool libevent-dev automake pkg-config libssl-dev libbz2-dev build-essential g++ python-dev git libboost-all-dev && \
	git clone https://github.com/apache/thrift.git && \
	cd /tmp/thrift && \
	git checkout 0.9.2 && \
	./bootstrap.sh && \
	./configure && \
	make && make install && \
	cd /tmp/thrift/contrib/fb303 && \
	./bootstrap.sh && \
	./configure CPPFLAGS="-DHAVE_INTTYPES_H -DHAVE_NETINET_IN_H" && \
	make && make install && \
	cd /tmp && \
	git clone https://github.com/btnguyen2k/scribe.git && \
	cd /tmp/scribe && \
	./bootstrap.sh && \
	./configure CPPFLAGS="-DHAVE_INTTYPES_H -DHAVE_NETINET_IN_H -DBOOST_FILESYSTEM_VERSION=2" LIBS="-lboost_system -lboost_filesystem" && \
	make CPPFLAGS="-DHAVE_INTTYPES_H -DHAVE_NETINET_IN_H -DBOOST_FILESYSTEM_VERSION=3" && \
	make install

ENV LD_LIBRARY_PATH /usr/local/lib

RUN \
	apt-get clean && \
	apt-get autoclean && \
	apt-get autoremove

