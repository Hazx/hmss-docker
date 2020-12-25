#!/bin/bash

# 配置冲突
if [[ ${SS_ONLY} == true ]] && [[ ${KCP_ONLY} == true ]];then
    echo "[ERROR] SS_ONLY and KCP_ONLY cannot be set to true at the same time!"
    exit 1
fi
if [[ ${SS_ONLY} == true ]] && [[ ${KCP2_ON} == true ]];then
    echo "[ERROR] SS_ONLY and KCP2_ON cannot be set to true at the same time!"
    exit 1
fi

# 默认配置
if [ ! -n "${SS_ONLY}" ] && [ ! -n "${KCP_ONLY}" ];then
    echo "[INFO] No SS_ONLY configured. The default parameters are being used."
    echo "===> SS_ONLY=false"
    echo ""
    SS_ONLY=false
    echo "[INFO] No KCP_ONLY configured. The default parameters are being used."
    echo "===> KCP_ONLY=false"
    echo ""
    KCP_ONLY=false
fi
if [ ! -n "${KCP_ONLY}" ];then
    echo "[INFO] No KCP_ONLY configured. The default parameters are being used."
    echo "===> KCP_ONLY=false"
    echo ""
    KCP_ONLY=false
fi
if [ ! -n "${SS_ONLY}" ] && [[ ${KCP_ONLY} == true ]];then
    echo "[INFO] No SS_ONLY configured. The default parameters are being used."
    echo "===> SS_ONLY=false"
    echo ""
    SS_ONLY=false
fi
if [[ ${SS_ONLY} == true ]];then
    echo "[INFO] SS_ONLY==true configured. The KCP2_ON auto set false."
    echo "===> KCP2_ON=false"
    echo ""
    KCP2_ON=false
fi
if [ ! -n "${KCP2_ON}" ];then
    echo "[INFO] No KCP2_ON configured. Default KCP2_ON=true"
    echo "===> KCP2_ON=true"
    echo ""
    KCP2_ON=true
fi



# 调整配置文件
# SS密码
if [ ! -n "${SS_PWD}" ] || [[ ${SS_PWD} == "" ]];then
    if [[ ${KCP_ONLY} == true ]];then
        if [ ! -n "${KCP_PWD}" ] || [[ ${KCP_PWD} == "" ]];then
            echo "[ERROR] KCP_ONLY Mode: No KCP or SS password configured. Please check container's environment variables."
            exit 1
        fi
    else
        echo "[ERROR] No SS password configured. Please check container's environment variables."
        exit 1
    fi
fi
sed -i "s/SS_PWD/$SS_PWD/g" /root/hmss/hmss.json

# SS加密算法
sed -i "s/SS_CR/${SS_CR:-"chacha20-ietf-poly1305"}/g" /root/hmss/hmss.json

# SS超时时间
sed -i "s/SS_TIME/${SS_TIME:-"600"}/g" /root/hmss/hmss.json

# SS MTU
sed -i "s/SS_MTU/${SS_MTU:-"1450"}/g" /root/hmss/hmss.json


# KCP密码
if [ ! -n "${KCP_PWD}" ] || [[ ${KCP_PWD} == "" ]];then
    echo "[INFO] No KCP password configured. Set KCP Password by SS password."
    sed -i "s/KCP_PWD/$SS_PWD/g" /root/hmss/kcp.json
    sed -i "s/KCP_PWD/$SS_PWD/g" /root/hmss/kcp2.json
else
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

# KCP DSCP
sed -i "s/KCP_SDSCP/${KCP_SDSCP:-"46"}/g" /root/hmss/kcp.json
sed -i "s/KCP_SDSCP/${KCP_SDSCP:-"46"}/g" /root/hmss/kcp2.json

# KCP Socket缓冲
sed -i "s/KCP_BUF/${KCP_BUF:-"4194304"}/g" /root/hmss/kcp.json
sed -i "s/KCP_BUF/${KCP_BUF:-"4194304"}/g" /root/hmss/kcp2.json

# KCP 禁用压缩
sed -i "s/KCP_NCP/${KCP_NCP:-"false"}/g" /root/hmss/kcp.json
sed -i "s/KCP_NCP/${KCP_NCP:-"false"}/g" /root/hmss/kcp2.json

# KCP 心跳时间
sed -i "s/KCP_KAL/${KCP_KAL:-"10"}/g" /root/hmss/kcp.json
sed -i "s/KCP_KAL/${KCP_KAL:-"10"}/g" /root/hmss/kcp2.json

# KCP 模拟TCP连接
sed -i "s/KCP_TCP/${KCP_TCP:-"false"}/g" /root/hmss/kcp.json
sed -i "s/KCP_TCP/${KCP_TCP:-"false"}/g" /root/hmss/kcp2.json



# 启动SS
if [[ ${KCP_ONLY} == false ]];then
    /root/hmss/hmss -c /root/hmss/hmss.json -f /root/hmss/hmss.pid -u
    if [[ $? != 0 ]];then
        echo "[ERROR] SS cannot start. Please check container's environment variables."
        exit 1
    else
        echo "[INFO] HMSS Running..."
        echo ""
    fi
fi

# 启动KCP
if [[ ${SS_ONLY} == false ]];then
    /root/hmss/hmkcp -c /root/hmss/kcp.json 2>&1 &
    if [[ $? != 0 ]];then
        echo "[ERROR] KCP cannot start. Please check container's environment variables."
        exit 1
    else
        sleep 3
        echo "[INFO] HMKCP Running..."
        cat /root/hmss/kcp.log
        echo ""
    fi
    if [[ ${KCP2_ON} == true ]];then
        /root/hmss/hmkcp -c /root/hmss/kcp2.json 2>&1 &
        if [[ $? != 0 ]];then
            echo "[ERROR] KCP cannot start. Please check container's environment variables."
            exit 1
        else
            sleep 3
            echo "[INFO] HMKCP2 Running..."
            cat /root/hmss/kcp2.log
            echo ""
        fi
    fi
fi

# 容器保活
/root/hmss/keep
