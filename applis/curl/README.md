# Purpose

Illustrate how to build a multiplatform container image.

# Build script

The script build.sh builds an Alpine container image with the curl utility. Targetted platforms are linux/amd64 et linux/arm64. The images are pushed to a registry

# Prerequisites:

Create a builder with the following commands and make it the default builder

`docker buildx create --name mybuilder --driver docker-container --bootstrap --config buildkitd.toml`

`docker buildx use mybuilder`

The buildkits.toml configuration file injects the certificate of the root CA used by my private registries

`[registry."registry.symphorines.home"]
  ca=["/home/chris/certs/ca.crt"]
[registry."zot.symphorines.home"]
  ca=["/home/chris/certs/ca.crt"]`


