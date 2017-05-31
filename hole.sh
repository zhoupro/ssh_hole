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
   if [ $SSH_NUM -gt 1 ];then
        ps -ef | grep -v grep|grep "$ssh_str" | awk '{print $2}' | xargs kill -9  
   elif [ $SSH_NUM -eq 1 ];then
        touch $ssh_file
	STM=`date +%s `
	OLD_STM=$(cat $ssh_file)
        [ "$OLD_STM" ] || OLD_STM=10
        echo $OLD_STM
        STEP=$((STM-OLD_STM))
        echo $STEP
	if [[ $STEP -gt 600 ]];then
	   echo $STM > $ssh_file
	   echo 'time to kill'
	   ps -ef | grep -v grep|grep "$ssh_str" | awk '{print $2}' | xargs kill -9
	fi
	echo 'no problem'
   else
	echo "ssh_con"
   	$ssh_str 
   fi
}


cat host_port.sh | while read host_port;
do 
	ssh_con "$host_port"
done



