#!/bin/bash

function monitor_service(){
    domain=$1
    if [[ $domain_name == '' ]];then
        echo 'domain is empty'
        return 0
    fi


    status_code=`curl -I -m 10 -o /dev/null -s -w %{http_code} $domain`
    if (($status_code == 200 )); then
        return 0
    else
        return 1
    fi

}



function ssh_con(){
   loc_nu=$(echo $1 | grep "localhost"|wc -l)
   if [ $loc_nu -eq 0 ]; then
     return
   fi

   ssh_str="ssh -CfNgqP -R $1"
   remote_str=$(echo $1 | awk '{print $2}')
   local_str=$(echo $1 | awk '{print $1}')

   ssh_port=$(echo $1 | awk '{print $1}'| awk -F ":" '{print $3}')
   echo $local_str
   SSH_NUM=$(ps -ef |grep -v grep | grep $local_str |wc -l)
   echo $SSH_NUM

   if [ $SSH_NUM -gt 0 ] ;then
        #restart remote service
       monitor_service  $2
       if [ $? -gt 0 ] || [ $SSH_NUM -gt 1 ] ;then
         echo 'reset service'
         ps -ef | grep -v grep|grep "$local_str" | awk '{print $2}' | xargs kill -9
         ssh $remote_str "ps -ef |grep -v grep | grep -v pts| grep 'sshd: root'| awk '{print \$2 }'| xargs kill -9 "
       else
         echo "service $ssh_port is ok"
       fi

   else
       echo "$ssh_port is reconnecting"
       $ssh_str

   fi
}





cat ./host_port.sh | while read host_port;
do
    ssh_port=$(echo $host_port | awk '{printf("%s\t%s\n", $1, $2)}')
    domain_name=$(echo $host_port | awk '{print $3}')
    if [[ $domain_name != '' ]];then
        ssh_con "$ssh_port" $domain_name
    else
        ssh_con "$ssh_port"
    fi

done


