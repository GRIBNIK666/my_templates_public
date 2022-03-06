#kubernetes_101_ep4_drupal_deployment.sh
kubectl create namespace drupal

kubectl apply -f mariadb.yml

kubectl apply -f drupal.yml 

kubectl get service -n drupal

kubectl get deployments -n drupal
#Example PersistentVolume
apiVersion: v1
kind: PersistentVolume
metadata:
  name: drupal-files-pvc
  namespace: drupal
  labels:
    type: local
spec:
  accessModes:
    - ReadWriteOnce
  capacity:
    storage: 1536Mi
  hostPath:
    path: "/opt/drupal"
#
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mariadb-pvc
  namespace: drupal
  labels:
    type: local
spec:
  accessModes:
    - ReadWriteOnce
  capacity:
    storage: 1536Mi
  hostPath:
    path: "/opt/mariadb"
#
#change current default namespace
kubectl config set-context --current --namespace="<namespace>"
  kubectl config set-context --current --namespace="" #set to default
#remove all entities attached to namespace
kubectl delete namespace drupal
#