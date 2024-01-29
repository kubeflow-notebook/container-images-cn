ARG BASE_IMAGE=kubeflownotebookswg/jupyter-pytorch-cuda-full
ARG KUBEFLOW_VERSION=v1.8.0

FROM ${BASE_IMAGE}:${KUBEFLOW_VERSION}

USER root

# 安装系统依赖
RUN apt-get update && \
    apt-get install -y \
      openssh-client \
      openssh-server \
      git-lfs

# 安装 Git LFS
RUN git lfs install

# 允许 root 用户远程登录
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# 禁用密码认证
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

RUN mkdir -p /var/run/sshd && \
    mkdir -p /root/.ssh && \
    touch /root/.ssh/authorized_keys && \
    chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys

CMD ["/usr/sbin/sshd", "-D"]
