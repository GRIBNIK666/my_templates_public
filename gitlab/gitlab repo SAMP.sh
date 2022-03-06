git add .travis.yml README.md announce dependencies filterscripts gamemodes include npcmodes pawn.yaml samp-npc samp03.sublime-project samp03svr scriptfiles server.cfg
#upload
git push --set-upstream http://90.0.1.70:8080/samp03/samp03.git master
sftp://90.0.1.77/mnt #samp_test docker container path
#https://docs.aws.amazon.com/codecommit/latest/userguide/how-to-mirror-repo-pushes.html
#ADD TO HOSTS http://gitlab.mydomain.local/samp03/samp03.git 

#http://90.0.1.70:8080/samp03/samp03.git WORKS

#/home/samp03 HEAD:test
#/home/samp03-production HEAD:master

#jenkins.local token wVBx-8ejsDFyExKNXEah