##LEGACY GUIDE FROM /compilers/pawn.sh
#ln -s /usr/lib/x86_64-linux-gnu /usr/lib64
#	find /usr/ -name crti*
# 		export LIBRARY_PATH=/usr/lib64:$LIBRARY_PATH
rm -rf ~/pawn
cd ~
git clone https://github.com/Zeex/pawn.git ~/pawn
cd ~/pawn
mkdir build && cd build
cmake ../source/compiler -DCMAKE_C_FLAGS=-m32 -DCMAKE_BUILD_TYPE=Release
make
#cp /usr/lib64/crti.o /etc/alternatives/ld
##LEGACY GUIDE FROM /compilers/pawn.sh
#
#
##UP-TO-DATE
#install sampctl
curl https://raw.githubusercontent.com/Southclaws/sampctl/master/install-rpm.sh | sh
#install dependencies
yum clean packages && cd ~
yum install -y git libgcc*i686 libstdc++*i686 glibc*i686 libgfortran*i686 --allowerasing
	#(or) yum install -y git gcc*i686 --allowerasing
#
# $sampctl server download --download last server version
yum install git
sampctl package install sampctl/samp-stdlib
#init
sampctl init
#build
sampctl package run --verbose --forceBuild --forceEnsure