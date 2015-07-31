#!/bin/bash

/usr/local/vpnserver/vpnserver start
if [ $? -ne 0 ]; then
    echo "error vpnserver start"
    exit 1
fi

;サーバーが起動されたかどうか、確認する。タイムラグがあるようです。
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1 /CMD ServerInfoGet
while [ $? -ne 0 ]
do
    sleep 1
    /usr/local/vpnserver/vpncmd /SERVER 127.0.0.1 /CMD ServerInfoGet
done

;RadiusServerの情報を設定する。
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1 /adminhub:DEFAULT /CMD RadiusServerSet $RADIUS_SERVER:1812 /SECRET:$RADIUS_SECRET /RETRY_INTERVAL:500
if [ $? -ne 0 ]; then
    echo "error RadiusServerSet"
    exit 1
fi

;RadiusServerを利用する汎用ユーザーを追加する。
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1 /adminhub:DEFAULT /CMD UserCreate \* /GROUP: /REALNAME: /NOTE:
if [ $? -ne 0 ]; then
    echo "error UserCreate"
    exit 1
fi

;追加した汎用ユーザーをRadiusServerを利用させる。
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1 /adminhub:DEFAULT /CMD UserRadiusSet \* /ALIAS:
if [ $? -ne 0 ]; then
    echo "error UserRadiusSet"
    exit 1
fi

;NatとDHCPを利用する。
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1 /adminhub:DEFAULT /CMD SecureNatEnable
if [ $? -ne 0 ]; then
    echo "error SecureNatEnable"
    exit 1
fi

;SSTPを利用時の証明書を設定する。
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1                   /CMD ServerCertSet /LOADCERT:$CERT_FILE /LOADKEY:$CERT_KEY
if [ $? -ne 0 ]; then
    echo "error ServerCertSet"
    exit 1
fi

;L2TP/IPsecを利用する。
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1                   /CMD IPsecEnable /L2TP:yes /L2TPRAW:no /ETHERIP:no /PSK:vpn /DEFAULTHUB:DEFAULT
if [ $? -ne 0 ]; then
    echo "error IPsecEnable"
    exit 1
fi

;サーバーを停止する。
/usr/local/vpnserver/vpnserver stop
if [ $? -ne 0 ]; then
    echo "error vpnserver stop"
    exit 1
fi

;サーバーをフロントモードで起動する。
/usr/local/vpnserver/vpnserver execsvc
