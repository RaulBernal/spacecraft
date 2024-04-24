# Drifting through the Cosmos - Getting Core Systems online again
![image](https://github.com/RaulBernal/spacecraft/assets/3751926/1376f1b9-299b-4f73-a1c7-e7eb29652574)


## Gnoyager 1 might have a chance

Please follow this instructions to get everything restored again, what we will do is the following:
1. Install and run a Gno.Land node (configure keys, accounts, systemd file service, etc)
2. Install and run TX-Indexer as improved RPC/WS data endpoint (GraphQL)
3. Download Supernova and automate some flying TXs
4. Download and automate EngineTwo Parser, a middleware between TX-Indexer and Grafana, which parse blocks into a simple SQLite3 database.
5. Compose a Grafana (docker image) with predefined connection to SQLite3 file & new working Dashboard

## Instructions
> These instructions are tested in two different hosts with Ubuntu Linux v22 amd64

Prerequisites are:
- Linux amd64 (Ubuntu 22 recommended)
- To have a root or sudoer account
- GoLang v1.22 (`wget `
  - Get script: `wget `
  - Run it: `chmod +x && ./install_golang.sh`
- Docker & Docker Compose

### Install the node.
1. Download automated script
```
wget https://raw.githubusercontent.com/RaulBernal/spacecraft/main/install_gnoland.sh
```
2. E 

