﻿# hmss-1.6
## 使用的服务端版本

- shadowsocks: 3.3.1
- kcptun: 20190910


## 内部端口

组件 | 端口 | 协议
---|---|---
Shadowsocks | 35000 | TCP
Shadowsocks | 35000 | udp
KCPTUN | 45000 | udp
KCPTUN (2) | 45001 | udp


## 构建镜像前的准备工作

　　运行dl.sh下载软件源码包。（或可自己在GitHub上搜索下载指定版本的服务端的源码包，并修改Dockerfile中相关的文件名。）

## 构建镜像
```
docker build -t 新镜像名称 .
```


## 启动镜像
```shell
docker run -itd -p SS端口:35000 -p SS端口:35000/udp -p KCP端口:45000/udp -p KCP端口2:45001/udp --name 容器名称 -e SS_PWD="密码" --restart unless-stopped 镜像名
```
默认情况下会启动一个SS和两个KCP服务端，共监听3个端口（其中SS端口是同一个端口号、两个协议），可按需开启和配置。


### 可使用的环境变量

使用方法：-e SS_PWD="xxxxx" -e SS_CR="xxxx" -e KCP_CR="xxxx"

环境变量 | 功能 | 默认值
---|---|---
SS_PWD | SS密码
SS_CR | SS加密算法 | chacha20-ietf-poly1305
SS_TIME | SS超时时间 | 60
KCP_PWD | KCP密码 | （同SS_PWD）
KCP_CR | KCP加密算法 | salsa20
KCP_MODE | KCP模式 | normal
KCP_MODE2 | KCP模式2 | fast
KCP_MTU | KCP MTU| 1450
KCP_TARGET | KCP连接目标 | 127.0.0.1:35000
KCP_SW | KCP发送窗口 | 1024
KCP_RW | KCP接收窗口 | 1024
KCP_DS | KCP数据包 | 10
KCP_PS | KCP校验包 | 3
KCP2_ON | 启用双KCP | true
KCP_ONLY | 关闭SS | false

- SS_CR参考值：rc4-md5, aes-128-gcm, aes-192-gcm, aes-256-gcm, aes-128-cfb, aes-192-cfb, aes-256-cfb, aes-128-ctr, aes-192-ctr, aes-256-ctr, camellia-128-cfb, camellia-192-cfb, camellia-256-cfb, bf-cfb, chacha20-ietf-poly1305, xchacha20-ietf-poly1305, salsa20, chacha20 and chacha20-ietf
- KCP_CR参考值：aes, aes-128, aes-192, salsa20, blowfish, twofish, cast5, 3des, tea, xtea, xor, sm4, none
- KCP_MODE参考值：fast3, fast2, fast, normal, manual