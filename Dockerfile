FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y \
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

RUN git clone https://github.com/glastopf/BFR.git /var/BFR && \
    cd /var/BFR && \
    phpize && \
    ./configure --enable-bfr && \
    make && \
    make install && \
    echo "zend_extension = "$(find /usr -name bfr.so) >> /etc/php5/cli/php.ini && \
    rm -rf /var/BFR /tmp/* /var/tmp/*

RUN git clone https://github.com/glastopf/glastopf.git /var/glastopf && \
    cd /var/glastopf && \
    python setup.py install && \
    rm -rf /var/glastopf /tmp/* /var/tmp/*

RUN mkdir -p /var/glastopf
#ADD glastopf.cfg /var/glastopf

WORKDIR /var/glastopf
CMD ["glastopf-runner"]
