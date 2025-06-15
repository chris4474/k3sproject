FROM golang:alpine3.20 AS builder
ADD . /go/src/hello-app
RUN GO111MODULE=auto go install hello-app

FROM alpine:3.22
COPY --from=builder /go/bin/hello-app .
ENV PORT 8080
CMD ["./hello-app"]
