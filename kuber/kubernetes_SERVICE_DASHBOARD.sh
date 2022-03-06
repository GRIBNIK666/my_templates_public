#creating service account for dashboard
kubectl create serviceaccount dashboard -n default
	#serviceaccount/dashboard created
#add cluster binding rules for existing roles on dashboard
kubectl create clusterrolebinding dashboard-admin -n default \
	--clusterrole=cluster-admin \
	--serviceaccount=default:dashboard
	#-n for --namespace "default"
	#clusterrolebinding.rbac.authorization.k8s.io/dashboard-admin created
#get secret key for login
kubectl get secret $(kubectl get serviceaccount dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode
	#output
eyJhbGciOiJSUzI1NiIsImtpZCI6Ijl5VndPOUJyQmhVYV9sZDRlX2VGOE1tREswanZDMDZLckFQUTRMd01SVTAifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImRhc2hib2FyZC10b2tlbi1xdmNwNyIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJkYXNoYm9hcmQiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiIxMDBjZjViMS05MjhmLTQwOTQtODIyNi01MGNmNDFmZjJjYTkiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6ZGVmYXVsdDpkYXNoYm9hcmQifQ.Bk9jXAn_yyZQ_ceIAlEWpy1EAZP9FFV-l4-UFMXinNGRbVwR2rJetglCvifaNK81gwwvZNnrLSH8yUDw1315RXaWkuXe8qubTPUhGB-UuLfViPSyKYPuYGGxjO5_IsujHdQNZV-bWCdLsyZhIGlbvYxvA6p0HpNDT-AVmjyaouxa_OgyAn21ujo3rGxC3ywUuTbPhYmtHNhmBEXfB2ua2rlGPve1yFKcswbAKfAdLW-ad4MF52D8MBtRzIj3jltPtg0_mf0TeWMVMTb1cXQSBlGjiMB7dYoxbPmQZkr9RVudLaKosvNdBUPEYam5KqVpvvB9xsvcvXReB2A0P0Q0Bg
#
kubectl -n kubernetes-dashboard get service kubernetes-dashboard #get address inside CNI
kubectl cluster-info #Kubernetes control plane and CoreDNS IPs is
#2ND way to start dashboard in port-forwarding mode
kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8080:443 #<guest-port>:<host>
#You should see yaml representation of the service
kubectl -n kubernetes-dashboard edit service kubernetes-dashboard #edit service cfg #Change type: ClusterIP to type: <<NodePort>> and save file
#OUTPUT:exposed port 443:>30733</TCP
#(secure) dashboard address: https://90.0.1.30:30733/ #90.0.1.30 is cube-master.mydomain ip inside VM cluster
#CREATE join token for slave nodes
kubeadm token create --print-join-command
	#output kubeadm join 90.0.1.30:6443 --token sz3hou.klil0gt3y22s5jmd --discovery-token-ca-cert-hash sha256:9d6d04add1d8bd1d385a5c89623bf802c8d71fba9068302c52f1b7435fac378c
#DEPLOYING SERVICE from FORM (WebUI)
	$App name #label with this value will be added to the Deployment and Service that get deployed
	$Container image #the URL of a public image on any registry, or a private image hosted on Docker Hub or Google Container Registry
	$Number of pods #Deployment will be created to maintain the desired number of pods across your cluster
	$Service type #External (accesible from node address)/ Internal
	$Port #(HOST port)
	$Target port #container port #an internal or external Service can be defined to map an incoming Port to a target Port seen by the container
	$Protocol #TCP/UDP
	$Run command #entrypoint command
	$Run command arguments #args
	#Environment variables
	$Name
	$Value
#HOW TO MAKE NEW SERVICE ACCESSIBLE IN VLAN
#...*.yaml Service Config (Use $Service type #Internal for $ClusterIP type, then set externalIPs: <node ip>)
  type: ClusterIP
  externalIPs:
    - 90.0.1.31
  sessionAffinity: None
  ipFamilies:
    - IPv4
  ipFamilyPolicy: SingleStack
status:
  loadBalancer: {}
 #Configuring LOAD BALANCER
kubectl get replicasets
kubectl describe replicasets
kubectl expose deployment <servicename> --type=LoadBalancer --name=<loadBalancer-name>
#HOW TO MAKE BALANCER ACCESSIBLE IN VLAN
#...*.yaml Service Config
spec:
  ports:
    - protocol: TCP
      port: <EXTERNAL_PORT>
      targetPort: <ORIGIN_SERVICE_PORT>
      nodePort: 31606
  type: LoadBalancer
	# ...
  externalIPs:
    - 90.0.1.31
    - 90.0.1.32 #<<nodes IP