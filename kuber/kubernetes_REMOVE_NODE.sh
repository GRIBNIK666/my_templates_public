#kubernetes_remove_node.sh
kubectl get nodes

kubectl drain '<node-name>'
	kubectl drain '<node-name>' --ignore-daemonsets --delete-emptydir-data

	#edit instance group
	kops edit ig nodes

kubectl delete node '<node-name>'
	kops update cluster --yes

#on worker node	
kubeadm reset
