
FROM  grafana/grafana:latest

COPY ./grafana/datasource.yml /etc/grafana/provisioning/datasources/datasource.yaml
COPY ./grafana/dashboard_providers.yml /etc/grafana/provisioning/dashboards/dashboard_providers.yaml
COPY ./grafana/grafana_blocks_txs.json /etc/grafana/provisioning/dashboards/grafana_blocks_txs.json
