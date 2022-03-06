docker login 
	docker login -u * -p *
#
#Name your local images using one of these methods:
#When you build them, using 
docker build -t <repo/imagename:tag>
#By tagging an existing local image
docker tag <imageid>/<repo/imagename:tag> <repo/imagename:tag>
#By using
docker commit <containerid>/<containername> <repo/imagename:tag>
#example
docker tag */php:test */docker-swarm-course:php-test #docker tag <current tag> <new tag>
#uploading/downloading image from/to repo
docker push */docker-swarm-course:python-test #docker push <repo/imagename:tag>
docker pull */docker-swarm-course:python-test #docker pull <repo/imagename:tag>