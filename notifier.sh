#!/bin/bash

sendmessage(){
        for ID in $CHATIDS; do
                curl -s -X POST https://api.telegram.org/bot$BOTKEY/sendMessage -d chat_id=${ID} -d text="$1" -d parse_mode="Markdown"
        done
}

check ()
{
NAME=`echo $IP |awk -F ";" '{print $1}'`
IPN=`echo $IP | awk -F ";" '{print $2}'`
for (( ITERATION=1; ITERATION<=$ITERATIONS; ITERATION++ )); do
        INITIAL=`curl --insecure --connect-timeout 4 -s http://${IPN}:8888/status | jq -r ".last_added_block_info.height"`
        if [ -z $INITIAL ]; then
                sleep 20;
                continue;
        fi
        sleep 120;
        BLOCK=`curl --insecure --connect-timeout 4 -s http://${IPN}:8888/status | jq -r ".last_added_block_info.height"`
        if [ -z $BLOCK ]; then
                sleep 20;
                continue;
        else
                break
        fi
done
if [ -z $INITIAL ]; then
        sendmessage "☠️ Node $NAME http://$IPN/status is down."
else
        if [ -z $BLOCK ]; then
              sendmessage "☠️ Node $NAME http://$IPN/status is down."
        else
                if [ "$INITIAL" -eq "$BLOCK" ]; then
                       sendmessage "☠️ Node $NAME http://$IPN/status is stopped on block $BLOCK."
                fi
        fi
fi
}

CHATIDS=$(cat ${PWD}/config.ini | grep -v "#" | grep "CHATIDS" | awk -F "=" '{print $2}')
BOTKEY=$(cat ${PWD}/config.ini | grep -v "#" | grep "BOTKEY" | awk -F "=" '{print $2}')
STATE=0
ITERATIONS=3
while true; do
        NODEIP=$(cat ${PWD}/config.ini | grep -v "#" | grep "NODES" | awk -F "=" '{print $2}');
        for IP in $NODEIP
                do
                        check $IP
                done
        sleep 5;
done

