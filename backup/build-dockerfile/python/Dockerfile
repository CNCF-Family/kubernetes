FROM library/ubuntu:18.04

MAINTAINER denggang "dengang610@outlook.com"
ENV PYTHON_HOME /epetpython
ENV DEBIAN_FRONTEND=noninteractive
RUN mkdir $PYTHON_HOME && sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list && apt-get clean
WORKDIR $PYTHON_HOME

COPY id_rsa /root/.ssh/
COPY known_hosts /root/.ssh/

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:jonathonf/python-3.6 && \
    apt-get install -y build-essential python3.6 python3.6-dev python3-pip python3.6-venv  tzdata  && \
    apt-get install -y git vim  && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime && \
    chmod -R 400 /root/.ssh/

# update pip
RUN python3.6 -m pip install pip --upgrade && \
    python3.6 -m pip install wheel  pymysql  redis xlrd xlwt xlutils datetime oss2 selenium DingtalkChatbot paramunittest openpyxl jwt  pyjwt  ddt && \
    rm -rf /root/.cache && \
        apt-get purge -y $(apt-cache search '~c' | awk '{ print $2 }') && \
        apt-get -y autoremove && \
        apt-get -y autoclean && \
        apt-get -y clean all && \
        rm -rf /var/lib/apt/lists/* && \
        rm -rf /var/cache/apt && \
        rm -rf /tmp/*
