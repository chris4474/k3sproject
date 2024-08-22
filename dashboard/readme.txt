# instruction to deploy the dashboard can be found here: https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

# instruction to create a user which will be able to access the dashboard are here: https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/

# to create a token that can be used to access the dashboatrd

kubectl -n kubernetes-dashboard create token admin-user


update: 20-aug-2024
   create an ingressRouteTCP (Traefik)
   I can access the dashboard from outside but the connection is not secure (kong default certificate)
   need to look further into kong (or Traefik)

Create a token for login in
   kubectl -n kubernetes-dashboard create token admin-user

Update: 22-Aug-2024
   a servertransport object is used to establish an insecure https connection between Traefik and the kong proxy (proxy to the dashboard itself)
   the kubernetes-dashboard chart is configured to :
   - annotate the kong proxy service to accept unsecure connections. This is coming from https://github.com/kubernetes/dashboard/issues/9051
   - configure an ingress (traefik class). two routes are accepted: one for the alp cluster, a second for the rpi cluster although only one is needed

run the install.sh script to deploy the dashboard in the namespace k8s-dashboard

