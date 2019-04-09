FROM wiqun/jenkins-slave-base:latest
MAINTAINER Swire Chen<idoop@msn.cn>

USER root

ARG ANDROID_APIS="android-20,android-21,android-22,android-23,android-24,android-25,android-26,android-27,android-28"
ARG ANDROID_BUILD_TOOLS_VER=28.0.2
ARG ANDROID_SDK_TOOLS_VER=4333796
ARG FLUTTER_VER=1.2.1-stable
ARG GRADLE_VER=5.3.1

ENV ANDROID_HOME="/opt/android" \
    FLUTTER_HOME="/opt/flutter" \
    FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn" \
    GRADLE_HOME="/usr/share/gradle" \
    PUB_HOSTED_URL="https://pub.flutter-io.cn"

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/build-tools/${ANDROID_BUILD_TOOLS_VER}:${GRADLE_HOME}/bin:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin

RUN dpkg --add-architecture i386 \
    && apt-get -qq update \
    && apt-get -qq install -y lib32stdc++6 lib32z1 --no-install-recommends \

    # Install Gradle
    && curl -SL https://downloads.gradle.org/distributions/gradle-${GRADLE_VER}-bin.zip -o /tmp/gradle.zip \
    && unzip /tmp/gradle.zip -d /tmp/ \
    && rm /tmp/gradle.zip \
    && mv /tmp/gradle-${GRADLE_VER} ${GRADLE_HOME} \

    # Install Android SDK
    && mkdir -p ${ANDROID_HOME} \
    && cd ${ANDROID_HOME} \
    && curl -sSL https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS_VER}.zip -o /tmp/tools.zip \
    && unzip /tmp/tools.zip -d ./ \
    && rm /tmp/tools.zip \
    && yes | sdkmanager --licenses \
    && yes | android update sdk -a -u -t platform-tools,${ANDROID_APIS},build-tools-${ANDROID_BUILD_TOOLS_VER} \
    && chmod a+x -R ${ANDROID_HOME} \
    && chown -R root:root ${ANDROID_HOME} \

    # Install Flutter
    && curl -sSL https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v${FLUTTER_VER}.tar.xz -o /tmp/flutter.tar.xz \
    && tar -xf /tmp/flutter.tar.xz -C /opt \
    && rm /tmp/flutter.tar.xz \
    && flutter config --no-analytics \

    # Clean
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && apt-get autoremove -y \
    && apt-get clean
  
USER jenkins
