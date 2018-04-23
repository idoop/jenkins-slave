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
        gnupg \
        nuget \
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
        apt-transport-https \
	
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/microsoft.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends powershell \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb http://download.mono-project.com/repo/debian stable-stretch main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends mono-devel \
    && rm -rf /var/lib/apt/lists/* \
    && git config --global credential.helper store

COPY requirements.txt /var/

# Set Default symbolic python ==> python3,pip ==> pip3,and some modules
RUN rm /usr/bin/python && ln -s /usr/bin/python3.5 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip \
    && pip install setuptools wheel \
    && pip install -r /var/requirements.txt

# Install Scanner for MSBuild 4.0+
ENV SCANNER_MSBUILD_VERSIONI 4.0.2.892
ENV SCANNER_MSBUILD_DOWNLOAD_URL https://github.com/SonarSource/sonar-scanner-msbuild/releases/download/4.0.2.892/sonar-scanner-msbuild-4.0.2.892.zip
ENV SCANNER_MSBUILD_DOWNLOAD_SHA fcfe6694610e111ba11affc1434ffaa5e9ada58e11aef4935113e7b6944f57acd4d547c2317c7522dd202e45ba7730ed8594c532a3b17b94e921fa46378107dd

RUN curl -SL $SCANNER_MSBUILD_DOWNLOAD_URL --output sonar-scanner-msbuild.zip \
    && echo "$SCANNER_MSBUILD_DOWNLOAD_SHA sonar-scanner-msbuild.zip" | sha512sum -c - \
    && mkdir -p /usr/share/sonar-scanner-msbuild \
    && unzip sonar-scanner-msbuild.zip -d /usr/share/sonar-scanner-msbuild \
    && rm sonar-scanner-msbuild.zip \
    && ln -s /usr/share/sonar-scanner-msbuild/MSBuild.SonarQube.Runner.exe /usr/bin/MSBuild.SonarQube.Runner.exe \
    && chmod +x /usr/share/sonar-scanner-msbuild/sonar-scanner-3.0.3.778/bin/sonar-scanner \
    && sed -i '21d' /usr/share/sonar-scanner-msbuild/SonarQube.Analysis.xml && sed -i '22a \  \<!--' /usr/share/sonar-scanner-msbuild/SonarQube.Analysis.xml && sed -i 's/localhost:9000/192.168.1.61:9000/g' /usr/share/sonar-scanner-msbuild/SonarQube.Analysis.xml

# Install .NET Core SDK
ENV DOTNET_SDK_VERSION 2.1.4
ENV DOTNET_SDK_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-x64.tar.gz
ENV DOTNET_SDK_DOWNLOAD_SHA 05FE90457A8B77AD5A5EB2F22348F53E962012A55077AC4AD144B279F6CAD69740E57F165820BFD6104E88B30E93684BDE3E858F781541D4F110F28CD52CE2B7

RUN curl -SL $DOTNET_SDK_DOWNLOAD_URL --output dotnet.tar.gz \
    && echo "$DOTNET_SDK_DOWNLOAD_SHA dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Trigger the population of the local package cache
ENV NUGET_XMLDOC_MODE skip
RUN mkdir warmup \
    && cd warmup \
    && dotnet new \
    && cd .. \
    && rm -rf warmup \
    && rm -rf /tmp/NuGetScratch

# Set Timezone with CST
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo 'Asia/Shanghai' >/etc/timezone
  
USER jenkins
