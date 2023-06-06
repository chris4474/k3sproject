FROM golang:alpine3.18 AS builder
ADD . /go/src/hello-app
RUN GO111MODULE=auto go install hello-app

FROM alpine:3.18
COPY --from=builder /go/bin/hello-app .
ENV PORT 8080
CMD ["./hello-app"]
