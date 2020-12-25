# hmss-1.8
## 使用的服务端版本

- shadowsocks: 3.3.5
- kcptun: 20201126


## 内部端口

组件 | 端口 | 协议
---|---|---
Shadowsocks | 35000 | TCP - SS监听端口（TCP）
Shadowsocks | 35000 | UDP - SS监听端口（UDP）
KCPTUN | 45000 | TCP - KCP模拟TCP通信端口
KCPTUN | 45000 | UDP - KCP监听端口
KCPTUN (2) | 45001 | TCP - KCP模拟TCP通信端口
KCPTUN (2) | 45001 | UDP - KCP监听端口


## 构建镜像前的准备工作

　　拷贝编译好的 ss-server 并更名为 hmss ，拷贝 kcptun 客户端 server_linux_amd64 并更名为 hmkcp 。

## 构建镜像
```
docker build -t hazx/hmss:1.9 .
```


## 启动镜像
```shell
docker run -d -p SS端口:35000 -p SS端口:35000/udp -p KCP端口:45000 -p KCP端口:45000/udp --name 容器名称 -e SS_PWD="密码" --restart unless-stopped hazx/hmss:1.9
```
默认情况下会启动一个SS和两个KCP服务端，实际监听端口及协议要按需求配置。SS需要1个端口2个协议，每个KCP服务端需要1个端口至少UDP协议，若开了TCP模拟还需要开TCP协议。


### 可使用的环境变量

使用方法：-e SS_PWD="xxxxx" -e SS_CR="xxxx" -e KCP_CR="xxxx"

环境变量 | 功能 | 默认值 | 应用版本
---|---|---|---
SS_PWD | SS密码| | >= 1.6.0
SS_CR | SS加密算法 | chacha20-ietf-poly1305 | >= 1.6.0
SS_TIME | SS超时时间 | 600（单位秒，1.9.0之前默认60） | >= 1.6.0
SS_MTU | SS MTU | 1450 | >= 1.6.2
SS_ONLY | 关闭KCP | false | >= 1.6.2
KCP_PWD | KCP密码 | （同SS_PWD） | >= 1.6.0
KCP_CR | KCP加密算法 | salsa20 | >= 1.6.0
KCP_MODE | KCP模式 | normal | >= 1.6.0
KCP_MODE2 | KCP模式2 | fast | >= 1.6.0
KCP_MTU | KCP MTU| 1450 | >= 1.6.0
KCP_TARGET | KCP连接目标 | 127.0.0.1:35000 | >= 1.6.0
KCP_SW | KCP发送窗口 | 1024 | >= 1.6.0
KCP_RW | KCP接收窗口 | 1024 | >= 1.6.0
KCP_DS | KCP数据包 | 10 | >= 1.6.0
KCP_PS | KCP校验包 | 3 | >= 1.6.0
KCP_SDSCP | KCP DSCP | 46（101110） | >= 1.6.2
KCP_BUF | KCP Socket缓冲 | 4194304（单位字节） | >= 1.6.2
KCP_NCP | KCP禁用压缩 | false | >= 1.9.0
KCP_KAL | KCP心跳时间 | 10（单位秒） | >= 1.9.0
KCP_TCP | KCP模拟TCP连接 | false | >= 1.9.0
KCP2_ON | 启用双KCP | true | >= 1.6.0
KCP_ONLY | 关闭SS | false | >= 1.6.0


- SS_CR参考值：rc4-md5, aes-128-gcm, aes-192-gcm, aes-256-gcm, aes-128-cfb, aes-192-cfb, aes-256-cfb, aes-128-ctr, aes-192-ctr, aes-256-ctr, camellia-128-cfb, camellia-192-cfb, camellia-256-cfb, bf-cfb, chacha20-ietf-poly1305, xchacha20-ietf-poly1305, salsa20, chacha20 and chacha20-ietf
- KCP_CR参考值：aes, aes-128, aes-192, salsa20, blowfish, twofish, cast5, 3des, tea, xtea, xor, sm4, none
- KCP_MODE参考值：fast3, fast2, fast, normal, manual