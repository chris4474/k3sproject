kubectl apply -f namespace.yaml

kubectl create secret generic --namespace k8s-dashboard default-tls-cert \
    --from-file=private.key=$HOME/certs/apps/apps.key \
    --from-file=tls.key=$HOME/certs/apps/apps.key \
    --from-file=tls.crt=<(cat $HOME/certs/apps/apps.crt $HOME/certs/apps/intCA.crt)

helm upgrade --install k8s-dashboard kubernetes-dashboard/kubernetes-dashboard \
   --namespace k8s-dashboard \
   -f values.yaml

kubectl apply -f user.yaml
kubectl apply -f cr-binding.yaml
kubectl apply -f servertransport.yaml
kubectl -n k8s-dashboard create token admin-user

