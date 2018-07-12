FROM centos:latest

## software versions
ARG HADOOP_VERSION=3.1.0
ARG JAVA_VERSION=1.8.0

## env vars
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV JAVA_HOME /usr/lib/jvm/java-${JAVA_VERSION}-openjdk
ENV HADOOP_HOME /opt/hadoop

USER root

RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    yum -y install epel-release && \
    yum -y install deltarpm && \
    yum -y update && \
    yum -y install wget \
    which \
    sudo \
    net-tools \
    openssh-server openssh-clients \
    perl-Digest-SHA && \
    yum clean all

# SSH Key Passwordless
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys && \
    /usr/bin/ssh-keygen -A
RUN sed -i '/StrictHostKeyChecking/s/#//g' /etc/ssh/ssh_config && \
    sed -i '/StrictHostKeyChecking/s/ask/no/g' /etc/ssh/ssh_config && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

#EXPOSE 22

## Version 01
#COPY ./entrypoint/entrypoint.sh /
#ENTRYPOINT ["/entrypoint.sh"]

## Version 02, sshd is executed on startup
#RUN echo "/usr/sbin/sshd" >> ~/.bashrc

## Version 03, works, but launches shell
#CMD /usr/sbin/sshd && \
#    /bin/bash

## Version 04
#CMD ["/usr/sbin/sshd", "-D"]

## Version 05, cant get it to work!
#COPY ./etc /etc
#ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf", "-n"]





## updates Yum etc
#RUN yum -y update && \
#    yum -y install deltarpm
## which python (?)
#RUN yum -y install wget which
## sha, very funny
#RUN yum -y install perl-Digest-SHA
## openssl stuff
#RUN yum -y install openssh-server openssh-clients
## Java
## No idea how to set env post, must specify beforehand
#RUN yum -y install java-${JAVA_VERSION}-openjdk-devel
## cleanup
#RUN yum clean all

## move downloaded Hadoop to container
#COPY hadoop-${HADOOP_VERSION}.tar.gz /

#RUN tar -zxvf hadoop-${HADOOP_VERSION}.tar.gz && \
#    mv hadoop-${HADOOP_VERSION} $HADOOP_HOME && \
#    rm -f hadoop-${HADOOP_VERSION}.tar.gz

## dl and check sha of dl Hadoop
#RUN wget https://dist.apache.org/repos/dist/release/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz.mds && \
#    cat hadoop-${HADOOP_VERSION}.tar.gz.mds && \
#    shasum -a 512 hadoop-${HADOOP_VERSION}.tar.gz

#RUN echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
## This is strange, why set users ?
#    echo "export HDFS_DATANODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
#    echo "export HDFS_DATANODE_SECURE_USER=hdfs" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
#    echo "export HDFS_NAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
#    echo "export HDFS_SECONDARYNAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
#    echo "export YARN_RESOURCEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh && \
#    echo "export YARN_NODEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh && \
#    echo "PATH=$PATH:$HADOOP_HOME/bin" >> ~/.bashrc
