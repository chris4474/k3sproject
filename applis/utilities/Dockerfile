FROM ubuntu
CMD [ "/usr/bin/bash", "-c", "while true ; do sleep 1 ; done" ]
RUN apt update && apt install -y \
    curl \
    gupnp-tools \
    iproute2 \
    iputils-ping \
    miniupnpc \
    nmap \
    net-tools \
    && rm -rf /var/lib/apt/lists/*
