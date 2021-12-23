# Базовый образ с КриптоПро
FROM centos:centos7 as cryptopro-generic

# Устанавливаем timezone
ENV TZ="Europe/Moscow" \
    docker="1"

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# необходимо скачать со страницы https://www.cryptopro.ru/products/csp/downloads
# `КриптоПро CSP 4.0 для Linux (x64, rpm)` и скопировать `linux-amd64.tgz` в каталог `dist`

ADD dist /tmp/src
RUN yum makecache fast && yum install -y redhat-lsb-core && yum clean all
RUN cd /tmp/src && \
    tar -xzf linux-amd64.tgz && \
    linux-amd64/install.sh && \
    yum install -y linux-amd64/cprocsp-rsa-64-4.0.9963-5.x86_64.rpm && \
    # делаем симлинки
    cd /bin && \
    ln -s /opt/cprocsp/bin/amd64/certmgr && \
    ln -s /opt/cprocsp/bin/amd64/cpverify && \
    ln -s /opt/cprocsp/bin/amd64/cryptcp && \
    ln -s /opt/cprocsp/bin/amd64/csptest && \
    ln -s /opt/cprocsp/bin/amd64/csptestf && \
    ln -s /opt/cprocsp/bin/amd64/der2xer && \
    ln -s /opt/cprocsp/bin/amd64/inittst && \
    ln -s /opt/cprocsp/bin/amd64/wipefile && \
    ln -s /opt/cprocsp/sbin/amd64/cpconfig && \
    # прибираемся
    rm -rf /tmp/src

