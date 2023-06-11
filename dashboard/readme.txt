# instruction to deploy the dash-board can be found here: https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
# instruction to create a user which will be able to access the dashboard are here: https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
# to create a token that can be used to access the dashboatrd
kubectl -n kubernetes-dashboard create token admin-user

on peut accéder le dashboard de l'extérieur (en plus de la méthode kubectl proxy + tunnell ssh) en déclarant le service kubernetes-dashboard de type
NodePort (au lieux de ClusterIP)
