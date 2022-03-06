##grafana-setup-centos8.sh
#src:https://grafana.com/docs/grafana/latest/installation/rpm/
#grafana installation
touch /etc/yum.repos.d/grafana.repo
#repo config
cat <<EOF | sudo tee /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF
yum update
#install service
yum install -y grafana
touch /etc/grafana/grafana.ini
cat <<EOF | sudo tee /etc/grafana/grafana.ini
# The HTTP port to use
http_port = 3000
EOF
systemctl daemon-reload && systemctl enable grafana-server && systemctl start grafana-server
#In orderto configure via GUI go to http://<node-ip>:<node-port>/login
#default credentials: admin:admin
#how to reset admin password
grafana-cli admin reset-admin-password <new-password>
#prepare for prometheus installation
#src:https://www.scaleway.com/en/docs/tutorials/prometheus-monitoring-grafana-dashboard/
useradd --no-create-home --shell /usr/sbin/nologin prometheus
useradd --no-create-home --shell /bin/false node_exporter
mkdir /etc/prometheus && mkdir /var/lib/prometheus
chown prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus
wget https://github.com/prometheus/node_exporter/releases/download/v0.16.0/node_exporter-0.16.0.linux-amd64.tar.gz
tar xvf node_exporter-0.16.0.linux-amd64.tar.gz
cp node_exporter-0.16.0.linux-amd64/node_exporter /usr/local/bin
chown node_exporter:node_exporter /usr/local/bin/node_exporter
rm -rf node_exporter-0.16.0.linux-amd64.tar.gz node_exporter-0.16.0.linux-amd64
cat <<EOF | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl start node_exporter
systemctl status node_exporter
systemctl enable node_exporter
#install prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.2.1/prometheus-2.2.1.linux-amd64.tar.gz
tar xfz prometheus-*.tar.gz
cd prometheus-*
cp ./prometheus /usr/local/bin/
cp ./promtool /usr/local/bin/
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool
cp -r ./consoles /etc/prometheus
cp -r ./console_libraries /etc/prometheus
chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries
cd .. && rm -rf prometheus-\*
#configure prometheous
nano /etc/prometheus/prometheus.yml
cat <<EOF | sudo tee /etc/prometheus/prometheus.yml
global:
  scrape_interval:     15s
  evaluation_interval: 15s

rule_files:
  # - "first.rules"
  # - "second.rules"

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']
EOF
chown prometheus:prometheus /etc/prometheus/prometheus.yml
#start prometheus
sudo -u prometheus /usr/local/bin/prometheus --config.file /etc/prometheus/prometheus.yml --storage.tsdb.path /var/lib/prometheus/ --web.console.templates=/etc/prometheus/consoles --web.console.libraries=/etc/prometheus/console_libraries
