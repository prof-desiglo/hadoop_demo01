FROM openjdk:8-jdk

ENV HADOOP_VERSION=3.3.6
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

ENV JAVA_HOME=/usr/local/openjdk-8
ENV PATH=$JAVA_HOME/bin:$PATH

# Instalar utilitários
RUN apt-get update && apt-get install -y openssh-server rsync curl vim net-tools && \
    mkdir -p /var/run/sshd

# Baixar e instalar Hadoop
RUN curl -O https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    tar -xvzf hadoop-$HADOOP_VERSION.tar.gz && \
    mv hadoop-$HADOOP_VERSION $HADOOP_HOME && \
    rm hadoop-$HADOOP_VERSION.tar.gz

# Configuração de SSH
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

# Copiar configs customizadas
COPY config/* $HADOOP_CONF_DIR/

WORKDIR /opt/hadoop

COPY yarn/core-site.xml ./etc/hadoop/core-site.xml
COPY yarn/mapred-site.xml ./etc/hadoop/mapred-site.xml
COPY yarn/yarn-site.xml ./etc/hadoop/yarn-site.xml


RUN sed -i 's|^# export JAVA_HOME=.*|export JAVA_HOME=/usr/local/openjdk-8|' $HADOOP_HOME/etc/hadoop/hadoop-env.sh

RUN hdfs namenode -format

# Start padrão
COPY start-hadoop.sh ./start-hadoop.sh
RUN chmod +x ./start-hadoop.sh
RUN sed -i 's/\r$//' start-hadoop.sh
CMD ["./start-hadoop.sh"]
