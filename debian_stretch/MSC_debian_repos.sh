#MSC_debian_repos.sh
#src: https://linuxconfig.org/how-to-create-a-ubuntu-repository-server http://ftp.br.debian.org/debian/pool/main/
#add to repo-server internet repos
rm -rf /etc/apt/sources.list \ 
touch /etc/apt/sources.list \ 
echo 'deb http://ftp.debian.org/debian stretch main contrib non-free' >> /etc/apt/sources.list \ 
echo 'deb-src http://ftp.debian.org/debian stretch main contrib non-free' >> /etc/apt/sources.list \ 
echo 'deb http://ftp.debian.org/debian stretch-updates main contrib non-free' >> /etc/apt/sources.list \ 
echo 'deb-src http://ftp.debian.org/debian stretch-updates main contrib non-free' >> /etc/apt/sources.list
#
apt --fix-broken install
#download dependencies
apt-get install apt-rdepends
#download packages for repo
	apt-get download "<package1>" "<package2>" ...
	#download all dependencies for package
	apt-get download $(apt-rdepends "<package>"|grep -v "^ " |grep -v "^libc-dev$")
	#links
		#download apt-rdepends dependencies
		wget "http://ftp.br.debian.org/debian/pool/main/*"

#setup local repo
apt-get install apache2 dpkg-dev && systemctl enable apache2 \ 
mkdir -p /var/www/html/debs/amd64 && chown www-data:www-data /var/www/html/debs/amd64 \ 
ls -lah /var/www/html/debs/ | grep www-data

#add to Release.file at repo-server /var/www/html/debs/amd64/Release
echo 'Origin: Debian' >> /var/www/html/debs/amd64/Release \ 
echo 'Suite: stable' >> /var/www/html/debs/amd64/Release \ 
echo 'Codename: amd64/' >> /var/www/html/debs/amd64/Release \ 
echo 'Version: 0.1a' >> /var/www/html/debs/amd64/Release \ 
echo 'Date: Wed, 07 Oct 2021 12:00:00 UTC' >> /var/www/html/debs/amd64/Release \ 
echo 'Architectures: amd64' >> /var/www/html/debs/amd64/Release \ 
echo 'Components: amd64' >> /var/www/html/debs/amd64/Release
	#scan existing packages
	cd /var/www/html/debs/
	dpkg-scanpackages amd64 | gzip -9c > amd64/Packages.gz

#configure at client
touch /etc/apt/apt.conf.d/99customcfg \ 
echo 'APT::Get::AllowUnauthenticated "true";' >> /etc/apt/apt.conf.d/99customcfg
#add to sources.list at client
echo 'deb http://deb-repo.localdomain.local/debs/ amd64/' >> /etc/apt/sources.list
#verify
apt-get update


####
#creating repo WITHsignature
cd /var/www/html/debs/amd64/
gpg --full-generate-key
	#lauch second session
	find / | xargs file
#
#SIGN local packages
dpkg-sig -k 5662A37C72BE4E42 --sign builder *.deb #-g "--passphrase 8x8yclkt"
	#troubleshooting error 512
	export GPG_TTY=$(tty)
