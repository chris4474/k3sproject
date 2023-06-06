# K3S@home

## Building container images for ARM

### Problem Statement

I use a k3s cluster made of Raspberry PIs to learn Kubernetes.  Some of the tutorials which can be found on the Internet were made to run on GKE and use container images which are not available for the ARM architecture. 

However, because everything is open source, the sources for these container images can be found on github (most of the time) and using these sources. one can rebuild the images. As a first approximation, one would connect to a docker daemon running on an ARM machine and then run the `docker build` command to build an image that matches the architecture of the Docker node. In other words, if you run the `docker build` command on an AMD64 machine, you will build an image for the AMD64 architecture.

In order to build a Docker image for the ARM architecture, I could have installed Docker on one of my PIs and build from here. However,  PIs are slow (even if they are now more powerful than they were in the past), and the storage available on a PI is generally backed by an SD card which was not designed for this type of workload (heavy/frequent writes). In addition, my PIs are running k3s and they are using `cri-io` as the container engine and not the Docker daemon.

What I wanted is something that has been long available in the software engineering industry, something like a cross compiler. What a cross compiler is doing is that it will let you compile a program source (for example a C program) for the target architecture of your choice. 

And something like this exists and this is Docker buildx.

### Building cross platform container images using Docker buildx

The article https://community.arm.com/developer/tools-software/tools/b/tools-software-ides-blog/posts/getting-started-with-docker-for-arm-on-linux will provide you with the instructions you need to install/enable docker buildx on an AMD64 machine running Linux. I used these instructions to enable buildx on a Virtual Machine running Ubuntu 18.04.

However, after following the instructions given in the article above, I found out that the `docker buildx build` command was not longer working. This is because two containers are required which are not restarted automatically after a reboot

So I came up with these instructions. You only need to run them once after you have installed docker and enabled the buildx extension as explained in the paper above.

```
docker run --restart=unless-stopped --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64
sudo cat /proc/sys/fs/binfmt_misc/qemu-aarch64
docker buildx create --name mybuilder --buildkitd-flags restart=unless-stopped
docker buildx use mybuilder
docker buildx inspect --bootstrap
```

If you reboot, the two containers which are required to build multi architecture container images will be automatically restarted and this is due to the `restart=unless-stopped` flag passed to the `docker run` and the `docker  buildx create` commands.

### Build your container image 

Now provided that you have everything working, you will be able to build the hello-app container image using the following commands:

```
echo cd ./hello-app
docker login
docker buildx build --platform linux/arm,linux/arm64,linux/amd64 -t <yourusername>/hello-app:<tag> . --push
```

You first need to login with the Docker hub registry with `docker login`.  The `docker buildx build` command ends with the switch `--push` which means you want to upload the resulting image to Docker hub.  If you don't specify `--push`, the images will be generated and stay in a cache.  You can also use `--load` instead of `--push` if you want the resulting Docker image to be loaded into your local Docker environment (you may want to test your new image first before uploading it to Docker Hub).

In the example above, we have requested to generate the container image for three different platforms, `linux/arm, linux/arm64 and linux/amd64`. However you could have specified additional platforms. The `docker buildx inspect` command list all possible target platforms that the current(?) builder supports:

```
chris@ubuntu-101:~/k3sproject$ docker buildx inspect
Name:   mybuilder
Driver: docker-container

Nodes:
Name:      mybuilder0
Endpoint:  unix:///var/run/docker.sock
Status:    running
Flags:     restart=unless-stopped
Platforms: linux/amd64, linux/arm64, linux/riscv64, linux/ppc64le, linux/s390x, linux/386, linux/arm/v7, linux/arm/v6
chris@ubuntu-101:~/k3sproject$
```

You can also verify that your repository contains an image for the three types of platforms/architectures you requested during the build with the `--platform` switch .

```
chris@ubuntu-101:~/k3sproject$ docker buildx imagetools inspect chris7444/hello-app:v3.0
Name:      docker.io/chris7444/hello-app:v3.0
MediaType: application/vnd.docker.distribution.manifest.list.v2+json
Digest:    sha256:80c35459041ff458742a16d63d5db3b26c21c22e2c6330428586a84bc1307c9a

Manifests:
  Name:      docker.io/chris7444/hello-app:v3.0@sha256:a60130e169876a95ea3e80e3a3f217ad32e4d37fb19648efd6043caa777b67bf
  MediaType: application/vnd.docker.distribution.manifest.v2+json
  Platform:  linux/arm/v7

  Name:      docker.io/chris7444/hello-app:v3.0@sha256:0999e6676363cee6c13568d9532d5c968b4efcb885ad5991ab97244bf15ddd6f
  MediaType: application/vnd.docker.distribution.manifest.v2+json
  Platform:  linux/arm64

  Name:      docker.io/chris7444/hello-app:v3.0@sha256:f0ea1df8db1ebb322f23d70f4fe8ef9f1dd9d1eacd65d942b4b80d2e565eaeb9
  MediaType: application/vnd.docker.distribution.manifest.v2+json
  Platform:  linux/amd64

```



### Closer look at the Dockerfile

1- the Docker file is "compiled" using all the platforms specified in the `docker buildx build` command line

2- the first FROM statement means we need to compile and generate the hello-app application in the context of the builder.

3- our hello-app image is made of an Alpine image in which we insert the generated hello-app executable

```
FROM golang:alpine3.12 AS builder
ADD . /go/src/hello-app
RUN go install hello-app

FROM alpine:latest
COPY --from=builder /go/bin/hello-app .
ENV PORT 8080
CMD ["./hello-app"]
```

note: There need to be an image for the platforms specified in the `docker buildx build` command line for both `golang:alpine3.12` and `alpine:latest` for the build to succeed. 

if this is not the case, the build will fail. For example if you specifiy `linux/riscv64` as a target platform, the build will fail because the `golang:alpine3.12` repo does not contain an image for this architecture

![image-20200616172201436](screenshots/golang_alpine3.12)



