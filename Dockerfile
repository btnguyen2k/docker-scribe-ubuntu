# Dockerfile to build a Facebook Scribe server
# by Thanh Nguyen <btnguyen2k@gmail.com>

# Script to build Fb Scribed on Ubuntu: https://bitbucket.org/agallego/ubuntuscribe/src/d1165abb9cc0/scribe.bash?fileviewer=file-view-default

FROM ubuntu:14.04
MAINTAINER Thanh Nguyen <btnguyen2k@gmail.com>

RUN mkdir -p /tmp

RUN \
	cd /tmp && \
	apt-get update && \
	apt-get install -y --no-install-recommends ca-certificates wget make flex bison libtool libevent-dev automake pkg-config libssl-dev libbz2-dev build-essential g++ python-dev git

RUN \
	cd /tmp && \
	export BOOST_VERSION=45 && \
	wget --no-check-certificate -qO- http://sourceforge.net/projects/boost/files/boost/1.${BOOST_VERSION}.0/boost_1_${BOOST_VERSION}_0.tar.gz/download | tar -xzf - && \
	cd boost_1_${BOOST_VERSION}_0 && \
	./bootstrap.sh --with-libraries=filesystem,program_options,system && \
	./bjam install	#for libboost v2
#	./b2 install	#for libboost v3

COPY install-thrift-scribe.bash /tmp/

RUN cd /tmp && bash install-thrift-scribe.bash

RUN \
	apt-get clean && \
	apt-get autoclean && \
	apt-get autoremove

