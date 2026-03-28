# K3S@home

## Introduction

The purpose of this project is to store all the experiments I make on my homelab. The initial configuration of my homelab was a kubernetes (k3s) cluster of Raspberry PIs. At this time the availabiliy of images for the linux/ARM64 platform (understand Raspberry PI running a Linux 64 bit OS) was limited and I very quickly had to learn how to produce such images for this platform from a Linux/AMD64 platform (my PC). In 2023, the technology for generating multiplatform images was emergent and evolving and putting it into action for my own purpose was the focus of this project. Now the technology is mature and well documented and my focus has moved to other topics. 

This repo contains artifacts generated or used while investigating the topics described in the next section.

## Infrastructure

These are the services I host in my environment which are used by this kubernetes homelab.

**vault**. I use vault to generate TLS certificates. Although I have my own domain, I am not using Let's encrypt certificates for my homelab.

**Harbor**. I am using Harbor as my self hosted image registry. I use a docker-compose file to deply harbor. The storage backend used by Harbor is an S3 compatible solution (minio) also running on my NAS.

**minio**.  Also running on my NAS. This is an S3 compatible cloud storage solution. I don't use it for any other purpose as storage backend for Harbor

**zot**.  Zot is an OCI registry. I plan to use zot as my default registry in the future because Harbor is keeping my NAS busy all the times. I don't really need the bells and wistles coming with Harbor (although I like them a lot). Replacing Harbor by zot may extend the life of my hard drives.



## Topics

- **ansible**. I deploy and update Kubernetes on my Raspberry PIs using ansible. The main playbooks are `k3signite.yaml` which I use to deploy a master node and `scale.yaml` which I use to deploy additional worker nodes. These playbooks are also used to update the OS and the version of K3s on the master and worker nodes. The initial playbooks (those used to prepare the OS before installing k3s) are adapted from Jeff Geerling's work. 
  
  

- **POE switch**. Overtime I changed my older 5-ports switch connecting the 4 PIs by an 8-port POE switch. I Updated the `shutdown.yaml` playbook to disable the power on the relevant ports when shuting down my PIs. I also created a `poweron.yaml` playbook to ... power on the PIs. The utility I use to operate the POE switch can be found here: https://github.com/nitram509/ntgrrc
  
  

- **Multiplatform builds** Probably the first thing to learn when willing to run applications on a Kubernetes cluster is how to generate a container image.  When the target platform is Linux/ARM64 and your development machine is Linux/AMD64 you have to learn how to generate multiplatform container images. The `applis/curl` and `applis/utilities` folder are two artifacts created during my experiments with this technology ([docker buildx | Docker Docs](https://docs.docker.com/reference/cli/docker/buildx/)). The experience with buildx in these two folders is limited to QEMU based multiplatform builds.  I experimented cross compilation later while troubleshooting the deployment of  the Google microservice demo. The `applis/hello-app` folder contains two Dockerfile files. One which generates the hello-app container image using QEMU, another one which generates the hello-app container image using the GO language cross compilation capabilities.
  
  

- **Ingress and Traefik**  I had to struggle a little bit with Traefik which is the solution that the k3s distro deploys by default. Ingresses are used to access you appplications  from outside the kubernetes cluster. I am not a big fan of Traefik especially because I don't like the way the documentation is written. (Traefik can be deployed on various platforms, Kubernetes or not and they try to make the documentation generic which I find confusing). At this point I prefer to use regular ingress resources (Kind: Ingress) rather than Traefik resources (ingressRoutes etc).
  
  

- **helm**.  Helm is used to deploy a few applications such as drupal, wordpress, mosquitto etc (I don't use most of these apps but I can easily experiment with them thanks Kubernetes and Helm). I like helm and don't plan to experiment with Red Hat's favorite`operators`.  I plan to investigate ArgoCD in the future. 
  
  

- **Kubernetes Dashboard**: I started with the now obsolete Kubernetes Dashboard [Kubernetes Dashboard](https://github.com/kubernetes-retired/dashboard) and I am now using Headlamp [Headlamp](https://github.com/kubernetes-sigs/headlamp). ("using"" is a big word, let's say I am looking at what they are doing)
  
  

- **Google Microservice Demo**.  The Google microservice demo can be found [here](https://github.com/GoogleCloudPlatform/microservices-demo). Generating all the required images for my Linux/ARM64 based cluster is  [another project of mine](https://github.com/chris4474/microservices-demo). Simply running `skaffold build` did not work for me hence the fork. This other project of mine generates a microservice.yaml file (using `skaffold render`) which can be found under the `applis/microservice` folder. The demo is deployed on my target clusters using `kustomize`. ([Declarative Management of Kubernetes Objects Using Kustomize | Kubernetes](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/))
  
  

- **Kustomize**.  I have 3 Kubernetes clusters in my environment. A first cluster consisting of 4 Raspberry PI 4Bs, a second cluster of 3 Alpine VMs running on my PC and a third cluster of one Raspberry PI 5.  Some of the yaml files such as those specifying hostnames (eg TLS specifications in an Ingress definition) have to reflect the target cluster. For example I can deploy wordpress on cluster 1 and cluster 2 but will need to use different hostnames to differentiate the two instances (eg wordpress.cluster1.example.com and wordpress.cluster2.example.com). In the beginning I had to "templatize" the yaml files and processes them using bash variable substitution to produce the kubernetes manifests which I could then deploy on the target cluster. I now use Kustomize to do the same. Replacing my older `deploy.sh` scripts using the Kustomize approach is a work in progress



## Planned topics

- **ArgoCD**.  Actually I have been investigating Kustomize because this is one of the the techno I plan to use with ArgoCD, in addition to Helm.

- **Istio**. 

TBCon'd
