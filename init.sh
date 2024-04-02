#!/bin/bash
ENV="test"
CONTAINER_NAME="openvpn-test"
FILE_NAME="compose-openvpn-${ENV}.yml"
COMPOSE_DIR="/opt/docker-compose/openvpn/${ENV}/${FILE_NAME}"

PRIVATE_IP=$(hostname -I|awk '{print $1}')                   
echo -e "\nOpenVPN IP: ${PRIVATE_IP}\n"                               
### 刪除原有容器內變數檔
docker-compose -f ${COMPOSE_DIR} run --rm ${CONTAINER_NAME} rm /etc/openvpn/ovpn_env.sh
### 產生容器內配置                                                                              
docker-compose -f ${COMPOSE_DIR} run --rm ${CONTAINER_NAME} ovpn_genconfig -N -d -n 10.0.0.175 \
  -u udp://${PRIVATE_IP} \
  -p "route 10.0.0.0 255.255.255.0" \
  -p "route 172.21.0.0 255.255.255.0" \
  -p "route 172.16.0.0 255.255.0.0" \
  -p "route 172.20.0.0 255.255.0.0" \
  -p "auth-nocache" \
  -p "reneg-sec 0"

docker-compose -f ${COMPOSE_DIR} run --rm ${CONTAINER_NAME} ovpn_initpki
