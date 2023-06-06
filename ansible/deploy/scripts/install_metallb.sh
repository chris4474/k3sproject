kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
# Create secret on first install only
if kubectl get secret -n metallb-system memberlist >/dev/null 2>&1
then
  echo secret memberlist already created
else
  echo Creating secret memberlist 
  kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
fi
kubectl apply -f metallb.configmap.yaml
