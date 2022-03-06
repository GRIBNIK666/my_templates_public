##git_clone.sh
#goto repo dir
cd <dir>
#initialize local git repo
git init
#download remote git repo
git clone \
	https://<username>:<personal-access-token>@github.com/<username>/<repo>.git
#