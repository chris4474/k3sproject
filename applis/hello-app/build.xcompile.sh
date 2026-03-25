registry=${DEFAULT_REGISTRY:-registry.symphorines.home}
docker buildx build -f Dockerfile.xcompile --platform linux/amd64,linux/arm64 -t ${registry}/chris7444/hello-app:short-v9.2 --push .
