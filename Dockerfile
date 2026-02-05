# Sử dụng image Ubuntu làm base
FROM ubuntu:20.04

# Cài đặt các dependencies cần thiết
RUN apt-get update && apt-get install -y \
    curl \
    iproute2 \
    sudo \
    bash \
    wget

# Cài đặt PocketBase (tải PocketBase bản mới nhất)
RUN wget https://github.com/pocketbase/pocketbase/releases/download/v0.8.0/pocketbase_0.8.0_linux_amd64.tar.gz && \
    tar -xvf pocketbase_0.8.0_linux_amd64.tar.gz && \
    mv pocketbase /usr/local/bin/ && \
    rm pocketbase_0.8.0_linux_amd64.tar.gz

# Cài đặt Tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Tạo thư mục dữ liệu PocketBase
RUN mkdir /pb_data

# Khởi động Tailscale và PocketBase
CMD /bin/bash -c "\
    tailscaled && \
    tailscale up --authkey=$TAILSCALE_CLIENT_SECRET --hostname=pocketbase && \
    ip a show dev tailscale0 && \
    pocketbase serve --http=0.0.0.0:8090"
