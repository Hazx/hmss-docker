#!/bin/bash

## 内置模块来源
## https://github.com/shadowsocks/shadowsocks-libev
## https://github.com/shadowsocks/simple-obfs
## https://github.com/shadowsocks/libcork/tree/simple-obfs
## https://github.com/xtaci/kcptun

hmss_img=hmss
hmss_tag=1.10

## 清理工作目录
if [ -e build_${hmss_img} ];then
    rm -fr build_${hmss_img}
fi
if [ -e output/${hmss_img}-${hmss_tag}.tar ];then
    rm -fr output/${hmss_img}-${hmss_tag}.tar
fi

mkdir -p build_${hmss_img}
mkdir -p output

## 构建
cp -R build build_${hmss_img}/
cat <<EOF > build_${hmss_img}/build/Dockerfile
FROM centos:7.9.2009
LABEL maintainer="hazx632823367@gmail.com"
LABEL Version="${hmss_tag}-build"
COPY * /root/hmss/
RUN mv /root/hmss/IDR-build-sh /root/hmss/build.sh ;\
    mv /root/hmss/IDR-buildex-sh /root/hmss/export.sh ;\
    chmod +x /root/hmss/*.sh ;\
    /root/hmss/build.sh
CMD /root/hmss/export.sh
EOF

## 导出构建内容
docker build -t ${hmss_img}:${hmss_tag}-build build_${hmss_img}/build/
pwd_dir=$(cd $(dirname $0); pwd)
mkdir -p build_${hmss_img}/package
docker run --rm --name tmp-hmss-build-export \
    -v ${pwd_dir}/build_${hmss_img}/package:/export \
    ${hmss_img}:${hmss_tag}-build

## 打包最终镜像
cp config/* build_${hmss_img}/package/
cp build/IDR-svcstart-sh build_${hmss_img}/package/start.sh
cat <<EOF > build_${hmss_img}/package/Dockerfile
FROM centos:7.9.2009
LABEL maintainer="hazx632823367@gmail.com"
LABEL Version="${hmss_tag}"
COPY * /root/hmss/
RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
        -e 's|^#baseurl=http://mirror.centos.org|baseurl=https://mirrors.bfsu.edu.cn|g' \
        -i /etc/yum.repos.d/CentOS-*.repo ;\
    yum makecache ;\
    yum install epel-release -y ;\
    sed -e 's!^metalink=!#metalink=!g' \
        -e 's!^#baseurl=!baseurl=!g' \
        -e 's!//download\.fedoraproject\.org/pub!//mirrors.bfsu.edu.cn!g' \
        -e 's!//download\.example/pub!//mirrors.bfsu.edu.cn!g' \
        -e 's!http://mirrors!https://mirrors!g' \
        -i /etc/yum.repos.d/epel*.repo ;\
    yum makecache fast ;\
    yum install -y libev-devel c-ares-devel libsodium-devel mbedtls-devel ;\
    chmod a+x /root/hmss/start.sh ;\
    chmod a+x /root/hmss/hmss ;\
    chmod a+x /root/hmss/hmkcp ;\
    chmod a+x /root/hmss/keep ;\
    chmod a+x /root/hmss/hmob ;\
    yum clean all ;\
    rm -rf /var/cache/yum ;\
    rm -f /root/hmss/Dockerfile
WORKDIR /root/hmss
CMD /root/hmss/start.sh
EOF

docker build -t ${hmss_img}:${hmss_tag} build_${hmss_img}/package/
docker save -o output/${hmss_img}-${hmss_tag}.tar ${hmss_img}:${hmss_tag}

## 清理垃圾
docker rmi ${hmss_img}:${hmss_tag}-build
docker rmi ${hmss_img}:${hmss_tag}
rm -fr build_${hmss_img}

echo "Docker build finished."
echo "Image name: ${hmss_img}:${hmss_tag}"
echo "Image Path: output/${hmss_img}-${hmss_tag}.tar"