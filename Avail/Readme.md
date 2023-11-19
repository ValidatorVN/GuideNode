# Auto Install

    wget -O avail https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Avail/avail && chmod +x avail && ./avail

# Manual Install

1/ Update

    sudo apt update && apt upgrade -y
    sudo apt install make clang pkg-config libssl-dev build-essential -y

2/ Dowload the binary

    sudo mkdir -p $HOME/avail-node && cd $HOME/avail-node
    sudo wget https://github.com/availproject/avail/releases/download/v1.8.0.2/amd64-ubuntu-2204-data-avail.tar.gz
    sudo tar xvzf amd64-ubuntu-2204-data-avail.tar.gz
    sudo mv amd64-ubuntu-2204-data-avail data-avail

3/ Set name node && create systemD

    yourname=<NodeName>

systemD

    sudo tee /etc/systemd/system/availd.service > /dev/null << EOF
    [Unit]
    Description=Avail Validator
    After=network.target
    StartLimitIntervalSec=0
    [Service]
    User=$USER
    Type=simple
    Restart=always
    RestartSec=120
    ExecStart=${HOME}/avail-node/data-avail \
     -d ${HOME}/avail-node/data \
     --chain goldberg --port 30333 \
     --validator \
     --name $yourname
    
    [Install]
    WantedBy=multi-user.target
    EOF

# Command

SystemD

    sudo systemctl daemon-reload
    sudo systemctl enable availd
    sudo systemctl start availd


Check logs:

    sudo journalctl -u availd -f -o cat

Check node:

    https://telemetry.avail.tools/

Create wallet:

    https://goldberg.avail.tools/

Get key for active Validator:

    curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "author_rotateKeys", "params":[]}' http://localhost:9944
