# ssh_hole

```bash
mkdir -p /data/
cd /data/
git clone git://github.com/zhouzheng12/ssh_hole.git sh
chmod 777 -R sh

```
modify your host_port.sh to meet your need


remote_port:localhost:local_port user_name@remote_ip
eg:

16080:localhost:16080 root@192.168.0.111


make a crontab 
```bash
* * * * * /data/sh/hole.sh
```


make a nginx proxy

[ssh_hole](http://www.daobuzhi.com/index.php/2017/05/31/ssh%E6%89%93%E6%B4%9E%E5%8F%8D%E5%90%91%E4%BB%A3%E7%90%86%E5%8A%A0nginx%E5%8F%8D%E5%90%91%E4%BB%A3%E7%90%86%E5%AE%9E%E7%8E%B0%E8%AE%BF%E9%97%AE%E5%86%85%E7%BD%91%E6%9C%8D%E5%8A%A1/) for detail!

