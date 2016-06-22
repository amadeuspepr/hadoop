FROM ubuntu:14.04
MAINTAINER Pierre-Etienne Melet
USER root

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
    wget  \
    default-jdk \
    openssh-server \
    rsync \
    nmap

RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

WORKDIR /opt/

RUN wget http://apache.crihan.fr/dist/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz && tar xfvz hadoop-2.7.2.tar.gz
#ADD hadoop-2.7.2.tar.gz .
RUN mv hadoop-2.7.2 hadoop

WORKDIR /opt/hadoop

RUN readlink -f /usr/bin/javac | xargs dirname | xargs dirname | awk '{print "export JAVA_HOME="$1}' > etc/hadoop/hadoop-env.sh
COPY core-site.xml etc/hadoop/core-site.xml
COPY hdfs-site.xml etc/hadoop/hdfs-site.xml
COPY mapred-site.xml etc/hadoop/mapred-site.xml
COPY yarn-site.xml etc/hadoop/yarn-site.xml

RUN bin/hdfs namenode -format

WORKDIR /root/
COPY start-yarn.sh start-yarn.sh
RUN chown root:root /root/start-yarn.sh
RUN chmod 700 /root/start-yarn.sh

EXPOSE 8088 50070 50075 50090

CMD ["/root/start-yarn.sh", "-d"]
