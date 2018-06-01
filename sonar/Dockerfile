FROM wiqun/jenkins-slave-base:latest
MAINTAINER Swire Chen<idoop@msn.cn>

#----Install Sonar----#
USER root
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
    && echo "deb http://download.mono-project.com/repo/debian stable-stretch main" | tee /etc/apt/sources.list.d/mono-official-stable.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends mono-devel \
    && rm -rf /var/lib/apt/lists/*

# Install Scanner for MSBuild 4.0+
ENV SCANNER_MSBUILD_VERSIONI 4.0.2.892
ENV SCANNER_MSBUILD_DOWNLOAD_URL https://github.com/SonarSource/sonar-scanner-msbuild/releases/download/4.0.2.892/sonar-scanner-msbuild-4.0.2.892.zip
ENV SCANNER_MSBUILD_DOWNLOAD_SHA fcfe6694610e111ba11affc1434ffaa5e9ada58e11aef4935113e7b6944f57acd4d547c2317c7522dd202e45ba7730ed8594c532a3b17b94e921fa46378107dd

RUN curl -sSL $SCANNER_MSBUILD_DOWNLOAD_URL --output sonar-scanner-msbuild.zip \
    && echo "$SCANNER_MSBUILD_DOWNLOAD_SHA sonar-scanner-msbuild.zip" | sha512sum -c - \
    && mkdir -p /usr/share/sonar-scanner-msbuild \
    && unzip sonar-scanner-msbuild.zip -d /usr/share/sonar-scanner-msbuild \
    && rm sonar-scanner-msbuild.zip \
    && ln -s /usr/share/sonar-scanner-msbuild/MSBuild.SonarQube.Runner.exe /usr/bin/MSBuild.SonarQube.Runner.exe \
    && chmod +x /usr/share/sonar-scanner-msbuild/sonar-scanner-3.0.3.778/bin/sonar-scanner \
    && sed -i '21d' /usr/share/sonar-scanner-msbuild/SonarQube.Analysis.xml && sed -i '22a \  \<!--' /usr/share/sonar-scanner-msbuild/SonarQube.Analysis.xml && sed -i 's/localhost:9000/192.168.1.61:9000/g' /usr/share/sonar-scanner-msbuild/SonarQube.Analysis.xml

USER jenkins
