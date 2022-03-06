#kubernetes_ETCD.sh
#some intro
'
Etcd is a CNCF graduated open source project and is a distributed
, reliable and highly available key-value store.
Written in Go, etcd gets its name from the UNIX directory structure
naming convention. In UNIX, all the system configuration files are
stored in a directory called “etc”. A “d” is augmented to “etc”
 to represent etcd’s distributed model. 
Etcd is an integral part of the Kubernetes control plane.

Etcd stores Kubernetes cluster configuration and state data such 
as the number of pods, their state, namespace, etc.
It also stores Kubernetes API objects and service discovery details.
'
#
#Determine ETCD pod
kubectl get pods -n kube-system |grep etcd
#Show ETCD config
kubectl describe pod etcd-cube-master.mydomain -n kube-system \
	| awk '/Command:/,/State:/'
	#eg:
      etcd
      --advertise-client-urls=https://90.0.1.30:2379
      --cert-file=/etc/kubernetes/pki/etcd/server.crt
      --client-cert-auth=true
      --data-dir=/var/lib/etcd
      --initial-advertise-peer-urls=https://90.0.1.30:2380
      --initial-cluster=cube-master.mydomain=https://90.0.1.30:2380
      --key-file=/etc/kubernetes/pki/etcd/server.key
      --listen-client-urls=https://127.0.0.1:2379,https://90.0.1.30:2379
      --listen-metrics-urls=http://127.0.0.1:2381
      --listen-peer-urls=https://90.0.1.30:2380
      --name=cube-master.mydomain
      --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
      --peer-client-cert-auth=true
      --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
      --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
      --snapshot-count=10000
      --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
      #
#output etcd registry
kubectl exec etcd-cube-master.mydomain -n kube-system \
	-- sh -c \
	"ETCDCTL_API=3 etcdctl \
	--endpoints https://90.0.1.30:2379 \
	--cacert /etc/kubernetes/pki/etcd/ca.crt \
	--key /etc/kubernetes/pki/etcd/server.key \
	--cert /etc/kubernetes/pki/etcd/server.crt \
	get / --prefix --keys-only"
#add value to registry
kubectl exec etcd-cube-master.mydomain -n kube-system \
	-- sh -c \
	"ETCDCTL_API=3 etcdctl \
	--endpoints https://90.0.1.30:2379 \
	--cacert /etc/kubernetes/pki/etcd/ca.crt \
	--key /etc/kubernetes/pki/etcd/server.key \
	--cert /etc/kubernetes/pki/etcd/server.crt \
	put name testvalue"
#output value from registry by name
kubectl exec etcd-cube-master.mydomain -n kube-system \
	-- sh -c \
	"ETCDCTL_API=3 etcdctl \
	--endpoints https://90.0.1.30:2379 \
	--cacert /etc/kubernetes/pki/etcd/ca.crt \
	--key /etc/kubernetes/pki/etcd/server.key \
	--cert /etc/kubernetes/pki/etcd/server.crt \
	get name testvalue"
#
