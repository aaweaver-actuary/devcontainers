FROM alpine:latest as builder
ENV GO_VERSION 1.22.1
ENV SLIM_VERSION 1.40.11
ENV HOME /home/user
WORKDIR /home/user
COPY ./hello.go /home/user/hello.go
RUN apk update && \
  apk add --no-cache git && \
  git clone https://github.com/aaweaver-actuary/dotfiles.git /home/user/dotfiles && \
  cd /home/user/dotfiles && \
  mv ./home/.bashrc /home/user/.bashrc && \
  mv ./home/.hushlogin /home/user/.hushlogin && \
  apk add --no-cache curl && \
  apk add --no-cache build-base && \
  apk add --no-cache gcc && \
  apk add --no-cache g++ && \
  apk add --no-cache make && \
  apk add --no-cache musl-dev && \
  apk add --no-cache linux-headers && \
  apk add --no-cache libffi-dev && \
  apk add --no-cache bash && \
  curl -L https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -o /home/user/go${GO_VERSION}.linux-amd64.tar.gz && \
  tar -C /usr/local -xzf /home/user/go${GO_VERSION}.linux-amd64.tar.gz && \
  rm /home/user/go${GO_VERSION}.linux-amd64.tar.gz && \
  ln -s /usr/local/go/bin/go /usr/bin/go && \
  ln -s /usr/local/go/bin/gofmt /usr/bin/gofmt && \
  rm -rf /var/cache/apk/*

RUN curl -k -L -o ds.tar.gz https://github.com/slimtoolkit/slim/releases/download/${SLIM_VERSION}/dist_linux.tar.gz && \
  tar -xzf ds.tar.gz && \
  rm ds.tar.gz && \
  mv  dist_linux/slim /usr/local/bin/ && \
  mv  dist_linux/slim-sensor /usr/local/bin/

# FROM builder as runner
# COPY --from=builder /home/user /home/user
# RUN go run /home/user/hello.go && \
#   go build -o /home/user/hello /home/user/hello.go && \
#   chmod +x /home/user/hello
CMD ["/bin/bash"]
