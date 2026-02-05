# Sử dụng image Ubuntu làm base
FROM ubuntu:20.04

# Chuyển sang quyền root để cài đặt Tailscale
USER root

# Cài đặt các dependencies cần thiết
ARG PB_VERSION=0.36.2
RUN apt-get update && apt-get install -y \
    curl \
    iproute2 \
    sudo \
    bash \
    wget \
    unzip \
    iptables

# Tải PocketBase và kiểm tra tệp tải về
RUN wget https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip -O /tmp/pb.zip && \
    ls -alh /tmp && \
    unzip /tmp/pb.zip -d /pb/ && \
    mv /pb/pocketbase /usr/local/bin/ && \
    rm /tmp/pb.zip

# Cài đặt Tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Tạo thư mục dữ liệu PocketBase
RUN mkdir /pb_data

# Khởi động Tailscale và PocketBase
CMD /bin/bash -c "\
    tailscaled && \
    tailscale up --authkey=$TAILSCALE_CLIENT_SECRET --hostname=pocketbase && \
    ip a show dev tailscale0 && \
    /usr/local/bin/pocketbase serve --http=0.0.0.0:8080"
