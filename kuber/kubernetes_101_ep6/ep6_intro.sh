#ep6_intro.sh
#add helm chart
helm repo add \
	ingress-nginx \
	https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx

#create deployment with 2 httpd pods
kubectl apply -f httpd.yml
#get service info
kubectl get svc \
	ingress-nginx-controller
#check ingress-nginx reachability
curl http://"<node-ip>":"<node-port>"/
#route requests from ingress-nginxconnect to existing httpd deployment
#use httpd-ingress.yml
##WIP
error: error validating "httpd-ingress.yml": error validating data: 
ValidationError(Ingress.spec.rules[0].http.paths[0].backend): 
unknown field "serviceport" in io.k8s.api.networking.v1beta1.IngressBackend; 
if you choose to ignore these errors, turn validation off with --validate=false

