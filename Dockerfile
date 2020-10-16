FROM python:3.7

WORKDIR /opt/zillow

RUN apt-get update && apt-get install -yq --no-install-recommends \
        apt-transport-https \
        apt-utils \
        bash \
        build-essential \
        ca-certificates \
        curl \
        dialog \
        git \
        isomd5sum \
        libffi-dev \
        libmpdec-dev \
        libssl-dev \
        sudo \
        vim \
        wget \
        zip \
        zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip & install poetry
RUN pip install -U pip==20.0.2 poetry==1.0.10
ENV POETRY_VIRTUALENVS_CREATE=False

COPY . /metaflow

RUN pip install 'git+https://github.com/alexlatchford/pipelines@alexla/AIP-1676#egg=kfp&subdirectory=sdk/python'
RUN pip install awscli click requests boto3 pytest pytest-xdist
RUN pip install -e /metaflow

RUN export KFP_RUN_URL_PREFIX=https://kubeflow.corp.dev.zg-aip.net/ && export KFP_SDK_NAMESPACE=aip-example && export METAFLOW_DATASTORE_SYSROOT_S3=s3://aip-example-dev/metaflow && export METAFLOW_DEFAULT_DATASTORE=local && export METAFLOW_USER=hariharans@zillowgroup.com && cd /metaflow/metaflow/plugins/kfp/tests && python -m pytest -s -n 2 run_integration_tests.py

# Create Z_USER with UID=1000 and in the 'users' group
ARG Z_USER="zservice"
ARG Z_UID="1000"
ARG Z_GID="100"

# Configure environment
ENV SHELL=/bin/bash \
    Z_USER=$Z_USER \
    Z_UID=$Z_UID \
    Z_GID=$Z_GID \
    HOME=/home/$Z_USER

# Enable users to install packages as root
RUN echo "%users ALL=(ALL) NOPASSWD:/usr/local/bin/pip" >> /etc/sudoers && \
    echo "%users ALL=(ALL) NOPASSWD:/usr/local/bin/pip3" >> /etc/sudoers && \
    echo "%users ALL=(ALL) NOPASSWD:/usr/local/bin/python" >> /etc/sudoers && \
    echo "%users ALL=(ALL) NOPASSWD:/usr/bin/apt-get" >> /etc/sudoers && \
    echo "%users ALL=(ALL) NOPASSWD:/usr/bin/apt" >> /etc/sudoers