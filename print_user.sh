#!/bin/bash
nuser="ops"
find /opt/docker-compose/openvpn/test/conf/pki -name "${nuser}*"

#可手動刪除以下路徑搜尋到的使用者
#find /opt/docker-compose/openvpn/test/conf/pki -name "${nuser}*" | xargs rm -rf
