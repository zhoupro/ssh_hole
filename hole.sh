#!/bin/bash

function monitor_service(){
    domain=$1
    if [[ $domain_name == '' ]];then
        echo 'domain is empty'
        return 0
    fi

    status_code=`curl -I -m 15 -o /dev/null -s -w %{http_code} $domain`
    if (($status_code == 200 )); then
        return 0
    else
        return 1
    fi

}


function ssh_con(){
   # analyse the service conn
   loc_nu=$(ps -ef | grep -v grep | grep "$(echo $1)" | wc -l)

   ssh_str="ssh -CfNgqP -R $1"
   remote_str=$(echo $1 | awk '{print $2}')
   ssh_port=$(echo $1 | awk '{print $1}'| awk -F ":" '{print $3}')

   # local conn has one, and service is response
   if [ $loc_nu -eq 1 ]; then
     echo "$ssh_port local conn is ok"
     monitor_service  $2
     if [ $? -gt 0 ]  ;then
        echo "$ssh_port  is not servicing"
        echo "$ssh_port  remote and local is killed"
        ps -ef | grep -v grep| grep "$(echo $1)" | awk '{print $2}' | xargs kill -9
        ssh $remote_str "netstat -anp | grep 0.0.0.0:$ssh_port | awk '{print \$7}' | awk -F "/" '{print \$1}'| xargs kill -9 "
     else
        echo "$ssh_port remote service is ok"
     fi
     return
   fi



   if [ $loc_nu -gt 1 ] ;then
     #reset local conn
     echo "$ssh_port local is reset"
     ps -ef | grep -v grep| grep "$(echo $1)" | awk '{print $2}' | xargs kill -9
   fi

   echo "$ssh_port is connecting"
   $ssh_str
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