#
cat /var/www/html/debs/amd64/Release
rm -rf /var/www/html/debs/amd64/Release
mkdir /var/www/html/debs/amd64/conf
touch /var/www/html/debs/amd64/conf/distributions
#/var/www/html/debs/amd64/conf/distributions
echo 'Origin: deb-repo.localdomain.local' >> /var/www/html/debs/amd64/conf/distributions \ 
echo 'Label: apt repository' >> /var/www/html/debs/amd64/conf/distributions \ 
echo 'Codename: amd64' >> /var/www/html/debs/amd64/conf/distributions \ 
echo 'Architectures: amd64' >> /var/www/html/debs/amd64/conf/distributions \ 
echo 'Components: amd64' >> /var/www/html/debs/amd64/conf/distributions \ 
echo 'Description: Debian 9 Stretch repository' >> /var/www/html/debs/amd64/conf/distributions \ 
echo 'SignWith: yes' >> /var/www/html/debs/amd64/conf/distributions \ 
echo 'Pull: amd64' >> /var/www/html/debs/amd64/conf/distributions
#
apt-get install reprepro
#add new packages to repo and then sign with key
reprepro --delete clearvanished && reprepro --ask-passphrase -Vb . includedeb amd64 /var/www/html/debs/amd64/*.deb
gpg --armor --export && touch /var/www/html/debs/amd64/deb-repo.localdomain.local.gpg.key
#
#configure at client
rm -rf /etc/apt/apt.conf.d/*customcfg
sed -i '/deb-repo.localdomain.local/d' /etc/apt/sources.list
#add to sources.list at client
sed -i '/deb-repo.localdomain.local/d' /etc/apt/sources.list
echo 'deb http://deb-repo.localdomain.local/debs/amd64/ amd64 amd64' >> /etc/apt/sources.list
wget -O - http://deb-repo.localdomain.local/debs/amd64/deb-repo.localdomain.local.gpg.key | apt-key add -
#test signature info
Real name: Aleksei Aboba
Email address: aboba@deb-repo.localdomain.local
Comment: repo signature key
You selected this USER-ID:
    "Aleksei Aboba (repo signature key) <aboba@deb-repo.localdomain.local>"
#
gpg: /root/.gnupg/trustdb.gpg: trustdb created
gpg: key 5662A37C72BE4E42 marked as ultimately trusted
gpg: directory '/root/.gnupg/openpgp-revocs.d' created
gpg: revocation certificate stored as '/root/.gnupg/openpgp-revocs.d/6D3F86885852A83C060DE88D5662A37C72BE4E42.rev'
public and secret key created and signed.
pub   rsa1024 2021-10-08 [SC]
      6D3F86885852A83C060DE88D5662A37C72BE4E42
      6D3F86885852A83C060DE88D5662A37C72BE4E42
uid                      Aleksei Aboba (repo signature key) <aboba@deb-repo.localdomain.local>
sub   rsa1024 2021-10-08 [E]
#DONE
##addons
#IMPORT kubernetes packages to repo
cd /var/www/html/debs/amd64/
apt-get download apt-transport-https ca-certificates libcurl3-gnutls curl #debconf
dpkg -i libcurl3-gnutls*.deb apt-transport-https*.deb ca-certificates*.deb curl*.deb
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
#add kubernetes repo to sources
echo 'deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main' >> /etc/apt/sources.list
#src
#echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get download kubelet kubeadm kubectl
	apt-get download $(apt-rdepends kubelet|grep -v "^ " |grep -v "^libc-dev$") \ 
	apt-get download $(apt-rdepends kubeadm|grep -v "^ " |grep -v "^libc-dev$") \ 
	apt-get download $(apt-rdepends kubectl|grep -v "^ " |grep -v "^libc-dev$")
#download dependencies
apt-get download kubernetes-cni cri-tools kubernetes-cni socat ethtool conntrack
	apt-get download $(apt-rdepends kubernetes-cni|grep -v "^ " |grep -v "^libc-dev$") \ 
	apt-get download $(apt-rdepends cri-tools|grep -v "^ " |grep -v "^libc-dev$") \ 
	apt-get download $(apt-rdepends kubernetes-cni|grep -v "^ " |grep -v "^libc-dev$") \ 
	apt-get download $(apt-rdepends socat|grep -v "^ " |grep -v "^libc-dev$") \ 
	apt-get download $(apt-rdepends ethtool|grep -v "^ " |grep -v "^libc-dev$") \ 
	apt-get download $(apt-rdepends conntrack|grep -v "^ " |grep -v "^libc-dev$")
reprepro --delete clearvanished && reprepro --ask-passphrase -Vb . includedeb amd64 /var/www/html/debs/amd64/*.deb
