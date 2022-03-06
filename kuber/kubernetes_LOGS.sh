#kubernetes_logs.sh
kubectl logs -f \
	-l app=test-deployment \
	--prefix=true
#