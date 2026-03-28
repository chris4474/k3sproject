registry=${DEFAULT_REGISTRY:-registry.symphorines.home}
docker  buildx build --platform linux/amd64,linux/arm64 -t ${registry}/chris7444/utilities:v4.0 --push .
