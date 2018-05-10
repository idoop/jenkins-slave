FROM jenkins/jnlp-slave:latest
MAINTAINER Swire Chen<idoop@msn.cn>
USER root
ARG UV_VERSION=1.20.2
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    automake \
    qt5-default \
    libtool \
    python3-dev \
    python3-pip \
    libssl-dev \
    zlib1g-dev \
    libncurses5-dev \
    && rm -rf /var/lib/apt/lists/* \
    && curl -o libuv-v${UV_VERSION}.tar.gz https://dist.libuv.org/dist/v${UV_VERSION}/libuv-v${UV_VERSION}.tar.gz \
    && tar -zxf libuv-v${UV_VERSION}.tar.gz \
    && rm libuv-v${UV_VERSION}.tar.gz \
    && cd libuv-v${UV_VERSION} \
    && mkdir build \
    && cd build \
    && ../autogen.sh \
    && ../configure \
    && make -j 2 \
    && make install \
    && cd ../../ \
    && rm libuv-v${UV_VERSION} -rf \
    && ln /usr/local/lib/libuv.so.1.0.0 /lib/x86_64-linux-gnu/libuv.so.1 \
    && rm /usr/bin/python \
    && ln -s /usr/bin/python3.5 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip \
    && pip install setuptools wheel\
    && pip install six asn1crypto bcrypt chardet nose mock pbr pyasn1 requests \
    && pip install cffi multi_key_dict cryptography idna paramiko pyapi-gitlab \
    && pip install pyasn1 pycparser PyNaCl python-jenkins selenium

USER jenkins
