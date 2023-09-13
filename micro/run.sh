#!/bin/sh
rm -rf /tmp/min
mkdir /tmp/min
cbsd copy-binlib chaselibs=1 basedir=/ dstdir=/tmp/min filelist=/root/micro/list.txt.doc verbose=1
