FROM jenkins/jnlp-slave:latest
MAINTAINER Swire Chen<idoop@msn.cn>

#----Install Base Env----#
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    python3-dev \
    python3-pip \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/* \
    && git config --global credential.helper store \
    && rm /usr/bin/python && ln -s /usr/bin/python3.5 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip \
    && pip install setuptools wheel \
        pyapi-gitlab==7.8.5 \
        python-jenkins==1.0.0 \
        urllib3==1.22 \
        requests==2.18.4

# Set Timezone with CST
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone