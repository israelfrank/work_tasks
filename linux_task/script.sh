#!/bin/sh
VERSION=9.0.44

#install tomcat server
sudo wget https://www-eu.apache.org/dist/tomcat/tomcat-9/v${VERSION}/bin/apache-tomcat-${VERSION}.tar.gz -P /tmp

sudo mkdir /home/usertest2/tomcat
sudo tar -xf /tmp/apache-tomcat-${VERSION}.tar.gz -C /home/usertest2/tomcat
sudo ln -s /home/usertest2/tomcat/apache-tomcat-${VERSION} /home/usertest2/tomcat/latest
sudo chown -R usertest2:work /home/usertest2/tomcat
sudo sh -c 'chmod +x /home/usertest2/tomcat/latest/bin/*.sh'

#sudo systemctl daemon-reload
#sudo systemctl start tomcat
#sudo ufw allow 8080/tcp

sudo cat <<EOF >/etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat 9 servlet container
After=network.target

[Service]
Type=forking
User=usertest2
Group=work

Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom -Djava.awt.headless=true"

Environment="CATALINA_BASE=/home/usertest2/tomcat/latest"

Environment="CATALINA_PID=/home/usertest2/tomcat/latest/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/home/usertest2/tomcat/latest/bin/startup.sh
ExecStop=/home/usertest2/tomcat/latest/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
EOF

 
sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo ufw allow 8080/tcp

#make 1 partitiion disk for the website 
(
echo n ;echo p; echo; echo; echo; echo w 
)| sudo fdisk /dev/sdd 


#format the disk
sudo mkfs -t ext4 /dev/sdd1

sudo mkdir /home/usertest2/tomcat/apache-tomcat-9.0.44/webapps/hello

#mount the file system to this folder
sudo mount /dev/sdd1 /home/usertest2/tomcat/apache-tomcat-9.0.44/webapps/hello

sudo cat << EOF > /home/usertest2/tomcat/apache-tomcat-9.0.44/webapps/hello/index.html
<html>
<header><title>hello</title></header>
<body>
Hello world
</body>
</html>
EOF

sudo systemctl restart tomcat

