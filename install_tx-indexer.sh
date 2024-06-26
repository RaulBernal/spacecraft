#!/bin/bash
folder_to_check="$HOME/tx-indexer"

if [ -d "$folder_to_check" ]; then
    printf '\U2757'
    echo "W A R N I N G ! ! ! the folder $folder_to_check is going to be erased. STOP the TX-Indexer Daemon before continue."
    echo
    # Pide confirmación al usuario
    printf '\U1F984 Please be careful you can lose important data if not a dev environment\n\n'
    read -p "If you want to continue press ENTER, if not CTRL+C now:" confirmacion
    printf '\U1F984 Deleting... \n'
    rm -rf  $HOME/tx-indexer
fi

cd ~
git clone https://github.com/gnolang/tx-indexer.git
cd tx-indexer
make build
cp build/tx-indexer $GOBIN

cat <<EOF >tx-indexer.service
[Unit]
Description=TX-Indexer tool
After=network-online.target
[Service]
User=${USER}
ExecStart=$(which tx-indexer) start --db-path ${HOME}/tx-indexer/indexer-db
Restart=always
RestartSec=3
LimitNOFILE=4096
[Install]
WantedBy=multi-user.target
EOF
sudo ufw allow 8546
sudo mv tx-indexer.service /lib/systemd/system/
sudo systemctl daemon-reload #ensure a refresh if exist previously
sudo systemctl enable tx-indexer.service && sudo systemctl start tx-indexer.service
# check it is working 
echo "Press CTRL+C to stop the logs"
sleep 3
sudo journalctl -fu tx-indexer -o cat
# instructions to stop & start
echo "You can start the node with: sudo systemctl start tx-indexer.service && sudo journalctl -fu tx-indexer -o cat"
echo "You can stop  the node with: sudo systemctl stop tx-indexer.service"
echo .
echo "If you want to reset the Tx-Indexer Database run: reset_tx-indexer.sh"
echo 
echo as extra here is reset_tx-indexer.sh to clean the tx-indexer database
cat <<EOF >$HOME/reset_tx-indexer.sh
#!/bin/bash
sudo systemctl stop tx-indexer.service
rm -rf ${HOME}/tx-indexer/indexer-db
sudo systemctl start tx-indexer.service && sudo journalctl -fu tx-indexer -o cat
EOF

cd ~
chmod +x reset_tx-indexer.sh
ls -lh reset_tx-indexer.sh
