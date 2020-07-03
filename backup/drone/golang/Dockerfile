FROM golang:1.13  AS builder
ENV GO111MODULE=on
ENV CGO_ENABLED 0
ENV GOOS=linux
ENV GOPROXY="https://goproxy.cn"

WORKDIR /go/release

ADD . .

RUN GOOS=linux CGO_ENABLED=0 go build -tags=jsoniter -ldflags="-s -w" -installsuffix cgo -o app k8sapi.go

# -----------------------------------------------------------------------

FROM docker.io/alpine

COPY --from=builder /go/release/app /