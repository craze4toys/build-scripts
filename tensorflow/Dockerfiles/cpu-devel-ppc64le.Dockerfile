# Copyright 2018 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============================================================================
#
# THIS IS A GENERATED DOCKERFILE.
#
# This file was assembled from multiple pieces, whose use is documented
# below. Please refer to the the TensorFlow dockerfiles documentation for
# more information. Build args are documented as their default value.
#
# Ubuntu-based, CPU-only environment for developing changes for TensorFlow, ppc64le architecture.
#
# Start from ppc64le/Ubuntu, with TF development packages (no GPU support)
# --build-arg UBUNTU_VERSION=16.04
#    ( no description )
#
# Python is required for TensorFlow and other libraries.
# --build-arg USE_PYTHON_3_NOT_2=True
#    Install python 3 over Python 2
#
# Build and install the latest version of Bazel and Python development tools.
#
# Configure TensorFlow's shell prompt and login tools.

ARG UBUNTU_VERSION=16.04
FROM ppc64le/ubuntu:${UBUNTU_VERSION}

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        libcurl3-dev \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        rsync \
        software-properties-common \
        unzip \
        zip \
        zlib1g-dev \
        openjdk-8-jdk \
        openjdk-8-jre-headless \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG USE_PYTHON_3_NOT_2=True
ARG _PY_SUFFIX=${USE_PYTHON_3_NOT_2:+3}
ARG PYTHON=python${_PY_SUFFIX}
ARG PIP=pip${_PY_SUFFIX}

RUN apt-get update && apt-get install -y \
    ${PYTHON} \
    ${PYTHON}-pip

RUN ${PIP} install --upgrade \
    pip \
    setuptools

RUN ${PIP} install six numpy wheel mock
RUN ${PIP} install keras_applications==1.0.5 --no-deps
RUN ${PIP} install keras_preprocessing==1.0.3 --no-deps

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    openjdk-8-jdk \
    ${PYTHON}-dev \
    python \
    swig
 # Build and install bazel
ENV BAZEL_VERSION 0.15.0
WORKDIR /
RUN mkdir /bazel && \
    cd /bazel && \
    curl -fSsL -O https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-dist.zip && \
    unzip bazel-$BAZEL_VERSION-dist.zip && \
    bash ./compile.sh && \
    cp output/bazel /usr/local/bin/ && \
    rm -rf /bazel && \
    cd -

COPY bashrc /etc/bash.bashrc
RUN chmod a+rwx /etc/bash.bashrc
