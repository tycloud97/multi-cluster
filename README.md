# Multi-cluster, multi-region, multi-cloud Kubernetes

This project helps you bootstrap and orchestrate several Kubernetes clusters across different regions and clouds from a single control plane.

![Scaling Kubernetes clusters across regions and clouds](assets/preview.gif)

The setup helps study:

- High availability installation of Kubernetes.
- Multi-region deployments.
- Multi-cloud deployments.
- Upgrading clusters and apps.

## Getting started

You need to create a Linode token to access the API:

```bash
linode-cli profile token-create
export LINODE_TOKEN=<insert the token here>
```

```bash
# Create the clusters
terraform -chdir=01-clusters init
terraform -chdir=01-clusters apply -auto-approve

# Install Karmada in the cluster manager
terraform -chdir=02-karmada init
terraform -chdir=02-karmada apply -auto-approve

# Configure the Karmada workers and install Istio
terraform -chdir=03-workers init
terraform -chdir=03-workers apply -auto-approve

# Discover other Istio installations
terraform -chdir=04-discovery init
terraform -chdir=04-discovery apply -auto-approve

# Install Kiali
terraform -chdir=05-dashboards init
terraform -chdir=05-dashboards apply -auto-approve

# Clean up
terraform -chdir=05-dashboards destroy -auto-approve
terraform -chdir=04-discovery destroy -auto-approve
terraform -chdir=03-workers destroy -auto-approve
terraform -chdir=02-karmada destroy -auto-approve
terraform -chdir=01-clusters destroy -auto-approve
```

## Accessing the Kiali dashboard

```bash
kubectl --kubeconfig=kubeconfig-ap port-forward svc/kiali 8081:20001 -n istio-system
```

## Testing the code

```bash
./test.sh
```

The script will print the command you can use to launch the world map dashboard.

## Creating new certs

```bash
$ git clone https://github.com/istio/istio
```

Create a `certs` folder and change to that directory:

```bash
$ mkdir certs
$ cd certs
```

Create the root certificate with:

```bash
$ make -f ../istio/tools/certs/Makefile.selfsigned.mk root-ca
```

The command generated the following files:

- `root-cert.pem`: the generated root certificate.
- `root-key.pem`: the generated root key.
- `root-ca.conf`: the configuration for OpenSSL to generate the root certificate.
- `root-cert.csr`: the generated CSR for the root certificate.

For each cluster, generate an intermediate certificate and key for the Istio Certificate Authority:

```bash
$ make -f ../istio/tools/certs/Makefile.selfsigned.mk cluster1-cacerts
$ make -f ../istio/tools/certs/Makefile.selfsigned.mk cluster2-cacerts
$ make -f ../istio/tools/certs/Makefile.selfsigned.mk cluster3-cacerts
```

## Notes

- Sometimes, the EastWest gateway cannot be created because of a validation admission webhook. Since this is sporadic, I think it's related to a race condition. [More on this here.](https://github.com/istio/istio/issues/39205)
- This Terraform files use the `null_resource` and `kubectl`. You should have `kubectl` installed locally.

terraform -chdir=02-karmada init && terraform -chdir=02-karmada apply --auto-approve

terraform -chdir=01-clusters init && terraform -chdir=01-clusters apply --auto-approve

terraform -chdir=03-workers init && terraform -chdir=03-workers apply --auto-approve

aws eks update-kubeconfig --name ap-cluster --kubeconfig ~/.kube/worker_config

karmadactl --kubeconfig /etc/karmada/karmada-apiserver.config  join ${MEMBER_CLUSTER_NAME} --cluster-kubeconfig=$HOME/.kube/config

~/.kube/config
MEMBER_CLUSTER_NAME=`cat ~/.kube/config  | grep current-context | sed 's/: /\n/g'| sed '1d'`

karmadactl --kubeconfig /Users/ty/.kube/config join arn:aws:eks:ap-southeast-1:827539266883:cluster/ap-cluster --cluster-kubeconfig=$HOME/.kube/config

kubectl karmada join ap-cluster --kubeconfig=$HOME/.kube/config --cluster-kubeconfig=$HOME/.kube/config

kubectl config rename-context arn:aws:eks:ap-southeast-1:827539266883:cluster/cluster-manager-cluster cluster-manager-cluster

kubectl config get-contexts 

kubectl config rename-context arn:aws:eks:ap-southeast-1:827539266883:cluster/ap-cluster ap-cluster

kubectl config use-context ap-cluster

kubectl config use-context cluster-manager-cluster


aws eks update-kubeconfig --name cluster-manager-cluster
aws eks update-kubeconfig --name ap-cluster


kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}'
kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}'

helm install karmada -n karmada-system --create-namespace --dependency-update ./charts/karmada

https://github.com/karmada-io/karmada/tree/master/charts/karmada

helm --namespace karmada-system upgrade -i karmada karmada-charts/karmada --create-namespace


<!-- kubectl delete all --all --all-namespaces -->

Notes:

Issue 
Reinstall AWS CLI to latest

helm upgrade eastwest-gateway istio/gateway \
 --namespace istio-system \
 --version=1.14.1 \
 --set labels.istio=eastwestgateway \
 --set labels.app=istio-eastwestgateway \
 --set labels.topology.istio.io/network=network1 \
 --set networkGateway=network1 \
 --set service.ports[0].name=status-port \
 --set service.ports[0].port=15021 \
 --set service.ports[0].targetPort=15021 \
 --set service.ports[1].name=tls \
 --set service.ports[1].port=15443 \
 --set service.ports[1].targetPort=15443 \
 --set service.ports[2].name=tls-istiod \
 --set service.ports[2].port=15012 \
 --set service.ports[2].targetPort=15012 \
 --set service.ports[3].name=tls-webhook \
 --set service.ports[3].port=15017 \
 --set service.ports[3].targetPort=15017 \


for i in {1..10}
do
 kubectl exec --kubeconfig=kubeconfig-ap -c sleep \
   "$(kubectl get pod --kubeconfig=kubeconfig-ap -l \
   app=sleep -o jsonpath='{.items[0].metadata.name}')" \
   -- curl -sS hello:5000 | grep REGION
done

https://medium.com/@danielepolencic/scaling-kubernetes-to-multiple-clusters-and-regionss-491813c3c8cd
https://www.youtube.com/watch?v=Ay3KiBWFuX0&t=48s
https://www.qovery.com/blog/kubernetes-multi-cluster-why-and-when-to-use-them
https://learnk8s.io/bite-sized/connecting-multiple-kubernetes-clusters
https://loft.sh/blog/multi-cluster-kubernetes-part-one-defining-goals-and-responsibilities/