#list nodes
kubectl get nodes 
	#get dense info
	kubectl get nodes -o wide
#get running pods (srv)
kubectl get pods #using default namespace
kubectl get pods --all-namespaces -o wide
#get more info on deployed service
kubectl get replicasets
kubectl describe replicasets
#Deploy using CLI (prefered to create deployment)
kubectl create deployment <name> --image=<image:tag>
	#get deployed services
	kubectl get deployments
	kubectl delete deployment #rmv
	kubectl describe deployment <servicename>
#then create service
kubectl create service <type> <dep-name> --<protocol>=<hostport>:<container>
#Types: clusterip externalname loadbalancer nodeport
#kubectl create service clusterip nginx-latest --tcp=8080:80
	kubectl get svc #show running services
	kubectl describe service <servicename>
#
kubectl get pod -l app=test-deployment

kubectl describe pod -l app="<deployment-name>"
	#debug nodes inet and master node connectivity
	ansible -i inventory all -a 'ping google.com -c 3'
	ansible -i inventory all -a 'ping 90.0.1.30 -c 3'
#secrets
#src:https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/
kubectl create secret docker-registry "<secret-name>" \
	--docker-username=GRIBNIK666 \
	--docker-password="<access-token>" \
	--docker-email=alekskudrys@gmail.com

	#--docker-server='' \
#read secret
kubectl get secret "<secret-name>" -o jsonpath='{.data}' #returns '<output>'
echo '<output>' |base64 --decode
	#update secret
	kubectl delete secret "<secret-name>"
	kubectl create secret docker-registry "<secret-name>"
	#
kubectl get secrets

kubectl edit deployment "<deployment-name>"
#add
...
spec:
...
 spec:
   imagePullSecrets:
   - name: "<secret-name>"
...
#
kubectl describe pod -l app="<deployment-name>"

kubectl expose deployment \
	"<deployment-name>" --port=8080 \
	--target-port=80 \
	--type=NodePort

kubectl get service "<deployment-name>"
#how to scale app through cli
kubectl edit deployment "<deployment-name>"
#edit
	...
	spec:
	  replicas: "<value>"
	...
#
##Update image for running deployment
#1st)
kubectl edit deployment "<deployment-name>"
	#edit
	    spec:
      containers:
      - image: "<image>:<tag>"
	#
#2nd) 
kubectl set image deployment/"<deployment-name>" \
	"<container-name>"="<image>:<tag>"
		kubectl describe deployment test-deployment |grep Image
##Manage rollouts
kubectl rollout "<arg>" "<resource-type>" "<resource-name>"
'resources:
 - deployment
 - daemonset
 - statefulset'
	#example
	kubectl rollout status deployment test-deployment
	kubectl rollout history deployment test-deployment #current and prev revisions
#roll back to previous version of deployment.yml
kubectl rollout undo deployment "<deployment-name>"
	#by creating new rev "deployment.kubernetes.io/revision: "$revision_count+1"
#
