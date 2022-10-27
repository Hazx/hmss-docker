## HMSS

　　HMSS是一个Shadowsocks + KCPTUN 的 Docker 镜像，如果你有需要的话可以随意借鉴和使用。另有客户端版本HMSS-CLIENT：https://github.com/Hazx/hmss-client-docker

　　若仅使用，可直接拉取 Docker Hub 的版本：`hazx/hmss:1.10`


# hmss-1.10

## 内置模块版本

- shadowsocks: 3.3.5
- simple-obfs : 20190817
- kcptun: 20221015


## 内部端口

模块 | 端口 | 协议
---|---|---
Shadowsocks | 35000 | TCP - SS监听端口（TCP）
Shadowsocks | 35000 | UDP - SS监听端口（UDP）
KCPTUN | 45000 | TCP - KCP模拟TCP通信端口
KCPTUN | 45000 | UDP - KCP监听端口
KCPTUN (2) | 45001 | TCP - KCP模拟TCP通信端口
KCPTUN (2) | 45001 | UDP - KCP监听端口


## 构建镜像

运行以下命令以开始构建：

```
chmod +x ./build.sh && ./build.sh
```

镜像构建完成后，将保存至 `output` 目录。


## 启动镜像

```shell
docker run -d -p SS端口:35000 -p SS端口:35000/udp -p KCP端口:45000 -p KCP端口:45000/udp --name hmss -e SS_PWD="密码" --restart unless-stopped hmss:1.10
```
默认情况下会启动一个SS和两个KCP服务端，实际监听端口及协议要按需求配置。SS需要1个端口2个协议，每个KCP服务端需要1个端口至少UDP协议，若KCP开了TCP模拟还需要开TCP协议。


### 可使用的环境变量

使用方法：`-e SS_PWD="xxxxx" -e SS_CR="xxxx" -e KCP_CR="xxxx"`

环境变量 | 功能 | 默认值
---|---|---
SS_PWD | SS密码 |
SS_CR | SS加密算法 | chacha20-ietf-poly1305
SS_TIME | SS超时时间 | 600（单位秒）
SS_MTU | SS MTU | 1450
SS_EXM | 增强模式 | none
SS_EXH | 伪域名 | 
SS_TFO | TCP Fast Open | false
SS_ONLY | 只起SS，关闭KCP | false
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
KCP_SDSCP | KCP DSCP | 46（二进制101110）
KCP_BUF | KCP Socket缓冲 | 4194304（单位字节）
KCP_NCP | KCP禁用压缩 | false
KCP_KAL | KCP心跳时间 | 10（单位秒）
KCP_TCP | KCP模拟TCP连接 | false
KCP2_ON | 启用双KCP | true
KCP_ONLY | 只启KCP，关闭SS | false

- SS_CR 参考值：`rc4-md5`, `aes-128-gcm`, `aes-192-gcm`, `aes-256-gcm`, `aes-128-cfb`, `aes-192-cfb`, `aes-256-cfb`, `aes-128-ctr`, `aes-192-ctr`, `aes-256-ctr`, `camellia-128-cfb`, `camellia-192-cfb`, `camellia-256-cfb`, `bf-cfb`, `chacha20-ietf-poly1305`, `xchacha20-ietf-poly1305`, `salsa20`, `chacha20`, `chacha20-ietf`
- SS_EXM 参考值：`none`, `http`, `tls`
- KCP_CR 参考值：`aes`, `aes-128`, `aes-192`, `salsa20`, `blowfish`, `twofish`, `cast5`, `3des`, `tea`, `xtea`, `xor`, `sm4`, `none`
- KCP_MODE 参考值：`fast3`, `fast2`, `fast`, `normal`, `manual`