#creating var for mounts
export -n DOCKER_MOUNT_PATH && export DOCKER_MOUNT_PATH=/mnt/d_mount
#first run of container
docker run -itd --name samp_test --hostname samp-server.mydomain --mount type=bind,source=$DOCKER_MOUNT_PATH,target=/home centos:8 /bin/sh