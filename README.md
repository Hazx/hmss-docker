## HMSS & HMSS-CLIENT

　　一个我本人制作和使用的 Shadowsocks + KCPTUN 的 Docker 镜像，顺带分享出来，如果你有需要的话可以随意借鉴和使用。另有客户端版本HMSS-CLIENT：https://github.com/Hazx/hmss-client-docker


## 使用

　　当前这里只是制作镜像用的一些源文件，若您只想使用现成的镜像，可以直接参考 Docker Hub: https://hub.docker.com/r/hazx/hmss

下载镜像：（由于每个版本之间存在使用方法的差异，所以不提供 latest，TAG 需替换为准确的版本号）
```
docker pull hazx/hmss:TAG
```


## 目录
- Source: 这是最原始的制作目录，使用的是 Shadowsocks 和 KCPTUN 的源码进行编译，最终打包成 Docker 镜像。但是镜像体积会比较大。
- Exec: 这是提取了编译好的程序后重新打包制作的目录，Docker Hub 上的镜像就是基于这个目录制作的，体积较 Source 目录制作的镜像会小很多。

