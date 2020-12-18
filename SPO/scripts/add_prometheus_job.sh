#! /bin/bash
# $1 = job_name
# $2 = private_ip

cat << EOF >> /etc/prometheus/prometheus.yml
# Linux Servers
  - job_name: $1
    static_configs:
      - targets: ['$2:9100']
        labels:
          alias: $1
EOF

sudo systemctl restart prometheus
