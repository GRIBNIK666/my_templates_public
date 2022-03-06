yum install git
git config --global user.name <text>
git config --global user.email <text>
#configure credentials
	#create local repository && list hidden folders
	git init && ls -a
git status #list current uncommited files
touch index.html #create test file
git add index.html #add new file
git commit -m "text" #-m <commit message>
	#git commit --help for other options
git log #changelog
	#remote git server more
	#https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository
#http://localhost:1234/ instaweb
#use sublime
git mv file_from file_to #rename
git log --stat -p -2 #-p to show changes+difference #num of entries 
	git log --pretty=oneline #apply format
git commit --amend #edit last commit