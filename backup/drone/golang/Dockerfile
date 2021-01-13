FROM registry-vpc.cn-hangzhou.aliyuncs.com/epet/golang:1.13-alpine3 AS builder
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
ENV GO111MODULE=on
ENV CGO_ENABLED 0
ENV GOOS=linux
ENV GOPROXY="http://172.16.5.157:8080,https://goproxy.cn,direct"
ENV GOPRIVATE="gitlab.haijipet.com"

WORKDIR /go/cache

ADD go.mod .
ADD go.sum .
RUN git config --global --add url."git@gitlab.haijipet.com:".insteadOf "http://gitlab.haijipet.com/" && go mod download

WORKDIR /go/release

ADD . .

RUN GOOS=linux CGO_ENABLED=0 go build -ldflags="-s -w" -installsuffix cgo -o app main.go

FROM registry-vpc.cn-hangzhou.aliyuncs.com/epet/alpine:latest

COPY --from=builder /go/release/app /

CMD ["/app", "release"]
