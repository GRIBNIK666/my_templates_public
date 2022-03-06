##7zip_install.sh
yum repolist
yum install -y -q epel-release
yum install -y -q p7zip p7zip-plugins

#usage
7za --help
#extract to dir
7za x -o/<dest-dir> <source-file>.7z
