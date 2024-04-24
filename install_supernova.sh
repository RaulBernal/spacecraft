#!/bin/bash

folder_to_check="$HOME/supernova"

if [ -d "$folder_to_check" ]; then
    printf '\U2757'
    echo "W A R N I N G ! ! ! the folder $folder_to_check is going to be erased. STOP the Supernova scripts before continue."
    echo
    # Pide confirmación al usuario
    printf '\U1F984 Please be careful you can lose important data if not a dev environment\n\n'
    read -p "If you want to continue press ENTER, if not CTRL+C now:" confirmacion
    printf '\U1F984 Deleting... \n'
    rm -rf  $HOME/supernova
fi

cd ~
git clone https://github.com/gnolang/supernova.git
cd supernova
make build
cp build/supernova $GOBIN
cat <<'EOF' >$HOME/supernova/supernova_simulation_light.sh
#!/bin/bash

while true; do
        supernova -sub-accounts 5 -transactions 2 -url http://localhost:26657 -mnemonic "source bonus chronic canvas draft south burst lottery vacant surface solve popular case indicate oppose farm nothing bullet exhibit title speed wink action roast" -output REALM_DEPLOYMENT_result.json  -mode REALM_DEPLOYMENT
        sleep 1
        supernova -sub-accounts 4 -transactions 2 -url http://localhost:26657 -mnemonic "walnut secret absent call depend clown bunker cram drift catch congress afraid enforce awesome talent guitar leaf clump buffalo adult modify shoe chief fork" -output PACKAGE_DEPLOYMENT_result.json  -mode PACKAGE_DEPLOYMENT
        sleep 1
        supernova -sub-accounts 6 -transactions 2 -url http://localhost:26657 -mnemonic "walnut secret absent call depend clown bunker cram drift catch congress afraid enforce awesome talent guitar leaf clump buffalo adult modify shoe chief fork" -output REALM_CALL_result.json  -mode REALM_CALL
        sleep 1
done
EOF
chmod +x $HOME/supernova/supernova_simulation_light.sh
echo "You can run the Supernova_Simulation in a  SCREEN session: $ screen -S Supernova  (Press CTRL + A + D to leave it running)"
echo
echo "$ cd supernova"
echo "Run the Simulation:"
echo "$ ./supernova_simulation_light.sh"
echo
echo "To recover a running screen session type in terminal: $ screen -r name_session (screen -r   to list all)"
