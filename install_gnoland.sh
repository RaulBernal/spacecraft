#!/bin/bash

folder_to_check="$HOME/.config/gno"

if [ -d "$folder_to_check" ]; then
    printf '\U2757'
    echo "W A R N I N G ! ! ! the folder $folder_to_check is going to be erased. STOP the Gno.Land Daemon before continue."
    echo
    # Pide confirmación al usuario
    printf '\U1F984 Please be careful you can lose your private keys if not a dev environment\n\n'
    read -p "If you want to continue press ENTER, if not CTRL+C now:" confirmacion
    printf '\U1F984 Deleting... \n'
    rm -rf gno/ 
    rm -rf .config/gno  
fi
# suport for leveldb
sudo apt-get install libleveldb-dev -y
git clone https://github.com/gnolang/gno.git
cd gno
make install
echo "gno development toolkit installed"
sleep 2
cd gno.land
make install
echo "GNO.land & utils installed"
sleep 2
cd ~
echo -e "test\ntest\n"  | gnokey add validator -insecure-password-stdin=true   2>&1 | tee seeds_words.txt
export ADDR=$(gnokey list | grep -o 'addr: [^ ]*' | cut -d' ' -f2)
echo Validator address is $ADDR
sleep 2
# config the chain
cd ~/gno/gno.land
make fclean
# add the genesis info
echo "$ADDR=10000000000ugnot # Raul test" >> genesis/genesis_balances.txt
echo "g1u9pw74nyzjk8h5v4sjr848xmla8czyc75l08uu=9000000000000ugnot # Spammer" >> genesis/genesis_balances.txt
echo "g1jg8mtutu9khhfwc4nxmuhcpftf0pajdhfvsqf5=9000000000000ugnot # Supernova demo account"
# create a service, enable it at the OS and start it!
cat <<EOF >gnoland.service
[Unit]
Description=GnoLand Node
After=network-online.target
[Service]
User=${USER}
ExecStart=$(which gnoland) start -gnoroot-dir ${HOME}/gno -genesis-balances-file ${HOME}/gno/gno.land/genesis/genesis_balances.txt -genesis-txs-file ${HOME}/gno/gno.land/genesis/genesis_txs.jsonl -root-dir ${HOME}/gno/gno.land/testdir
Restart=always
RestartSec=3
LimitNOFILE=4096
[Install]
WantedBy=multi-user.target
EOF

sudo mv gnoland.service /lib/systemd/system/
sudo systemctl daemon-reload #ensure a refresh if exist previously
sudo systemctl enable gnoland.service && sudo systemctl start gnoland.service
cd ~
cat <<EOF >reset_gnoland.sh
#!/bin/bash

sudo systemctl stop gnoland.service
cd ~/gno/gno.land && make fclean
echo "$ADDR=10000000000ugnot # Raul test" >> genesis/genesis_balances.txt
echo "g1jg8mtutu9khhfwc4nxmuhcpftf0pajdhfvsqf5=9000000000000ugnot # Supernova"  >> genesis/genesis_balances.txt
echo "g1u9pw74nyzjk8h5v4sjr848xmla8czyc75l08uu=9000000000000ugnot # Spammer" >> genesis/genesis_balances.txt
sudo systemctl start gnoland.service && sudo journalctl -fu gnoland -o cat
EOF

chmod +x reset_gnoland.sh
ls -lh reset_gnoland.sh

# check it is working 
echo "Press CTRL+C to stop the logs"
sleep 3
sudo journalctl -fu gnoland -o cat
# instructions to stop & start
echo "You can start the node with: sudo systemctl start gnoland.service && sudo journalctl -fu gnoland -o cat"
echo "You can stop  the node with: sudo systemctl stop gnoland.service"
echo .
echo "If you want to reset the Gnoland to block 0 run: reset_gnoland.sh"
