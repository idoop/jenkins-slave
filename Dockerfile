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
    && pip install paramiko==2.4.1 \
                pyapi-gitlab==7.8.5 \
                python-jenkins==1.0.1 \
                urllib3==1.22 \
                requests==2.18.4 \
                kubernetes==6.0.0 \
                pytz==2018.4 \
                PyYAML==3.12 \
                msgpack=0.5.6 \
                pytest=3.9.2 \
		fabric==2.4.0 \
    # Set Timezone with CST
    && /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo 'Asia/Shanghai' >/etc/timezone
