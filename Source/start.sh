#!/bin/bash

# 默认配置
if [ ! -n "${KCP2_ON}" ];then
    echo "[INFO] No KCP2_ON configured. Default KCP2_ON=true"
    KCP2_ON=true
fi
if [ ! -n "${KCP_ONLY}" ];then
    echo "[INFO] No KCP_ONLY configured. Default KCP_ONLY=false"
    KCP_ONLY=false
fi


# 调整配置文件
# SS密码
if [[ ${KCP_ONLY} == true ]];then
    SS_PWD="KCP_ONLY"
elif [ ! -n "${SS_PWD}" ];then
    echo "[ERROR] No SS password configured. Please check container's environment variables."
    exit 1
elif [[ ${SS_PWD} == "" ]];then
    echo "[ERROR] No SS password configured. Please check container's environment variables."
    exit 1
fi
sed -i "s/SS_PWD/$SS_PWD/g" /root/hmss/hmss.json

# SS加密算法
sed -i "s/SS_CR/${SS_CR:-"chacha20-ietf-poly1305"}/g" /root/hmss/hmss.json

# SS超时时间
sed -i "s/SS_TIME/${SS_TIME:-"60"}/g" /root/hmss/hmss.json

# KCP密码
if [ ! -n "${KCP_PWD}" ];then
    sed -i "s/KCP_PWD/$SS_PWD/g" /root/hmss/kcp.json
    sed -i "s/KCP_PWD/$SS_PWD/g" /root/hmss/kcp2.json
else
    if [[ ${KCP_PWD} == "" ]];then
        KCP_PWD=$SS_PWD
    fi
    sed -i "s/KCP_PWD/$KCP_PWD/g" /root/hmss/kcp.json
    sed -i "s/KCP_PWD/$KCP_PWD/g" /root/hmss/kcp2.json
fi

# KCP加密方式
sed -i "s/KCP_CR/${KCP_CR:-"salsa20"}/g" /root/hmss/kcp.json
sed -i "s/KCP_CR/${KCP_CR:-"salsa20"}/g" /root/hmss/kcp2.json

# KCP模式
sed -i "s/KCP_MODE/${KCP_MODE:-"normal"}/g" /root/hmss/kcp.json

# KCP模式2
sed -i "s/KCP_MODE/${KCP_MODE2:-"fast"}/g" /root/hmss/kcp2.json

# KCP MTU
sed -i "s/KCP_MTU/${KCP_MTU:-"1450"}/g" /root/hmss/kcp.json
sed -i "s/KCP_MTU/${KCP_MTU:-"1450"}/g" /root/hmss/kcp2.json

# KCP目标
sed -i "s/KCP_TARGET/${KCP_TARGET:-"127.0.0.1:35000"}/g" /root/hmss/kcp.json
sed -i "s/KCP_TARGET/${KCP_TARGET:-"127.0.0.1:35000"}/g" /root/hmss/kcp2.json

# KCP发送窗口
sed -i "s/KCP_SW/${KCP_SW:-"1024"}/g" /root/hmss/kcp.json
sed -i "s/KCP_SW/${KCP_SW:-"1024"}/g" /root/hmss/kcp2.json

# KCP接收窗口
sed -i "s/KCP_RW/${KCP_RW:-"1024"}/g" /root/hmss/kcp.json
sed -i "s/KCP_RW/${KCP_RW:-"1024"}/g" /root/hmss/kcp2.json

# KCP数据包
sed -i "s/KCP_DS/${KCP_DS:-"10"}/g" /root/hmss/kcp.json
sed -i "s/KCP_DS/${KCP_DS:-"10"}/g" /root/hmss/kcp2.json

# KCP校验包
sed -i "s/KCP_PS/${KCP_PS:-"3"}/g" /root/hmss/kcp.json
sed -i "s/KCP_PS/${KCP_PS:-"3"}/g" /root/hmss/kcp2.json



# 启动SS
if [[ ${KCP_ONLY} == false ]];then
    /root/hmss/hmss -c /root/hmss/hmss.json -f /root/hmss/hmss.pid -u
    if [[ $? != 0 ]];then
        echo "[ERROR] SS cannot start. Please check container's environment variables."
        exit 1
    fi
fi

# 启动KCP
if [[ ${KCP2_ON} == true ]];then
    /root/hmss/hmkcp -c /root/hmss/kcp.json 2>&1 &
else
    /root/hmss/hmkcp -c /root/hmss/kcp.json 2>&1
fi
if [[ $? != 0 ]];then
    echo "[ERROR] KCP cannot start. Please check container's environment variables."
    exit 1
fi
if [[ ${KCP2_ON} == true ]];then
    /root/hmss/hmkcp -c /root/hmss/kcp2.json 2>&1
    if [[ $? != 0 ]];then
        echo "[ERROR] KCP cannot start. Please check container's environment variables."
        exit 1
    fi
fi

