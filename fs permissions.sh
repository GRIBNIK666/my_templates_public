#change owner to all subfolder and files inside directory
chown -R USERNAME /srv/gitlab
#grant rwx-rx-rx to all subfolders and files inside directory
find /srv/gitlab -type d -exec chmod 755 {} \;
#
	#To find a user's UID or GID in Unix, use the id command
	id -u username
	#Replace username with the appropriate user's username
	id -g username
	#If you wish to find out all the groups a user belongs to
	id -G username
	#If you wish to see the UID and all groups associated with a user
	id username
#https://www.pluralsight.com/blog/it-ops/linux-file-permissions@
#
#How to change directory
#permissions in Linux
#To change directory permissions in Linux, use the following:
#chmod +rwx filename to add permissions.
#chmod -rwx directoryname to remove permissions.
#chmod +x filename to allow executable permissions.
#chmod -wx filename to take out write and executable permissions.
#Note that “r” is for read, “w” is for write, and “x” is for execute.
#
#This only changes the permissions for the owner of the file.
#
#How to Change Directory Permissions in Linux for the Group Owners and Others
#The command for changing directory permissions for group owners is similar, but add a “g” for group or “o” for users:
#ch
#chmod g+w filename
#chmod g-wx filename
#chmod o+w filename
#chmod o-rwx foldername
#
#To change directory permissions for everyone, use “u” for users, “g” for group, “o” for others, and “ugo” or “a” (for all).
#
#chmod ugo+rwx foldername to give read, write, and execute to everyone.
#chmod a=r foldername to give only read permission for everyone.
#
#How to Change Groups of Files and Directories in Linux
#By issuing these commands, you can change groups of files and directories in Linux. 
#
#chgrp groupname filename
#chgrp groupname foldername
#Note that the group must exit before you can assign groups to files and directories.
#
#How to Change Ownership in Linux
#Another helpful command is changing ownerships of files and directories in Linux:
#
#chown name filename
#chown name foldername
#
#These commands will give ownership to someone, but all sub files and directories still belong to the original owner.
#
#You can also combine the group and ownership command by using:
#
#chown -R name:filename /home/name/directoryname
#
#How to Change Permissions in Numeric Code in Linux
#You may need to know how to change permissions in numeric code in Linux, so to do this you use numbers instead of “r”, “w”, or “x”.
#0 = No Permission
#1 = Execute
#2 = Write
#4 = Read
#
#Permission numbers are:
#
#0 = ---
#1 = --x
#2 = -w-
#3 = -wx
#4 = r-
#5 = r-x
#6 = rw-
#7 = rwx
#
#For example:
#chmod 777 foldername will give read, write, and execute permissions for everyone.
#chmod 700 foldername will give read, write, and execute permissions for the user only.
#chmod 327 foldername will give write and execute (3) permission for the user, w (2) for the group, and read, write, and execute for the users.