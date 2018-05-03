#!/bin/bash
# This script is tested on CentOS 7.3

# install dependentcy packages
yum install -y make gcc perl pcre-devel zlib-devel openssl-devel wget

# Download and extract source
wget -O /usr/local/src/haproxy.tgz http://www.haproxy.org/download/1.8/src/haproxy-1.8.8.tar.gz
tar -zxvf /usr/local/src/haproxy.tgz -C /usr/local/src/
cd /usr/local/src/haproxy-*

# time to compile HAProxy
# Notice from HaProxy document https://github.com/haproxy/haproxy/blob/master/README

make TARGET=linux2628 USE_LINUX_TPROXY=1 USE_ZLIB=1 USE_REGPARM=1 USE_PCRE=1 USE_PCRE_JIT=1 USE_OPENSSL=1 SSL_INC=/usr/include SSL_LIB=/usr/lib ADDLIB=-ldl CFLAGS="-O2 -g -fno-strict-aliasing -DTCP_USER_TIMEOUT=18"
make install
useradd -d /var/lib/haproxy -s /sbin/nologin haproxy

# Download sample configure and systemd unit file
mkdir /etc/haproxy
wget -O /etc/haproxy/haproxy.cfg https://raw.githubusercontent.com/vynt-kenshiro/build-haproxy18-centos7/master/haproxy-example.cfg
wget -O /lib/systemd/system/haproxy.service https://raw.githubusercontent.com/vynt-kenshiro/build-haproxy18-centos7/master/haproxy.service

# Enable haproxy service
systemctl enable haproxy
