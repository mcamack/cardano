#! /bin/bash

cat << EOF >> /etc/prometheus/prometheus.yml
# Linux Servers
  - job_name: region1_relay
    static_configs:
      - targets: ['10.0.1.10:9100']
        labels:
          alias: region1_relay
EOF

sudo systemctl restart prometheus
