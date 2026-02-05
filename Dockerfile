# Sử dụng image không chính thức của PocketBase từ adrianmusante
FROM adrianmusante/pocketbase:latest

# Cài đặt quyền root cho lệnh cài đặt Tailscale
USER root

# Cài đặt Tailscale mà không cần sử dụng rc-update
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Cài PocketBase (nếu chưa có sẵn)
RUN mkdir /pb_data

# Cài công cụ để lấy IP và log
RUN apt-get update && apt-get install -y iproute2

# Khởi động Tailscale và PocketBase
CMD /bin/bash -c "\
    tailscaled && \
    tailscale up --authkey=$TAILSCALE_CLIENT_SECRET --hostname=pocketbase && \
    ip a show dev tailscale0 && \
    /pocketbase/pocketbase serve --http=0.0.0.0:8090"
