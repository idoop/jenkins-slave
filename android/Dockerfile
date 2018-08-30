FROM wiqun/jenkins-slave-base:latest
MAINTAINER Swire Chen<idoop@msn.cn>

USER root

ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/tools_r25.2.5-linux.zip" \
    ANDROID_BUILD_TOOLS_VERSION=27.0.0 \
    ANDROID_APIS="android-10,android-15,android-16,android-17,android-18,android-19,android-20,android-21,android-22,android-23,android-24,android-25,android-26" \
    ANT_HOME="/usr/share/ant" \
    MAVEN_HOME="/usr/share/maven" \
    GRADLE_HOME="/usr/share/gradle" \
    ANDROID_HOME="/opt/android" \
    NODEJS_VERSION="6.14.3"

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin:$PATH:/opt/node/bin

RUN mkdir -p /opt/node/ -p \
    && dpkg --add-architecture i386 \
    && apt-get -qq update \
    && apt-get -qq install -y lib32stdc++6 lib32z1 --no-install-recommends \
    
    # Install Nodejs
    && cd /opt/node \
    && curl -sL https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.gz | tar xz --strip-components=1 \
    
    # Install Ionic Cordova
    && npm install -g ionic cordova gulp \

    # Install Android SDK
    && cd /opt && mkdir android && cd android \
    && curl -SL ${ANDROID_SDK_URL} -o tools.zip \
    && unzip tools.zip && rm tools.zip \
    && echo y | android update sdk -a -u -t platform-tools,${ANDROID_APIS},build-tools-${ANDROID_BUILD_TOOLS_VERSION} \
    && chmod a+x -R $ANDROID_HOME \
    && chown -R root:root $ANDROID_HOME \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && apt-get autoremove -y \
    && apt-get clean \
    
    # Set Timezone with CST
    && /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone
  
USER jenkins