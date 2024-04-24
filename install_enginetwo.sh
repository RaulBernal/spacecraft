#!/bin/bash

cd $HOME
git clone https://github.com/RaulBernal/enginetwo.git && cd enginetwo
# This is to link the SQLite file with Grafana volume
sudo chown -R 472:472  $HOME/enginetwo
sudo chmod -R 775 $HOME/enginetwo
sudo groupadd -g 472 grafanagroup
sudo useradd -u 472 -g 472 -m grafanauser
# End Grafana-permissions setup
echo
echo
echo "You can run the parser in a  SCREEN session: $ screen -S Parser  (Press CTRL + A + D to leave it running)"
echo
echo "$ cd enginetwo"
echo "Run the Parser:"
echo "$ sudo -u grafanauser /usr/local/go/bin/go run main.go"
echo
echo "Stop: press CTR + C"
echo
echo "If you stop it and you want to resume, edit main.go, and replace the starting block in the main() functions"
echo "$ sudo -u grafanauser nano main.go"
echo
echo "If you want delete the database and start from the scratch: sudo -u grafanauser rm data.sqlite3"
