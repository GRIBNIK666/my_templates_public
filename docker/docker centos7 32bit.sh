#docker run -itd \
#>   --name i386/centos:centos7.9.2009 /bin/bash \
#>   --mount type=bind,source=/opt/docker-opensuse,target=/opt
#working settings
docker run -itd --mount type=bind,source=/opt/docker-opensuse,target=/opt i386/centos:centos7.9.2009
unzip compiler-master.zip -d /opt/docker-opensuse
#check arch
uname -m #arch
getconf LONG_BIT #32/64
#
yum install cmake gcc
yum install gcc gcc-c++