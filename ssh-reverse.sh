#!/bin/sh

#中转服务器需要在/etc/ssh/sshd_config里面加一句：
#    GatewayPorts clientspecified，才能远程连接中转服务器，否则只能在中转
# 服务器上ssh到目标机器

KEY_FILE=$1
SSH=$(dirname "$0")/ssh
KNOWN_HOSTS=$(dirname "$0")/known_hosts

get_port()
{
    local RAN_NUM=`date +%s` 
    local t1=`expr $RAN_NUM % 50000`
    local PORT=`expr $t1 + 1030`
    
    return $PORT
}

NETSTAT="busy"   

while [ "$NETSTAT" != "" ]
do
    get_port;
    PORT=$?
    echo "尝试使用port:$PORT"

    NETSTAT=`$SSH -i "$KEY_FILE" -o UserKnownHostsFile="$KNOWN_HOSTS" ssh-reverse@115.29.171.150 "netstat -an | grep $PORT "`
    sleep 1
done

echo "开始使用PORT:$PORT"
$SSH -i $KEY_FILE -o UserKnownHostsFile="$KNOWN_HOSTS" -g -NfR *:$PORT:*:22 ssh-reverse@115.29.171.150
echo -e "请用下面语句登录远程ssh: \nssh matrix@115.29.171.150 -p $PORT"

messagebox 反向SSH "请用下面语句登录远程ssh: ssh matrix@115.29.171.150 -p $PORT" 1 确定 ""