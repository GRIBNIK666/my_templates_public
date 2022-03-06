#RUN to run command during building container
# cd to work dir or specify one, then create file "Dockerfile" with contents:
FROM centos #image name)
#1st layer
RUN yum install telnet -y && yum install iputils -y
#2nd layer
RUN mkdir -p /app (create /app directory)
#copy from absolute path (or workdir) to /app directory)
COPY sample.txt((workdir path)) /app 
	ADD #file from remote url
	WORKDIR
ENTRYPOINT ["ping"] #autorun command)
CMD ["-c", "3", "8.8.8.8"] #autorun command params overridable
#
FROM my_centos_aboba
RUN yum install telnet -y && yum install iputils -y
RUN mkdir -p /app
COPY sample.txt /app
ENTRYPOINT ["ping"]
CMD ["-c", "3", "8.8.8.8"]
#
#create docker image (from other image) using docker file
	#usage: -t <repo>/<image>:<tag> (for new image)
docker build -t my_centos . #destination dir
#after building
docker run -it mycentos #going to run "ping -c 3 8.8.8.8" on boot
#HOW TO override CMD
docker run -it mycentos -c 15 8.8.8.8 #override params
#you can't run/exec image with other boot params, other commands are IGNORED)
	#collect shell logs from dead container
	docker logs <containerid> 
#override "entrypoint" (then you will be able to EXEC any command)
docker run -it --entrypoint /bin/sh mycentos #docker run -it --entrypoint <command> <repo>/<image>:<tag>