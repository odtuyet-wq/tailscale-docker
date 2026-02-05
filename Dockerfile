# Sử dụng image không chính thức của PocketBase từ adrianmusante
FROM adrianmusante/pocketbase:latest

# Chuyển sang quyền root để cài đặt Tailscale
USER root

# Cài đặt các dependencies cần thiết
RUN apt-get update && apt-get install -y curl iproute2

# Cài đặt Tailscale (không cần sử dụng rc-update)
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Tạo thư mục lưu trữ dữ liệu PocketBase
RUN mkdir /pb_data

# Lệnh khởi động Tailscale và PocketBase
CMD /bin/bash -c "\
    tailscaled && \
    tailscale up --authkey=$TAILSCALE_CLIENT_SECRET --hostname=pocketbase && \
    ip a show dev tailscale0 && \
    /pocketbase/pocketbase serve --http=0.0.0.0:8090"
