#! /bin/bash

sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus

curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest | grep browser_download_url | grep linux-amd64 |  cut -d '"' -f 4 | wget -qi -
tar xvf node_exporter-*linux-amd64.tar.gz
cd node_exporter*/
sudo mv node_exporter /usr/local/bin/

# Create collectors file
sudo tee /etc/systemd/system/node_exporter.service<<EOF
[Unit]
Description=Prometheus_Node_Exporter
Documentation=https://github.com/prometheus/node_exporter
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP \$MAINPID
ExecStart=/usr/local/bin/node_exporter \
  --collector.cpu \
  --collector.diskstats \
  --collector.filesystem \
  --collector.loadavg \
  --collector.meminfo \
  --collector.filefd \
  --collector.netdev \
  --collector.stat \
  --collector.netstat \
  --collector.systemd \
  --collector.uname \
  --collector.vmstat \
  --collector.time \
  --collector.mdadm \
  --collector.zfs \
  --collector.tcpstat \
  --collector.bonding \
  --collector.hwmon \
  --collector.arp \
  --web.listen-address=:9100 \
  --web.telemetry-path="/metrics"

SyslogIdentifier=node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Start the service and enable on boot
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

#TODO
# Configure Firewall
# sudo ufw allow 9100

