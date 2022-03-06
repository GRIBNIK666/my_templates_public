#https://hub.docker.com/r/rikorose/gcc-cmake/
docker pull rikorose/gcc-cmake
docker run --rm -v `pwd`:/usr/src/myapp rikorose/gcc-cmake:<version> command
#
docker run -d \
>   -it \
>   --name cmake:test \
>   --mount type=bind,source=/opt/docker-opensuse,target=/usr/src/myapp \
#
#GOOD
docker run -itd cmake:test