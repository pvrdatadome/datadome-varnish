FROM debian:9.13-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -y install varnish libvarnishapi-dev varnish-modules

# Install Requirements
RUN apt-get update \
 && apt-get install --no-install-recommends --no-install-suggests -y \
        # Packages required only for compilation
        make automake autoconf-archive autotools-dev libedit-dev \
        libjemalloc-dev libncurses5-dev libpcre3-dev \
        libtool pkg-config python3-docutils python3-sphinx graphviz \
        ca-certificates wget \
        # Packages required at runtime
        gcc init-system-helpers libbsd0 libc6 libc6-dev libedit2 libjemalloc1 libncurses5 \
        libpcre3 libtinfo5

# Install DataDome module
COPY ./varnish-module.sh /
RUN chmod +x /varnish-module.sh
RUN /varnish-module.sh

# Copy default configuration
COPY ./default.vcl /etc/varnish/

# Copy `datadome.vcl` to your VCL folder 
COPY datadome.vcl /etc/varnish/datadome.vcl

EXPOSE 6081

ADD ./start.sh /start.sh
RUN chmod +x /start.sh

CMD /start.sh
