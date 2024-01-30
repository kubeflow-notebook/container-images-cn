# Use a Jupyter notebook image from Kubeflow as the base image
ARG BASE_IMAGE=ghcr.io/kubeflow-notebook/jupyter-pytorch-cuda-full

# Specify the version of Kubeflow
ARG KUBEFLOW_VERSION=v1.8.0

# Build a new image from the specified base image and version
FROM ${BASE_IMAGE}:${KUBEFLOW_VERSION}

# Switch to root user to perform system-level operations
USER root

# Used mirrors.aliyun.com to speed up the download of apt-get
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get update

# Switch back to the default Jupyter notebook user
USER $NB_USER

# Install the Chinese language pack
RUN pip install jupyterlab-language-pack-zh-CN
