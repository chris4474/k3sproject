## Using the QEMU based Builder

The Dockerfile is the same for all architectures but a QEMU VM with the target architecture is launched for every architecture requested by the docker buildx build command line which does not match the architecture of the host. The host is the machine processing the docker buildx build command: 



`FROM golang:alpine3.20 AS builder
ADD . /go/src/hello-app
RUN GO111MODULE=auto go install hello-app`

`FROM alpine:3.22
COPY --from=builder /go/bin/hello-app .
ENV PORT=8080
CMD ["./hello-app"]`

The Dockerfile is the same for all architectures but the use of QEMU comes with a cost.

time to build: 3m27s

real    3m27.736s
user    0m0.642s
sys     0m0.527s

## Using the GO Cross Compiler

Typically a cross compiler is needed (here the GO compiler). In the example below, the GO compiler on the host is used to produce executables for a target platform which is not the one used by the host.

```
FROM  --platform=$BUILDPLATFORM golang:alpine3.20 AS builder
WORKDIR /src

# Copy dependency files first for better caching
COPY go.mod  ./
RUN go mod download

# copy app source files
COPY . .

# Set environment variables for the target architecture
ARG TARGETOS
ARG TARGETARCH
ADD . /src/hello-app
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} CGO_ENABLED=0 go build -ldflags="-s -w" -o /src/hello-app .

FROM alpine:3.22
WORKDIR /src
COPY --from=builder /src/hello-app .
ENV PORT=8080
CMD ["/src/hello-app"]
```

The builder is running on the host as specifued by `--platform=$BUILDPLATFORM` but the compiler compiles for the targetted Operating system and architecture ( `${TARGETOS}` and `${TARGETARCH}`)

The overall operation is mushc faster as shown below:

real    0m34.518s
user    0m0.184s
sys     0m0.117s

