#!/bin/bash

/usr/local/vpnserver/vpnserver start
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1 /adminhub:DEFAULT /CMD RadiusServerSet $RADIUS_SERVER:1812 /SECRET:$RADIUS_SECRET /RETRY_INTERVAL:500
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1 /adminhub:DEFAULT /CMD UserCreate \* /GROUP: /REALNAME: /NOTE:
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1 /adminhub:DEFAULT /CMD UserRadiusSet \* /ALIAS:
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1 /adminhub:DEFAULT /CMD SecureNatEnable
/usr/local/vpnserver/vpncmd /SERVER 127.0.0.1                   /CMD ServerCertSet /LOADCERT:$CERT_FILE /LOADKEY:$CERT_KEY
/usr/local/vpnserver/vpnserver stop

/usr/local/vpnserver/vpnserver execsvc
