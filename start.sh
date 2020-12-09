#!/bin/bash

set -e

exec bash -c \
  "exec varnishd -F \
  -a 0.0.0.0:6081 \
  -f /etc/varnish/default.vcl \
  -s malloc,128M \
  -p default_ttl=3600 -p default_grace=3600 -T 0.0.0.0:6082 -S /etc/varnish/secret"
