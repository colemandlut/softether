#!/bin/bash

/usr/local/vpnserver/vpnserver start
if [ $? -ne 0 ]; then
    echo "error vpnserver start"
    exit 1
fi

;�T�[�o�[���N�����ꂽ���ǂ����A�m�F����B�^�C�����O������悤�ł��B
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1 /CMD ServerInfoGet
while [ $? -ne 0 ]
do
    sleep 1
    /usr/local/vpnserver/vpncmd /SERVER 127.0.0.1 /CMD ServerInfoGet
done

;RadiusServer�̏���ݒ肷��B
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1 /adminhub:DEFAULT /CMD RadiusServerSet $RADIUS_SERVER:1812 /SECRET:$RADIUS_SECRET /RETRY_INTERVAL:500
if [ $? -ne 0 ]; then
    echo "error RadiusServerSet"
    exit 1
fi

;RadiusServer�𗘗p����ėp���[�U�[��ǉ�����B
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1 /adminhub:DEFAULT /CMD UserCreate \* /GROUP: /REALNAME: /NOTE:
if [ $? -ne 0 ]; then
    echo "error UserCreate"
    exit 1
fi

;�ǉ������ėp���[�U�[��RadiusServer�𗘗p������B
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1 /adminhub:DEFAULT /CMD UserRadiusSet \* /ALIAS:
if [ $? -ne 0 ]; then
    echo "error UserRadiusSet"
    exit 1
fi

;Nat��DHCP�𗘗p����B
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1 /adminhub:DEFAULT /CMD SecureNatEnable
if [ $? -ne 0 ]; then
    echo "error SecureNatEnable"
    exit 1
fi

;SSTP�𗘗p���̏ؖ�����ݒ肷��B
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1                   /CMD ServerCertSet /LOADCERT:$CERT_FILE /LOADKEY:$CERT_KEY
if [ $? -ne 0 ]; then
    echo "error ServerCertSet"
    exit 1
fi

;L2TP/IPsec�𗘗p����B
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1                   /CMD IPsecEnable /L2TP:yes /L2TPRAW:no /ETHERIP:no /PSK:vpn /DEFAULTHUB:DEFAULT
if [ $? -ne 0 ]; then
    echo "error IPsecEnable"
    exit 1
fi

;�T�[�o�[���~����B
/usr/local/vpnserver/vpnserver stop
if [ $? -ne 0 ]; then
    echo "error vpnserver stop"
    exit 1
fi

;�T�[�o�[���t�����g���[�h�ŋN������B
/usr/local/vpnserver/vpnserver execsvc
