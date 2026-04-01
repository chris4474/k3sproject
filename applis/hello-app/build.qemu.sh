registry=${DEFAULT_REGISTRY:-registry.symphorines.home}
docker buildx build --platform linux/amd64,linux/arm64 -f Dockerfile.qemu -t ${registry}/chris/hello-app:short-v9.2 --push .
