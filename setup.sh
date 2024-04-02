#!/bin/bash
ENV="test"
CONTAINER_NAME="openvpn-${ENV}"
#UNAME="user111"
FILE_NAME="compose-openvpn-${ENV}.yml"
COMPOSE_DIR="/opt/docker-compose/openvpn/${ENV}/${FILE_NAME}"
DEFAULE_PWD="Bab@Ee"
LIST_USER=$(ls -l user | awk '{print $9}' |sed '/^$/d' | awk -F"." '{print $1}')

printf "\n請選擇執行項目\n1. 建立使用者\n2. 刪除使用者\n3. 退出\n\n"
read -p "請輸入 (1-2-3): " choice

case $choice in
    1)
        read -p "請輸入用戶名: " UNAME
        echo "${DEFAULE_PWD}" | docker-compose -f ${COMPOSE_DIR} run --rm ${CONTAINER_NAME} easyrsa build-client-full ${UNAME} nopass
        docker-compose -f ${COMPOSE_DIR} run --rm ${CONTAINER_NAME} ovpn_getclient ${UNAME} > ./user/${UNAME}.ovpn
        ;;
    2)
        printf "\n${LIST_USER}\n"
        read -p "請輸入要刪除的用戶名: " CLIENTNAME
        expect -c "
            spawn docker-compose -f ${COMPOSE_DIR} run --rm ${CONTAINER_NAME} ovpn_revokeclient $CLIENTNAME remove
            expect \"Continue with revocation:\"
            send \"yes\n\"
            expect \"Enter pass phrase for /etc/openvpn/pki/private/ca.key:\"
            send \"${DEFAULE_PWD}\n\"
            expect \"Enter pass phrase for /etc/openvpn/pki/private/ca.key:\"
            send \"${DEFAULE_PWD}\n\"
            interact
        "
        if [ $? -eq 0 ];then
          printf "Delete ${CLIENTNAME}\n"
          rm -rf ./user/${CLIENTNAME}.ovpn
        else
          printf "\n刪除使用者失敗!\n"
        fi
        ;;
    3)
        printf "\n退出\n" 
        exit 1
        ;;
    *)
        echo "請輸入有效的選項(1或2)"
        ;;
esac

