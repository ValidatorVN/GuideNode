# Manual Install

Update && Upgrade:

    sudo apt update && sudo apt upgrade -y

Install package:

    sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make lz4 unzip ncdu -y

Install GO:

    ver="1.21.5" 
    cd $HOME 
    wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" 

    sudo rm -rf /usr/local/go 
    sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" 
    rm "go$ver.linux-amd64.tar.gz"

    echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
    source $HOME/.bash_profile

Install Node:

    sudo wget -O hedged https://github.com/hedgeblock/testnets/releases/download/v0.1.0/hedged_linux_amd64_v0.1.0
    chmod +x hedged
    mkdir -p $HOME/go/bin
    sudo mv hedged /go/bin

Config Node:

    hedged config chain-id berberis-1
    hedged config keyring-backend test
    hedged init "Moniker" --chain-id berberis-1

Create Service:

    sudo tee /etc/systemd/system/artelad.service > /dev/null <<EOF
    [Unit]
    Description=Hedged Node
    After=network-online.target
    [Service]
    User=$USER
    ExecStart=$(which hedged) start
    Restart=always
    RestartSec=3
    LimitNOFILE=65535
    [Install]
    WantedBy=multi-user.target
    EOF
    sudo systemctl daemon-reload
    sudo systemctl enable hedged

Check Logs:

    sudo systemctl start hedged && journalctl -u hedged -f -o cat
