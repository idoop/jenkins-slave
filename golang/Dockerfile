FROM wiqun/jenkins-slave-base:latest

MAINTAINER Swire Chen<idoop@msn.cn>

USER root

ENV GOLANG_VERSION=1.11.4 \
    GOLANG_RELEASE_SHA256=fb26c30e6a04ad937bbc657a1b5bba92f80096af1e8ee6da6430c045a8db3a5b \
    GOPATH=/home/jenkins/go \
    GOBIN=/home/jenkins/go/bin

RUN curl -SL --output go1.11.4.linux-amd64.tar.gz https://dl.google.com/go/go$GOLANG_VERSION.linux-amd64.tar.gz \
    && echo "${GOLANG_RELEASE_SHA256} go$GOLANG_VERSION.linux-amd64.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf go$GOLANG_VERSION.linux-amd64.tar.gz \
    && rm go$GOLANG_VERSION.linux-amd64.tar.gz \
    && mkdir -p /home/jenkins/go \
    && echo "PATH=\$PATH:/usr/local/go/bin" >> /etc/profile \
    && echo "PATH=\$PATH:/home/jenkins/go/bin" >> /etc/profile 

USER jenkins