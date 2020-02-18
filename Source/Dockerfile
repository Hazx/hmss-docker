FROM centos:7.6.1810

LABEL maintainer="hazx632823367@gmail.com"
LABEL Version="1.7"

COPY  * /root/hmss/

RUN yum install -y epel-release ;\
    yum install -y gcc gettext autoconf libtool automake make pcre-devel asciidoc xmlto c-ares-devel libev-devel libsodium-devel mbedtls-devel ;\
    cd /root/hmss ;\
    gcc keep.c -o keep ;\
    rm -fr keep.c ;\
    tar zxvf shadowsocks-libev-3.3.4.tar.gz ;\
    cd shadowsocks-libev-3.3.4 ;\
    ./configure --prefix="/root/hmss/ssexe" ;\
    make ;\
    make install ;\
    mv /root/hmss/ssexe/bin/ss-server /root/hmss/hmss ;\
    cd /root/hmss ;\
    rm -fr shadowsocks* ;\
    rm -fr ssexe ;\
    tar zxvf kcptun-linux-amd64-20200201.tar.gz ;\
    mv server_linux_amd64 hmkcp ;\
    rm -fr kcptun* client* ;\
    chmod a+x /root/hmss/start.sh /root/hmss/hmss /root/hmss/hmkcp /root/hmss/keep ;\
    yum remove -y gcc autoconf automake make ;\
    yum clean all ;\
    rm -rf /var/cache/yum

CMD  /root/hmss/start.sh

