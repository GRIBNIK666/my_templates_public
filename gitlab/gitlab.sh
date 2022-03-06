https://docs.gitlab.com/ee/administration/
##export GITLAB_HOME=/srv/gitlab

#docker run --detach \
#  --hostname gitlab.mydomain.net \
#  --publish 443:443 --publish 80:80 --publish 22:22 \
#  --name gitlab \
#  --restart always \
#  --volume $GITLAB_HOME/config:/etc/gitlab \
#  --volume $GITLAB_HOME/logs:/var/log/gitlab \
#  --volume $GITLAB_HOME/data:/var/opt/gitlab \
#  gitlab/gitlab-ee:latest
#/*
export GITLAB_LOCAL=/srv/gitlab
docker run --detach \
  --hostname gitlab.mydomain.local \
  --publish 443:443 --publish 8080:80 --publish 2222:22 \
  --name gitlab \
  --restart always \
  --volume $GITLAB_LOCAL/config:/etc/gitlab \
  --volume $GITLAB_LOCAL/logs:/var/log/gitlab \
  --volume $GITLAB_LOCAL/data:/var/opt/gitlab \
  gitlab/gitlab-ee:latest
#*/
#--permissions
chown -R USERNAME /srv/gitlab
#(change owner to all subfolder and files inside directory)
find /srv/gitlab -type d -exec chmod 755 {} \;
#(grant rwx-rx-rx to all subfolders and files inside directory)
#--root pass
docker exec -it 056ed50c1815 /bin/sh
vi /etc/gitlab/initial_root_password
#git config --global credential.helper store --save password and login