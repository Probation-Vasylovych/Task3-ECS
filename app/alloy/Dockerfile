FROM grafana/alloy:latest

USER root

RUN apt-get update && apt-get install -y \
    curl \
    iputils-ping \
    dnsutils \
    netcat-openbsd \
 && rm -rf /var/lib/apt/lists/*

COPY config.alloy /etc/alloy/config.alloy

CMD ["run","--stability.level=experimental", "/etc/alloy/config.alloy"]