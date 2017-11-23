FROM jenkins/jnlp-slave:latest
MAINTAINER Swire Chen<idoop@msn.cn>

#----Install .Net Core SDK & Nuget & Python3----#
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libc6 \
        libcurl3 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu57 \
        liblttng-ust0 \
        libssl1.0.2 \
        libstdc++6 \
        libunwind8 \
        libuuid1 \
        python3 \
        zlib1g \
        g++ \
        m4 \
        make \
        cmake \
        automake \
        libtool \
        zlib1g-dev \
        libssl-dev \
        libapr1-dev \
        libboost-system-dev \
        python3-dev \
        python3-pip \
        build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && git config --global credential.helper store
    
# Set Default symbolic python ==> python3,pip ==> pip3,and some modules
RUN rm /usr/bin/python && ln -s /usr/bin/python3.5 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip \
    && pip install setuptools \
    && pip install six asn1crypto bcrypt chardet nose mock pbr pyasn1 requests \
    && pip install cffi multi_key_dict cryptography idna paramiko pyapi-gitlab \
    && pip install pyasn1 pycparser PyNaCl python-jenkins selenium

# Install libuv
ENV LIBUV_VERSION 1.16.0
RUN curl -SL https://github.com/libuv/libuv/archive/v${LIBUV_VERSION}.tar.gz --output v${LIBUV_VERSION}.tar.gz \
    && tar -zxf v${LIBUV_VERSION}.tar.gz \
    && rm -rf v${LIBUV_VERSION}.tar.gz \
    && cd libuv-${LIBUV_VERSION} \
    && sh autogen.sh \
    && ./configure \
    && make \
    && make check \
    && make install \
    && cd ../ \
    && rm -rf libuv-${LIBUV_VERSION}

USER jenkins
