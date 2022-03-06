kubernetes_DEPLOYMENT.sh
#Kubernetes hierarchy
	#Namespace:
		#Deployments:
				#Pods:
					#Container
					#Container
					#...
#http://www.yamllint.com/
#Creating kube deployment via .YAML file
#HOW TO DEPLOY via .yaml using kubectl
kubectl create -f <path to file>
	#eg file.yaml or /path/file.yaml
#try v4
apiVersion: apps/v1 #default api
kind: Deployment #default type ((or Pod))
metadata:
  name: nginx-deployment #deployment name
spec:
  selector:
    matchLabels:
      app: nginx #selector lable for Resource information
  replicas: 1 #number of pods running
  template:
    metadata:
      labels:
        app: nginx #Replica Set label "app: nginx"
    spec:
      containers:
      - name: nginx #Container Name
        image: nginx:latest #<repo>/<image>:<tag>
        ports:
        - containerPort: 80 #port inside container, create service to expose
          protocol: TCP #connection protocol
      - name: back-end #Container Name
        image: httpd:latest #<repo>/<image>:<tag>
        ports:
        - containerPort: 88 #port inside container, create service to expose
          protocol: TCP #connection protocol
strategy:
  type: RollingUpdate
  rollingUpdate: 
   maxUnavailable: 25% 
   maxSurge: 25% 
  revisionHistoryLimit: 10 
  progressDeadlineSeconds: 600
#...