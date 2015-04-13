# A pseudo Dockerfile for Hortonworks container

FROM registry.access.redhat.com/rhel6.5:latest

RUN subscription-manager register --force --username=gmillard1@redhat.com --password=3Airplanesz!
RUN subscription-manager attach --pool=8a85f9874011071c01407da00b3f7c5e
RUN subscription-manager repos --enable=rhel-6-server-extras-rpms
RUN subscription-manager repos --enable=rhel-6-server-optional-rpms
RUN subscription-manager repos --enable=rhel-6-server-aus-thirdparty-oracle-java-rpms
RUN yum -y install java-1.7.0-oracle-devel.x86_64

RUN yum -y install vim

RUN yum -y install wget

#needed for

RUN wget -nv http://public-repo-1.hortonworks.com/HDP/centos6/2.x/GA/2.2.0.0/hdp.repo -O /etc/yum.repos.d/hdp.repo

RUN yum -y install ntp
RUN service ntpd start
RUN chkconfig --level 2345 ntpd on
RUN yum -y install iptables

ADD HortonIPTables.txt /home/

ADD directories.sh /home/

CMD /bin/touch /home/.bashrc

CMD /bin/cat /home/directories.sh >> /home/.bashrc 

#Replace first line in /etc/hosts file with
#<IP_ADDR>	hortontainer

#run container in priv mode - <docker --iptables=true run -it --privileged=true rhel65_hortonworks2apr1001 bash> 

RUN groupadd hadoop 
RUN groupadd mapred 
RUN groupadd nagios 
RUN useradd -g hadoop hadoop
RUN useradd -g hadoop yarn
RUN useradd -g hadoop mapred
RUN usermod -G mapred mapred
RUN useradd -g hadoop hive
RUN useradd -g hadoop hcat
RUN useradd -g hadoop hbase
RUN useradd -g hadoop falcon
RUN useradd -g hadoop sqoop
RUN useradd -g hadoop zookeeper
RUN useradd -g hadoop oozie
RUN useradd -g hadoop knox
RUN useradd -g nagios nagios


RUN /home/directories.sh

EXPOSE 53
EXPOSE 123
