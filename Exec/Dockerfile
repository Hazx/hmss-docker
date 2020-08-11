FROM centos:7.8.2003

LABEL maintainer="hazx632823367@gmail.com"
LABEL Version="1.8"

COPY  * /root/hmss/

RUN yum install wget -y &&\
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo &&\
    yum makecache -y &&\
    yum install -y libev-devel c-ares-devel libsodium-devel mbedtls-devel &&\
    chmod a+x /root/hmss/start.sh /root/hmss/hmss /root/hmss/hmkcp /root/hmss/keep &&\
    yum remove -y wget &&\
    yum clean all &&\
    rm -rf /var/cache/yum

CMD  /root/hmss/start.sh
