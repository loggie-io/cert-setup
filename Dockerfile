# Build
FROM --platform=$BUILDPLATFORM golang:1.18 as builder

ARG TARGETARCH
ARG TARGETOS

RUN go install github.com/cloudflare/cfssl/cmd/...@latest

WORKDIR /go/bin
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/$TARGETOS/$TARGETARCH/kubectl

# Run
FROM --platform=$BUILDPLATFORM debian:buster-slim
COPY --from=builder /go/bin /usr/local/bin
RUN chmod -R +x /usr/local/bin
