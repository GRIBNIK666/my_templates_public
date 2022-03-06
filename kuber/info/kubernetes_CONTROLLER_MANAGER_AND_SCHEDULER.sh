#kubernetes_CONTROLLER_MANAGER_AND_SCHEDULER.info
#docs: https://kubernetes.io/docs/reference/command-line-tools-reference/kube-controller-manager/
#docs2: https://kubernetes.io/docs/reference/command-line-tools-reference/kube-scheduler/
'
On event of creating Pod, kube Scheduler determines which Worker-Node would be 
suitable for deployment of new Pod.
Scheduler stages:
	1 - Filtering (find suitable node based on Pods resource requirements)
	2 - Scoring (choose best-performing Node based on the advantage of available resources after Pod-object creation)
'
#Configuring Kube Controller Manager and Kube-Scheduler
kubectl get pods -n kube-system | grep controller-manager
#Get kube controller manager config
kubectl describe pod \
	kube-controller-manager-cube-master.mydomain -n kube-system \
	| awk '/kube-controller-manager:/,/--use-service-account/'
#if returns '--controllers=*,bootstrapsigner,tokencleaner'
'--controllers=*' stands for running ALL present controllers
#edit controller-manager configuration
kubectl edit pod kube-controller-manager-cube-master.mydomain -n kube-system
#edit kube-scheduler configuration
kubectl get pods -n kube-system | grep scheduler
kubectl describe pod \
	kube-scheduler-cube-master.mydomain -n kube-system \
	| awk '/kube-scheduler:/,/State:          Running/'
kubectl edit pod kube-scheduler-cube-master.mydomain -n kube-system
#