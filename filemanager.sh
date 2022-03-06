#create file
touch <filename.ext> 
#--help for all arguments
	#list files and folders in directory)
	ls 
	ls -1
	#<permission> 1 <owner> <group> <size> <date time> <file>
	ls -lah
#
#current folder
pwd
#
#go back ../..
cd ..
mkdir dirname #((or)) <path>/<dirname>
#create dir tree
mkdir -p <dirname1>/<dirname2>/<dirname3>/<dirname4>
#delete empty dir
rmdir <dirname>
#delete empty dir
rm -d(dir) <dirname>
#delete dir with files
	rm -r <dirname>
#delete non-empty dir and all contents
#would ask to delete each item
	rm -ri <dirname1> <dirname2> 
#delete multiple non-empty dirs and all contents
rm -rf <dirname>
#delete write-protected dir
	#remove dirs with name like *name
	rm -r <*name>
#
#delete empty dirs in path
find /<dirname> -type d(only dirs) -empty -delete #-type d = only dirs
#delete all files in dir AND delete folder itself
find /<dirname> -type f -delete && rm -r /dirname #-type f = files
#copy folder with contents
cp -r <path> <dest path>
#rename files with specific extension
rename <current-ext> <new-ext> *.<current-ext> #in current dir
	#ex.: rename txt sql *.txt 
find /<path> -name "*.<current-ext>" -exec rename <current-ext> <new-ext> *.<current-ext> {} \;
#
