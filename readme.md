# Drifting through the Cosmos - Getting Core Systems online again
![image](https://github.com/RaulBernal/spacecraft/assets/3751926/1376f1b9-299b-4f73-a1c7-e7eb29652574)


# Gnoyager 1 might have a chance

## Run with Docker. You have two options:
1. Pull the Docker-Compose file with downloadable images from Docker Hub
 - Clone this repository or [download the Docker-Compose file](https://raw.githubusercontent.com/RaulBernal/spacecraft/main/docker-compose.yml)
 - Execute `docker-compose up -d`
 - After one minute (grafana needs time) go to http://localhost:3000 (admin:admin)

2. Git the source code of each server and **build images locally** before run Docker-Compose:
   
    **2.1. Gno (genesis modified & listen address 0.0.0.0 tm2/pkg/bft/rpc/config/config.go)**
    ```
    git clone https://github.com/RaulBernal/gno.git
    cd gno
    docker build -t gnoland:bind0 . 
    ```
    **2.2. TX-Indexder**
    ```
    cd ..
    git clone https://github.com/RaulBernal/tx-indexer.git
    cd tx-indexer
    docker build -t tx-indexer:latest .
    ```
    **2.3. Supernova**
    ```
    cd ..
    git clone https://github.com/RaulBernal/supernova.git
    cd supernova
    docker build -t supernova:script .
    ```
    **2.4. Enginetwo parser**
    ```
    git clone https://github.com/RaulBernal/enginetwo.git
    cd enginetwo
    docker build -t enginetwo:grafana .
    ```
    **2.5. Grafana**
    ```
    cd ..
    git clone https://github.com/RaulBernal/spacecraft.git
    cd spacecraft
    docker build -t grafana:gno .
    ```
    **2.6. Run with composer**
    If you still are at spacecraft folder:
    ```
    docker-compose -f docker-compose_images.yml up -d
    ```

## Run installing the services in host (instructions for linux/amd64)

Please follow this instructions to get everything restored again, what we will do is the following:
1. Install and run a Gno.Land node (configure keys, accounts, systemd file service, etc)
2. Install and run TX-Indexer as improved RPC/WS data endpoint (GraphQL)
3. Download Supernova and automate some flying TXs
4. Download and automate EngineTwo Parser, a middleware between TX-Indexer and Grafana, which parse blocks into a simple SQLite3 database.
5. Compose a Grafana (docker image) with predefined connection to SQLite3 file & new working Dashboard

## Instructions
> These instructions were tested in two different hosts running Ubuntu Linux v22 amd64

Prerequisites (with direct install, no docker) are:
- Linux amd64 (Ubuntu v22 recommended)
- To have a root or sudoer account
- GoLang v1.22
  - Get script: `wget https://raw.githubusercontent.com/RaulBernal/spacecraft/main/install_go.sh`
  - Run it: `chmod +x install_go.sh && ./install_go.sh`
- Docker & Docker Compose
  - Get script: `wget https://raw.githubusercontent.com/RaulBernal/spacecraft/main/install_docker.sh`
  - Run it: `chmod +x install_docker.sh && ./install_docker.sh`

### 1. Install the Gno.Land node.
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

### 2. Download and install the TX-Indexer
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

### 3. Download Supernova and automate some flying TXs
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

### 4. Download and automate EngineTwo Parser
1. Download automated script
```
wget https://raw.githubusercontent.com/RaulBernal/spacecraft/main/install_enginetwo.sh
```

2. Run it
```
chmod +x install_enginetwo.sh && ./install_enginetwo.sh
```

#### Important notes to start the Parser
- This is the **alpha** version of EngineTwo!!!.
- You can run the parser in a  SCREEN session: `screen -S Parser`  (Press CTRL + A + D to leave it running)
```
cd enginetwo
sudo -u grafanauser /usr/local/go/bin/go run main.go
```
- If you stop it and you want to resume, edit main.go, and replace the starting block in the main() functions
```
sudo -u grafanauser nano main.go"
```
If the last message was: `Reached last known block height 5764, waiting for new blocks to be generated...` you need to put here `go verifyAndInsertBlocks(db, 5765)` and rerun with `sudo -u grafanauser /usr/local/go/bin/go run main.go`
- If you want delete the database and start from the scratch: `sudo -u grafanauser rm data.sqlite3 && sudo -u grafanauser /usr/local/go/bin/go run main.go`

### 5. Grafana - Connection to SQLite3 db - Dashboard
1. Download automated script
```
wget https://raw.githubusercontent.com/RaulBernal/spacecraft/main/install_grafana.sh
```

2. Run it
```
chmod +x install_grafana.sh && ./install_grafana.sh
```

#### Notes
- Check if is running with: `docker ps`
- Check LOGs with: `docker logs grafana`
- If you want to rebuild the Grafana docker: `cd $HOME/grafana && docker-compose down && docker-compose up -d`
- If you get this error: `ERROR: Volume grafana_data declared as external, but could not be found.` you can try to solve with: `docker volume create --name=grafana_data`
  
## Image 1
![telegram-cloud-photo-size-4-5857134381905329881-y](https://github.com/RaulBernal/spacecraft/assets/3751926/d9cf61a7-69ad-49d9-a9a2-1f8d6c969efd)

## Image 2
![telegram-cloud-photo-size-4-5857134381905329853-y](https://github.com/RaulBernal/spacecraft/assets/3751926/88939ff9-1eca-411b-9afb-8500f8d766d2)
