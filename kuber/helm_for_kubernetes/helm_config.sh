#helm_config.sh
#src: https://helm.sh/docs/intro/install/
#	  https://helm.sh/docs/intro/using_helm/
###wget 'https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz'
###tar -xf helm-v3.6.3-linux-amd64.tar.gz
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
	##git
	#git clone https://github.com/helm/helm.git
	#cd helm
	#make
#seach for complete charts on Artifact Hub
helm search hub "<package-name>"
	helm search hub nginx
#list added repos (also by type parts of words or phrases)
helm search repo
#install package
	#verify avaliable nodes
	kubectl get nodes
helm install "<release-name>" "<repo/package-name>"
	#remove
	helm uninstall "<release-name>" "<repo/package-name>"
https://artifacthub.io/packages/helm/cetic/zabbix
#install prometheus operator via helm3
helm repo add stable "https://charts.helm.sh/stable"
helm install my-prometheus-operator stable/prometheus-operator