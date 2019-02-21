FROM wiqun/jenkins-slave-base:latest
MAINTAINER Swire Chen<idoop@msn.cn>

#----Install c/cpp SDK ----#
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       automake \
       qt5-default \
       libtool \
    && rm -rf /var/lib/apt/lists/* \

USER jenkins
