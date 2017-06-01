#!/bin/bash

#caution space is import, please use only one space


function ssh_con(){
   
   loc_nu=$(echo $1 | grep "localhost"|wc -l)
   if [ $loc_nu -eq 0 ]; then
     return 1
   fi
    
   ssh_str="ssh -CfNgqP -R "$1
   ssh_port=$(echo $ssh_str | awk '{print $4}'| awk -F ":" '{print $3}') 
   ssh_file="/tmp/time${ssh_port}.txt"


   SSH_NUM=$(ps -ef |grep -v grep| grep "$ssh_str" | wc -l)

   touch $ssh_file
   STM=`date +%s `
   OLD_STM=$(cat $ssh_file)
   [ "$OLD_STM" ] || OLD_STM=10
   STEP=$(( STM-OLD_STM ))

   # 10min and only one ssh connect
   if [ $SSH_NUM -eq 1 ] && [ $STEP -lt 600 ];then
       echo "$ssh_port is ok"
   else
       ps -ef | grep -v grep|grep "$ssh_str" | awk '{print $2}' | xargs kill -9
       echo "$ssh_port is reconnecting"
       $ssh_str
   fi
}


cat /data/sh/host_port.sh | while read host_port;
do
	ssh_con "$host_port"
done


