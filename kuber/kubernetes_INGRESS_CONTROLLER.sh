#kubernetes_ingress_controller.sh
#manifest src: https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-manifests/
'Controls access to direct IP-address:port via DNS-name.
	sample-proxy.com/v1 << NodePort-Service:Port1
	sample-proxy.com/v2 << NodePort-Service:Port2
Ingress controller should be deployed before building ingress resources.
Example based on nginx (ingress controller).'
#
#remove existing installation
kubectl delete namespace nginx-ingress
kubectl delete clusterrole nginx-ingress
kubectl delete clusterrolebinding nginx-ingress
kubectl delete -f common/crds/
#
#installation
git clone https://github.com/nginxinc/kubernetes-ingress/
cd kubernetes-ingress/deployments
#
#create namespace and service account
kubectl apply -f common/ns-and-sa.yaml
#BOF
	apiVersion: v1
	kind: Namespace
	metadata:
	  name: nginx-ingress 
	---
	apiVersion: v1
	kind: ServiceAccount
	metadata:
	  name: nginx-ingress
	  namespace: nginx-ingress
#EOF
	kubectl config set-context --current --namespace=nginx-ingress
#create a cluster role and cluster role binding for the service account
kubectl apply -f rbac/rbac.yaml
#create the app protect role and role binding
kubectl apply -f rbac/ap-rbac.yaml
#create a secret with a TLS certificate and a key for the default server in NGINX
kubectl apply -f common/default-server-secret.yaml
#create a config map for customizing NGINX configuration
kubectl apply -f common/nginx-config.yaml
#create an IngressClass resource (for Kubernetes >= 1.18)
kubectl apply -f common/ingress-class.yaml
#
#create custom resource definitions for VirtualServer and VirtualServerRoute , TransportServer and Policy resources
kubectl apply -f common/crds/k8s.nginx.org_virtualservers.yaml
kubectl apply -f common/crds/k8s.nginx.org_virtualserverroutes.yaml
kubectl apply -f common/crds/k8s.nginx.org_transportservers.yaml
kubectl apply -f common/crds/k8s.nginx.org_policies.yaml
#create a custom resource definition for GlobalConfiguration resource
kubectl apply -f common/crds/k8s.nginx.org_globalconfigurations.yaml
#create a custom resource definition for APPolicy, APLogConf and APUserSig
kubectl apply -f common/crds/appprotect.f5.com_aplogconfs.yaml
kubectl apply -f common/crds/appprotect.f5.com_appolicies.yaml
kubectl apply -f common/crds/appprotect.f5.com_apusersigs.yaml
#deploying nginx ingress controller in kubernetes cluster
	#I. run the ingress controller as deployment
	kubectl apply -f deployment/nginx-ingress.yaml
	#II. run the ingress controller as daemon-set
	kubectl apply -f daemon-set/nginx-ingress.yaml
#verify status
kubectl get pods --namespace=nginx-ingress
	kubectl get svc --namespace=nginx-ingress
#I. create a service for the Ingress Controller Pods using a NodePort service
kubectl create -f service/nodeport.yaml
#II. for GCP or Azure use a LoadBalancer service
kubectl apply -f service/loadbalancer.yaml
#