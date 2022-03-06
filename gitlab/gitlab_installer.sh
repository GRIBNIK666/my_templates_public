#! /BIN/SH
su root
docker system prune && docker volume prune
export -n GITLAB_LOCAL && export GITLAB_LOCAL=/mnt/distrib/gitlab_workdir
docker run --detach \
  --hostname gitlab.mydomain.net \
  --publish 443:443 --publish 8080:80 --publish 2222:22 \
  --name gitlab \
  --restart always \
  --volume $GITLAB_LOCAL/config:/etc/gitlab \
  --volume $GITLAB_LOCAL/logs:/var/log/gitlab \
  --volume $GITLAB_LOCAL/data:/var/opt/gitlab \
  gitlab/gitlab-ee:latest