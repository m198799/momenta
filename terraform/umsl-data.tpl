#cloud-config
packages:
 - curl
runcmd:
# install JDK
 - sudo curl -o /opt/jdk-8u231-linux-x64.tar.gz https://public-devops-software-package.s3.amazonaws.com/jdk-8u231-linux-x64.tar.gz
 - sudo tar -zxvf /opt/jdk-8u231-linux-x64.tar.gz -C /opt
 - sudo echo "export JAVA_HOME=/opt/jdk1.8.0_231" >> /etc/profile
 - sudo echo "export JRE_HOME=\$JAVA_HOME/jre" >> /etc/profile
 - sudo echo "export PATH=\$JAVA_HOME/bin:$PATH" >> /etc/profile