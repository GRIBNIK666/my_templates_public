#ctrl+z to leave program
	#list services
	systemctl list-unit-files
#enabled services
systemctl list-unit-files |grep enabled
#
#manage service
systemctl start/stop/status/restart "<servicename>"
#manage machine
systemctl reboot/poweroff 
#enable/disable on boot
systemctl enable/disable "<systemd-servicename>"
#query to systemctl #is-enabled=on-boot
systemctl is-enabled/active "<servicename>" 
#re-init services
systemctl daemon-reload