FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    tzdata sudo vim less curl jq git ca-certificates apt-transport-https gnupg \
    wget software-properties-common apt-utils xz-utils build-essential

RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3 python3-dev python3-virtualenv python3-opencv

RUN useradd -u 2001 -ms /bin/bash -d /home/ubuntu -G sudo ubuntu
RUN echo "ubuntu:123" | chpasswd

USER ubuntu
WORKDIR /home/ubuntu

ENV VIRTUAL_ENV=/home/ubuntu/venv
RUN python3.6 -m virtualenv --python=/usr/bin/python3.6 $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV CUDA_HOME="/usr/local/cuda/"

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY --chown=ubuntu:ubuntu . .

ENTRYPOINT ["python", "run_fastdvdnet.py"]
