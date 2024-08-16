# Enable TLS with Traefik

1/ Create a namespace named whoami and deploy the whoami app within it
     kubectl create -f workload.yaml

2/ run the  load-tls.sh script
  This create a k8s secret containing
     1/ the certificate chain (from server to last intermediate CA)
     2/ the server key 
     note: certificates and server key are not stored in github, read the scrip to understand where they are expected to be found

3/ create an IngressRoute, example manifests are under the rpi and alp folders (two of my k3s environments)
    kubectl create -f alp/ingress-route-tls.yaml


4/ test
   curl https://whoami.alp.symphorines.home

