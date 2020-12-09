#!/bin/sh

rm -f DataDome-Varnish-latest.tgz
wget https://package.datadome.co/linux/DataDome-Varnish-latest.tgz
tar -zxvf DataDome-Varnish-latest.tgz

cd DataDome-VarnishDome-*
./autogen.sh
./configure

make
make install
