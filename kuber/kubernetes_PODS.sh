#kubernetes_PODS.sh
##Pods are often deployed inside Deployment or Replica Sets, this example doesn't reflect production use case
##Pod lifecycle (status)
'
1 - Pending
2 - Running
3 - Succeded
'
#create pod using cli
kubectl run testpod --image=nginx:stable -n default
	kubectl get pods -n default
kubectl delete pod testpod -n default
#create pod using YAML
kubectl run testpod --image=nginx:stable -n default \
	--dry-run=client \
	-o yaml > nginx.yaml
cat nginx.yaml
#nginx.yaml neccessary values
apiVersion: v1
kind: Pod
metadata:
  name: testpod
spec:
  containers:
  - image: nginx:stable
    name: testpod
#EOF
kubectl apply -f nginx2.yaml
#
#Static Pods used on specific worker node
ssh '<user>'@'<worker-nodeIP>'
#find kubelet process
ps -ef | grep kubelet 
	#e - print all local process names
	#f - print detailed info
#get config.yaml from previous command output
cat /var/lib/kubelet/config.yaml | grep staticPodPath
cd /etc/kubernetes/manifests
ls -lrt
	#-1 list one file per line.  Avoid '\n' with -q or -b
  	#-r, --reverse reverse order while sorting
  	#-t sort by modification time, newest first
#create pod (won't restart after command completes)
kubectl run sleepod \
	--image=busybox \
	--restart=Never \
	--command -- sleep 30
#
