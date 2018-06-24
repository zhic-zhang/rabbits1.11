#!/bin/bash
#get IP
read -p "please input your IP:" host_ip

#download files
wget https://github.com/zhichengzhang2017/rabbits1.11/raw/ef4b80a83159c3a7444ebc116e404d43f1a682c1/rabbits1.0.zip
#unzip file
unzip rabbits1.0.zip

#set IP
sed -i "s/123.206.81.19/$host_ip/g" `grep 123.206.81.19 -rl rabbits1.0/templates/`
sed -i "s/123.206.81.19/$host_ip/g" rabbits1.0/flask_web.py

#install pip
python rabbits1.0/get-pip.py

#install virtualenv
pip install virtualenv

#install yum
yum -y install python-devel mariadb-server mariadb mysql-devel httpd
yum groupinstall 'Development Tools'
yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel mysql-community-devel


#install flask
pip install flask

#install psutil
pip install psutil

#install MySQLdb
pip install mysql-python

#configure mariadb
#if you meet "ERROR 1045 (28000)" please input "oracle" for passwd
systemctl start mariadb
mysql_secure_installation
mysql -uroot  -poracle <<EOF
        Create Database If Not Exists ops_info Character Set UTF8;
        Create Table If Not Exists ops_info.cpu(
                `cpu_used` int(11) DEFAULT NULL,
		`time` int(11) DEFAULT NULL
        )ENGINE=InnoDB DEFAULT CHARSET=latin1;
	Create Table If Not Exists ops_info.memory(
                `memory` int(11) DEFAULT NULL,
		`time` int(11) DEFAULT NULL
        )ENGINE=InnoDB DEFAULT CHARSET=latin1;
	EOF


#start running scripts
python monitor.py &
python flask_web.py