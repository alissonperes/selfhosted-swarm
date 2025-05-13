# pull base image
FROM alpine:3.21

ARG ANSIBLE_CORE_VERSION=2.18.5
ARG ANSIBLE_VERSION=11.5.0
ARG ANSIBLE_LINT=25.4.0
ENV ANSIBLE_CORE_VERSION ${ANSIBLE_CORE_VERSION}
ENV ANSIBLE_VERSION ${ANSIBLE_VERSION}
ENV ANSIBLE_LINT ${ANSIBLE_LINT}

RUN apk --no-cache add \
        sudo \
        python3 \
        py3-pip \
        openssl \
        ca-certificates \
        sshpass \
        openssh-client \
        rsync \
        git \
        docker-cli && \
    apk --no-cache add --virtual build-dependencies \
        python3-dev \
        libffi-dev \
        musl-dev \
        gcc \
        cargo \
        build-base && \
    find /usr/lib/python* -name "EXTERNALLY-MANAGED" -exec rm {} \; 

RUN pip3 install --upgrade pip wheel && \
    pip3 install --upgrade cryptography cffi pywinrm && \
    pip3 install docker jsondiff && \
    pip3 install ansible-core==${ANSIBLE_CORE_VERSION} ansible==${ANSIBLE_VERSION} ansible-lint==${ANSIBLE_LINT} && \
    pip3 install mitogen jmespath

RUN apk del build-dependencies && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/pip && \
    rm -rf /root/.cargo

RUN mkdir /ansible && \
    mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

WORKDIR /ansible

ENTRYPOINT ["ansible-playbook"]
