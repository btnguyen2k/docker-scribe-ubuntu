#!/bin/bash

# credit: https://bitbucket.org/agallego/ubuntuscribe/src/d1165abb9cc0/scribe.bash?fileviewer=file-view-default

cd /tmp

echo "git cloning Thrift"
git clone https://github.com/apache/thrift.git
pushd thrift
	#git fetch
	#git branch -a
	git checkout 0.9.2
	./bootstrap.sh
	./configure

	#fix the fatal error "thrifty.h not found"
	pushd compiler/cpp
		make
		mv thrifty.hh thrifty.h
	popd

	make
	sudo make install

	## at thrift directory
	#pushd lib/py
	#	sudo python setup.py install
	#popd

	echo "Now installing fb303..."
	pushd contrib/fb303
		#in thrift/contrib/fb303 directory
		./bootstrap.sh
		./configure CPPFLAGS="-DHAVE_INTTYPES_H -DHAVE_NETINET_IN_H"
		make
		sudo make install

		#echo "Install Python Module for Thrift and fb303"
		#pushd py
		#	sudo python setup.py install
		#	echo "To check that the python modules have been installed properly, run:"
		#	python -c 'import thrift' ; python -c 'import fb303'
		#popd
	popd
popd

echo "Installing Scribe..."
#git clone https://github.com/facebookarchive/scribe.git
#git clone https://github.com/abhishekdelta/scribe.git
git clone https://github.com/btnguyen2k/scribe.git
pushd scribe
	./bootstrap.sh
	./configure CPPFLAGS="-DHAVE_INTTYPES_H -DHAVE_NETINET_IN_H -DBOOST_FILESYSTEM_VERSION=2" LIBS="-lboost_system -lboost_filesystem"
	make
	sudo make install

	echo "Export an environment variable"
	export LD_LIBRARY_PATH=/usr/local/lib
	echo "export LD_LIBRARY_PATH=/usr/local/lib" >> ~/.bashrc

	#echo "Install Python Module for Scribe"
	#pushd lib/py
	#	sudo python setup.py install
	#	echo "poor-man's Checking that the python modules have been install properly"
	#	python -c 'import scribe'
	#popd
popd

echo "DONE. "

