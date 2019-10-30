#cloud-config
packages:
 - curl
runcmd:
# initialize ec2
# - sudo mkfs.xfs /dev/nvme1n1 
# - sudo mount /dev/nvme1n1 /opt
# - sudo echo "/dev/nvme1n1 /opt  xfs    defaults	0	0" >> /etc/fstab
# install JDK
 - sudo curl -o /opt/jdk-8u231-linux-x64.tar.gz https://public-devops-software-package.s3.amazonaws.com/jdk-8u231-linux-x64.tar.gz
 - sudo tar -zxvf /opt/jdk-8u231-linux-x64.tar.gz -C /opt
 - sudo echo "export JAVA_HOME=/opt/jdk1.8.0_231" >> /etc/profile
 - sudo echo "export JRE_HOME=\$JAVA_HOME/jre" >> /etc/profile
# install maven
 - sudo curl -o /opt/apache-maven-3.6.2-bin.tar.gz https://public-devops-software-package.s3.amazonaws.com/apache-maven-3.6.2-bin.tar.gz
 - sudo tar -zxvf apache-maven-3.6.2-bin.tar.gz -C /opt
 - sudo echo "export M2_HOME=/opt/apache-maven-3.6.2" >> /etc/profile
 - sudo echo "export M2=\$M2_HOME/bin" >> /etc/profile
 - sudo echo "export PATH=\$JAVA_HOME/bin:\$M2:$PATH" >> /etc/profile
# install Jenkins 
 - source /etc/profile
 - sudo mkdir /opt/jenkins
 - sudo curl -o /opt/jenkins/jenkins.war http://mirror.serverion.com/jenkins/war-stable/2.190.2/jenkins.war
 - nohub java -jar /opt/jenkins/jenkins.war &
