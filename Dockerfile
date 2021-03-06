FROM registry.access.redhat.com/ubi7
LABEL maintainer="Anthony Green <anthony@atgreen.org>"

# Install EPEL
RUN rpm -ivh https://download-ib01.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

RUN yum install jq -y && yum clean all

RUN useradd -d /opt/minio -g root minio

WORKDIR /opt/minio

ADD entrypoint.sh .

RUN curl -o minio https://dl.minio.io/server/minio/release/linux-amd64/minio && \
    chmod +x minio && \
    mkdir config && \
    mkdir data  && \
    chown minio:root -R . && chmod 777 -R .

USER minio

VOLUME /opt/minio/config
VOLUME /opt/minio/data

EXPOSE 9000

ENTRYPOINT [ "./entrypoint.sh" ]
