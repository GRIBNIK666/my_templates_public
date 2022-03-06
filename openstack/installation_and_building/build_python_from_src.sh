#try_python.sh
#try python3.8!
	#add dns servers to inet adapter 8.8.8.8 8.8.4.4
	##add python3 3.6-3.8
	#
	pip install --upgrade pip
	python3 -m pip install pypowervm

	#
	#
	#how to upgrade python3
yum -y groupinstall "Development Tools"
yum -y install openssl-devel bzip2-devel libffi-devel xz-devel wget
cd /tmp
wget https://www.python.org/ftp/python/3.9.9/Python-3.9.9.tgz
#wget https://www.python.org/ftp/python/3.10.0/Python-3.10.0.tgz
tar xvf Python-3.*.tgz
cd Python-3.*/
./configure --enable-optimizations
make altinstall
python3.9.9 --version
#install python380
yum -y groupinstall "Development Tools"
yum -y install openssl-devel bzip2-devel libffi-devel xz-devel wget
cd /tmp
wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz
#wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0tgz
tar xvf Python-3.*.tgz
cd Python-3.*/
./configure --enable-optimizations
make altinstall
python3.8.0 --version