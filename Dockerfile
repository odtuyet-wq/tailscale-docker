# Sử dụng image không chính thức của PocketBase từ adrianmusante
FROM adrianmusante/pocketbase:latest

# Cài đặt Tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Cài PocketBase
RUN mkdir /pb_data

# Cài công cụ để lấy IP và log
RUN apt-get update && apt-get install -y iproute2

# Lệnh khởi động container với PocketBase và Tailscale
CMD /bin/bash -c "\
    tailscaled && \
    tailscale up --authkey=$TAILSCALE_CLIENT_SECRET --hostname=pocketbase && \
    ip a show dev tailscale0 && \
    /pocketbase/pocketbase serve --http=0.0.0.0:8090"
