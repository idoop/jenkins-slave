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
    NODEJS_HOME="/opt/node" \
    NODEJS_VERSION="6.14.3" \
    GRADLE_VERSION=4.5.1

ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin:$NODEJS_HOME/bin

RUN dpkg --add-architecture i386 \
    && apt-get -qq update \
    && apt-get -qq install -y lib32stdc++6 lib32z1 --no-install-recommends \
    
    # Install OSS2 for APK hot upgrade
    && pip install oss2 \
    
    # Install Nodejs
    && mkdir -p ${NODEJS_HOME}/bin && cd ${NODEJS_HOME} \
    && curl -sL https://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}-linux-x64.tar.gz | tar xz --strip-components=1 \
    
    # Install Ionic Cordova
    && npm install -g ionic cordova gulp cordova-hot-code-push-cli \

    # Install Gradle
    && curl -SL https://downloads.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -o /tmp/gradle.zip \
    && unzip /tmp/gradle.zip -d /tmp/ && rm /tmp/gradle.zip \
    && mv /tmp/gradle-$GRADLE_VERSION /usr/share/gradle \

    # Install Android SDK
    && mkdir -p ${ANDROID_HOME} && cd ${ANDROID_HOME} \
    && curl -SL ${ANDROID_SDK_URL} -o /tmp/tools.zip \
    && unzip /tmp/tools.zip -d ./ && rm /tmp/tools.zip \
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
