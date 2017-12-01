FROM wiqun/jenkins-ionic
MAINTAINER Swire Chen<idoop@msn.cn>

#----Install .Net Core SDK & Nuget & Python3----#
USER root

COPY ./slave.jar /root/

ENTRYPOINT [ "java", "-jar", "slave.jar", "-jnlpUrl" ]

