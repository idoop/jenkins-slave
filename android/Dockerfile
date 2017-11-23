FROM jenkins/jnlp-slave:latest
MAINTAINER Swire Chen<idoop@msn.cn>

#----Install Python3----#
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

# Install Android SDK
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/tools_r25.2.5-linux.zip" \
    ANDROID_BUILD_TOOLS_VERSION=27.0.0 \
    ANDROID_APIS="android-10,android-15,android-16,android-17,android-18,android-19,android-20,android-21,android-22,android-23,android-24,android-25,android-26" \
    ANT_HOME="/usr/share/ant" \
    MAVEN_HOME="/usr/share/maven" \
    GRADLE_HOME="/usr/share/gradle" \
    ANDROID_HOME="/opt/android"

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin

WORKDIR /opt

RUN dpkg --add-architecture i386 && \
    apt-get -qq update && \
    apt-get -qq install -y  maven ant gradle libncurses5:i386 libstdc++6:i386 zlib1g:i386 libgcc1:i386 && \

    # Installs Android SDK
    mkdir android && cd android && \
    wget -O tools.zip ${ANDROID_SDK_URL} && \
    unzip tools.zip && rm tools.zip && \
    echo y | android update sdk -a -u -t platform-tools,${ANDROID_APIS},build-tools-${ANDROID_BUILD_TOOLS_VERSION} && \
    chmod a+x -R $ANDROID_HOME && \
    chown -R root:root $ANDROID_HOME && \

    # Clean up
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean

    
# Install Nodejs

ENV NODEJS_VERSION=8.9.0 \
    PATH=$PATH:/opt/node/bin

WORKDIR /opt/node

RUN curl -sL https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.gz | tar xz --strip-components=1
    
# Install cordova

ENV CORDOVA_VERSION 7.1.0

WORKDIR /tmp

RUN npm i -g --unsafe-perm cordova@${CORDOVA_VERSION}

# Install ionic

ENV IONIC_VERSION 3.16.0

RUN npm i -g --unsafe-perm ionic@${IONIC_VERSION} && \
    ionic --no-interactive config set -g daemon.updates false 

# Set Timezone with CST
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo 'Asia/Shanghai' >/etc/timezone
  
USER jenkins
