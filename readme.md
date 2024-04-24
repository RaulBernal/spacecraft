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
- GoLang v1.22
  - Get script: `wget https://raw.githubusercontent.com/RaulBernal/spacecraft/main/install_go.sh`
  - Run it: `chmod +x install_go.sh && ./install_go.sh`
- Docker & Docker Compose
  - Get script: `wget https://raw.githubusercontent.com/RaulBernal/spacecraft/main/install_docker.sh`
  - Run it: `chmod +x install_docker.sh && ./install_docker.sh`

### Install the Gno.Land node.
1. Download automated script
```
wget https://raw.githubusercontent.com/RaulBernal/spacecraft/main/install_gnoland.sh
```

2. Run it
```
chmod +x install_gnoland.sh && ./install_gnoland.sh
```

#### Notes
- After execute the script the daemon will be running and persistent with systemd.
- You can start the node with: `sudo systemctl start gnoland.service && sudo journalctl -fu gnoland -o cat`
- You can stop  the node with: `sudo systemctl stop gnoland.service`
- If you want to reset the Gnoland' state to block 0 run: `./reset_gnoland.sh` (stop the daemon first please)

### Download and install the TX-Indexer
1. Download automated script
```
wget https://raw.githubusercontent.com/RaulBernal/spacecraft/main/install_tx-indexer.sh
```

2. Run it
```
chmod +x install_tx-indexer.sh && ./install_tx-indexer.sh
```

#### Notes
- After execute the script the daemon will be running and persistent with systemd.
- You can start the node with: `sudo systemctl start tx-indexer.service && sudo journalctl -fu tx-indexer -o cat`
- You can stop  the node with: `sudo systemctl stop tx-indexer.service`
- If you want to reset the TX-Indexer' state to block 0 run: `./reset_tx-indexer.sh` (stop the daemon first please)

### Download Supernova and automate some flying TXs
1. Download automated script
```
wget https://raw.githubusercontent.com/RaulBernal/spacecraft/main/install_supernova.sh
```

2. Run it
```
chmod +x install_supernova.sh && ./install_supernova.sh
```

#### Notes
- You can run the Supernova_Simulation in a  SCREEN session: `screen -S Supernova`
```
cd supernova
./supernova_simulation_light.sh
```
- Press CTRL + A + D [to leave it running](https://linuxize.com/post/how-to-use-linux-screen/)
- To recover a running screen session type in terminal: `screen -r name_session` (`screen -r`   to list all)"


