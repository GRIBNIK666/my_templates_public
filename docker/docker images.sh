docker run -it centos /bin/sh
docker exec -it 447992e1ec66 /bin/sh #docker exec [options] [containerid] [command]
#
#list changes compared to base image
docker diff 447992e1ec66 #docker diff <containerid>
	#explained:
	#	"C /var/lib/dnf" --changed
	#	"A /var/lib/dnf/history.sqlite-shm" --added
	#	"D /var/lib/dnf/history.sqlite-shm" --deleted
#create image out of your container
docker commit 447992e1ec66 my_centos_aboba #docker commit <container_id> <repo/imagename:tag>
#
#exporting CONTAINER into image file
	docker export red_panda > latest.tar
	docker export --output="latest.tar" red_panda #docker export --output=<filename.ext> <repo/imagename:tag>((current tag))
#exporting IMAGE into image file
	docker save --output="latest.tar" #docker save --output=<filename.ext> <repo/imagename:tag>((current tag))
#import image
	docker import http://example.com/exampleimage.tgz #import from URL or PATH
	#STDIN method
	cat exampleimage.tgz | docker import - <repo/imagename:tag>
	cat exampleimage.tgz | docker import --message "New image imported from tarball" - <repo/imagename:tag>
#tar -c . | docker import <filename.ext> --rename <repo/imagename:tag> image
#
docker image 
	tag d0c4744bfc12 #current imageid 
	gribnik666/docker-swarm-course:python-test #new <repo/imagename:tag>