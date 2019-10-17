FROM centos:7.6.1810

LABEL maintainer="hazx632823367@gmail.com"
LABEL Version="1.6.1"

COPY  * /root/hmss/

RUN yum install -y epel-release &&\
    yum install -y libev-devel c-ares-devel libsodium-devel mbedtls-devel &&\
    chmod a+x /root/hmss/start.sh /root/hmss/hmss /root/hmss/hmkcp &&\
    yum clean all &&\
    rm -rf /var/cache/yum

CMD  /root/hmss/start.sh
