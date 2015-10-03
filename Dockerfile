FROM ubuntu:14.04

MAINTAINER Lukas Rist <glaslos@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

## setup APT

## Install dependencies
RUN apt-get update && apt-get install -y \
        build-essential \
        g++ \
        gfortran \
        git \
        libevent-dev \
        liblapack-dev \
        libmysqlclient-dev \
        libxml2-dev \
        libxslt-dev \
        make \
        php5-cli \
        php5-dev \
        python-beautifulsoup \
        python-chardet \
        python-dev \
        python-gevent \
        python-lxml \
        python-openssl \
        python-pip \
        python-requests \
        python-setuptools \
        python-sqlalchemy \
        python2.7 \
        python2.7-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## Install and configure the PHP sandbox
RUN git clone https://github.com/mushorg/BFR.git /opt/BFR && \
    cd /opt/BFR && \
    phpize && \
    ./configure --enable-bfr && \
    make && \
    make install && \
    echo "zend_extension = "$(find /usr -name bfr.so) >> /etc/php5/cli/php.ini && \
    rm -rf /opt/BFR /tmp/* /var/tmp/*


## Install glastopf from latest sources
RUN git clone https://github.com/mushorg/glastopf.git /opt/glastopf && \
    cd /opt/glastopf && \
    python setup.py install && \
    rm -rf /opt/glastopf /tmp/* /var/tmp/*

##Install nano
ENV TERM xterm


## Configuration
RUN mkdir /var/glastopf
RUN mkdir /var/glastopf/log

EXPOSE 80
VOLUME /var/glastopf/log
WORKDIR /var/glastopf
CMD ["glastopf-runner"]
