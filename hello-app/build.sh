#docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6 -t registry.symphorines.home/chris7444/hello-app:short-v7 --push .
docker buildx build --platform linux/amd64,linux/arm64 -t registry.symphorines.home/chris7444/hello-app:short-v9.1 --push .
