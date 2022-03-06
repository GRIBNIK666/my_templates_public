#openstack_cli_intro.sh #xena
#also check:https://docs.rackspace.com/blog/openstack-cli-basics.html
#get basic env variables
cat keystonerc_admin
	cat keystonerc_admin |grep OS_
#login to 192.168.*.*/dashboard/auth/login/
	#$OS_AUTH_URL/dashboard/auth/login/
#then get credentials from http://192.168.*.*/dashboard/project/api_access/
#authenticate to nova service #1st way
nova \
--os-username admin \
--os-password * \
--os-project-name admin \
--os-auth-url http://192.168.*.*:5000 \
list
#authenticate #2nd way
nova \
--os-user-id * \
--os-password * \
--os-project-id * \
--os-auth-url http://192.168.*.*:5000 \
list
#export openstack credentials
export OPCR=--os-user-id * --os-password * --os-project-id * --os-auth-url http://192.168.*.*:5000
#show commands 
nova --help | awk '/Positional arguments:/,/Optional arguments:/'
##show all instances
nova $OPCR list
##show instances running on specific hypervisor
nova $OPCR hypervisor-servers '<hostname>' #ex: openstack-node1.mydomain.local
#
#