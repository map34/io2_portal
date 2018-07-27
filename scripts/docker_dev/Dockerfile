FROM ubuntu:18.04


ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV HOME /root
ENV PATH $HOME/miniconda/bin:$PATH

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    software-properties-common

# -- Install Python dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yqq --no-install-recommends \
    build-essential \
    python3.7 \
    python3.7-dev \
    python3-pip \
    git \
    wget \
    python3-opencv \
  && apt-get -q clean

# -- Install Application into container:
RUN set -ex && mkdir -p /usr/src/app/scripts

WORKDIR /usr/src/app

# -- Adding environment files
COPY scripts/environment.yml scripts/environment.yml
COPY scripts/docker_dev/scripts/setup-server.sh scripts/docker_dev/scripts/setup-server.sh

# -- Install dependencies:
RUN scripts/docker_dev/scripts/setup-server.sh