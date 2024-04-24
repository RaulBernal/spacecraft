#!/bin/bash

sudo chown -R 472:472  $HOME/enginetwo
sudo chmod -R 775 $HOME/enginetwo
mkdir -p $HOME/grafana/dashboards && cd $HOME/grafana
wget -P $HOME/grafana/dashboards https://raw.githubusercontent.com/RaulBernal/spacecraft/main/grafana/grafana_blocks_txs.json

cat  <<EOF >$HOME/grafana/dashboards/dashboard_providers.yaml
apiVersion: 1

providers:
  - name: 'default'
    orgId: 1
    folder: ''  # default maped folder for dashboards
    type: file
    disableDeletion: false
    editable: true
    options:
      #path: /etc/grafana/provisioning/dashboards
      path: /var/lib/grafana/dashboards
EOF
cat <<EOF >$HOME/grafana/datasource.yaml
apiVersion: 1

datasources:
  - name: SQLite
    type: frser-sqlite-datasource
    access: proxy
    orgId: 1
    url: /home/grafana/data.sqlite3
    uid: "fdjmu6y220nb4c"
    editable: true
    jsonData:
      path: /home/grafana/data.sqlite3
EOF
cat <<EOF >$HOME/grafana/docker-compose.yml
version: '3.8'

services:
  grafana:
    container_name: grafana
    environment:
      GF_INSTALL_PLUGINS: "frser-sqlite-datasource"
    networks:
      - backend
    image: grafana/grafana:latest
    volumes:
      - type: bind
        source: /home/ddex/enginetwo/data.sqlite3 # the real host place
        target: /home/grafana/data.sqlite3 # inside grafana, needs to be absolute
      - $HOME/grafana/datasource.yaml:/etc/grafana/provisioning/datasources/datasource.yaml
      - $HOME/grafana/dashboards:/var/lib/grafana/dashboards
      #- $HOME/grafana/dashboards:/etc/grafana/provisioning/dashboards
      - $HOME/grafana/dashboards/dashboard_providers.yaml:/etc/grafana/provisioning/dashboards/dashboard_providers.yaml

    ports:
      - 3000:3000

networks:
  backend: {}

volumes:
  grafana_data:
    external: true
EOF
sleep 3
sudo ufw allow 3000
echo
echo Check if is running with: docker ps
echo Check LOGs with: docker logs grafana
echo If you want to restart the Grafana docker:
echo cd $HOME/grafana && docker-compose down && docker-compose up -d
sleep 3
docker-compose up -d
