cat <<EOF 
#
# The doc as of Apr 2023 is working on Ubuntu 20.04 (focal) 
#
#
Client: Docker Engine - Community
Version:           23.0.2
API version:       1.42
Go version:        go1.19.7
Git commit:        569dd73
Built:             Mon Mar 27 16:16:18 2023
OS/Arch:           linux/amd64
Context:           default

erver: Docker Engine - Community
Engine:
 Version:          23.0.2
 API version:      1.42 (minimum version 1.12)
 Go version:       go1.19.7
 Git commit:       219f21b
 Built:            Mon Mar 27 16:16:18 2023
 OS/Arch:          linux/amd64
 Experimental:     false
containerd:
 Version:          1.6.20
 GitCommit:        2806fc1057397dbaeefbea0e4e17bddfbd388f38
runc:
 Version:          1.1.5
 GitCommit:        v1.1.5-0-gf19387a
docker-init:
 Version:          0.19.0
 GitCommit:        de40ad0

#
# here is the doc: https://docs.docker.com/build/building/multi-platform/
#

#
# For the builder to recognize a self-signed certificate create the file buildkitd.toml
#

[registry."your.dockerimagehost.example"]
  ca=["/home/downloads/mycacert.pem"]

#
# Create the builder with the following command
#
docker buildx create --name mybuilder --driver docker-container --bootstrap --config buildkitd.toml
docker buildx use mybuilder

#
# to avoid generations of unkown/unknown manifests
#
export BUILDX_NO_DEFAULT_ATTESTATIONS=1

#
# Create a sample Dockerfile
#
FROM alpine:3.17.2
RUN apk add curl

#
#
# Build the cross-platform image
#
#
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 -t registry.symphorines.home/chris7444/curl:1.0 --push .
#docker buildx build --platform linux/arm,linux/arm64,linux/amd64 -t chris7444/hello-app . --push 
docker buildx imagetools inspect registry.symphorines.home/chris7444/curl:1.0

EOF

