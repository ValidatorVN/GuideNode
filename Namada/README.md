## Namada Manual Setup  

Install update and libs

    cd $HOME
    sudo apt update && sudo apt upgrade -y
    sudo apt install curl tar wget clang pkg-config git make libssl-dev libclang-dev libclang-12-dev -y
    sudo apt install jq build-essential bsdmainutils ncdu gcc git-core chrony liblz4-tool -y
    sudo apt install original-awk uidmap dbus-user-session protobuf-compiler unzip -y


    cd $HOME
      sudo apt update
      sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
      . $HOME/.cargo/env
      curl https://deb.nodesource.com/setup_18.x | sudo bash
      sudo apt install cargo nodejs -y < "/dev/null"
  
    cargo --version
    node -v

Install Go
  
    if ! [ -x "$(command -v go)" ]; then
      ver="1.20.5"
      cd $HOME
      wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
      sudo rm -rf /usr/local/go
      sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
      rm "go$ver.linux-amd64.tar.gz"
      echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
      source ~/.bash_profile
    fi
    go version

Install rust

    cd $HOME && rustup update
    PROTOC_ZIP=protoc-23.3-linux-x86_64.zip
    curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v23.3/$PROTOC_ZIP
    sudo unzip -o $PROTOC_ZIP -d /usr/local bin/protoc
    sudo unzip -o $PROTOC_ZIP -d /usr/local 'include/*'
    rm -f $PROTOC_ZIP
    protoc --version

#CHECK your vars in /.bash_profile and change if they not correctly

    sed -i '/public-testnet/d' "$HOME/.bash_profile"
    sed -i '/NAMADA_TAG/d' "$HOME/.bash_profile"
    sed -i '/WALLET_ADDRESS/d' "$HOME/.bash_profile"
    sed -i '/CBFT/d' "$HOME/.bash_profile"

#Setting up vars

    echo "export NAMADA_TAG=v0.30.0" >> ~/.bash_profile
    echo "export CBFT=v0.37.2" >> ~/.bash_profile
    echo "export NAMADA_CHAIN_ID=wait for announce" >> ~/.bash_profile
    echo "export WALLET=wallet" >> ~/.bash_profile
    echo "export BASE_DIR=$HOME/.local/share/namada" >> ~/.bash_profile

#***CHANGE parameters !!!!!!!!!!!!!!!!!!!!!!!!!!!!***

    echo "export VALIDATOR_ALIAS=YOUR_MONIKER" >> ~/.bash_profile

    source ~/.bash_profile

Install node Namada

    cd $HOME && git clone https://github.com/anoma/namada && cd namada && git checkout $NAMADA_TAG
    make build-release
    cargo fix --lib -p namada_apps

Install CBFT

    cd $HOME && git clone https://github.com/cometbft/cometbft.git && cd cometbft && git checkout $CBFT
    make build

Copy file

    cd $HOME && cp $HOME/cometbft/build/cometbft /usr/local/bin/cometbft && \
    cp "$HOME/namada/target/release/namada" /usr/local/bin/namada && \
    cp "$HOME/namada/target/release/namadac" /usr/local/bin/namadac && \
    cp "$HOME/namada/target/release/namadan" /usr/local/bin/namadan && \
    cp "$HOME/namada/target/release/namadaw" /usr/local/bin/namadaw && \
    cp "$HOME/namada/target/release/namadar" /usr/local/bin/namadar
    cometbft version
    namada --version

#Make service

    sudo tee /etc/systemd/system/namadad.service > /dev/null <<EOF
    [Unit]
    Description=namada
    After=network-online.target
    [Service]
    User=$USER
    WorkingDirectory=$HOME/.local/share/namada
    Environment=TM_LOG_LEVEL=p2p:none,pex:error
    Environment=NAMADA_CMT_STDOUT=true
    ExecStart=/usr/local/bin/namada node ledger run 
    StandardOutput=syslog
    StandardError=syslog
    Restart=always
    RestartSec=10
    LimitNOFILE=65535
    [Install]
    WantedBy=multi-user.target
    EOF

    sudo systemctl daemon-reload
    sudo systemctl enable namadad

#ONLY for PRE genesis validator

Import mnemonic (wallet gen from namada extension make sence balances.toml file)

    ALIAS="wallet"
    namadaw --pre-genesis derive --alias $ALIAS
    enter
    enter
    import mnemonic
    enter    

Cat your address check again:

    cat $BASE_DIR/pre-genesis/wallet.toml

Generate an established account

    TX_FILE_PATH="$BASE_DIR/pre-genesis/transactions.toml"
    namadac utils init-genesis-established-account --path $TX_FILE_PATH --aliases $ALIAS

Generate a pre-genesis validator account

    EMAIL="<your-email>"
    DISCORD_HANDLE="<your-discord-handle>" # This is optional
    AVATAR_URL="<your-avatar-url>" # This is optional, and expects a URL to an image the size of 128x128 pixels
    WEBSITE="<your-website>" # This is optional
    DESCRIPTION="<your-description>" # This is optional
    SELF_BOND_AMOUNT=1000000 # Set this to the amount of NAM you want to self-bond. This must be less than or equal to the amount of NAM allocated to the pre-genesis keys in the `balances.toml` that was published by the network coordinator.
    VALIDATOR_ALIAS="<your-validator-alias>"
    IP_ADDRESS="<your-public-IP-address>"
    namadac utils init-genesis-validator \
      --address $ESTABLISHED_ACCOUNT_ADDRESS \
      --alias $VALIDATOR_ALIAS \
      --net-address "$IP_ADDRESS:26656" \
      --commission-rate 0.05 \
      --max-commission-rate-change 0.01 \
      --self-bond-amount $SELF_BOND_AMOUNT \
      --email $EMAIL \
      --discord-handle $DISCORD_HANDLE \
      --avatar $AVATAR_URL \
      --website $WEBSITE \
      --description $DESCRIPTION \
      --path $TX_FILE_PATH

Signing transactions

    namadac utils sign-genesis-txs \
        --path $TX_FILE_PATH \
        --output $BASE_DIR/pre-genesis/signed-transactions.toml \
        --alias $VALIDATOR_ALIAS

Upload your PR https://github.com/anoma/namada-shielded-expedition

#IF YOU NOT A PRE GEN VALIDATOR SKIP THIS SECTION

    namada client utils join-network --chain-id $NAMADA_CHAIN_ID --genesis-validator $VALIDATOR_ALIAS
    sudo systemctl restart namadad && sudo journalctl -u namadad -f -o cat

#End for PRE genesis validator ----------------------------------------------------------------------


## INSTALL GRAFANA MONITORING


```bash
cd $HOME && wget -q -O grafana.sh https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Namada/grafana.sh && chmod +x grafana.sh && ./grafana.sh


#Grafana is accessible at: http://localhost:9346
#Login credentials:
#---------Username: admin
#---------Password: admin
#**********************************
# Open grafana and add to Home/Connections/Your_connections/Data_sources
# ...new source prometheus with address http://localhost:9344
# ...click SAVE and TEST button
#**********************************
# ...then import to Home/Dashboards/Import_dashboard new dashboard
# ...Import via grafana.com     ID = 19014
# Change Validator_ID           for example (D2FE325E52DBC76342A8ACA803767290707FC2CA)
# Change NAMADA_Chain_ID               for example (public-testnet-********)
```

## DELETE NODE!!!

```bash
cd $HOME && mkdir $HOME/namada_backup
cp -r $HOME/.local/share/namada/pre-genesis $HOME/namada_backup/
systemctl stop namadad && systemctl disable namadad
rm /etc/systemd/system/namada* -rf
rm $(which namada) -rf
rm /usr/local/bin/namada* /usr/local/bin/cometbft -rf
rm $HOME/.namada* -rf
rm $HOME/.local/share/namada -rf
rm $HOME/namada -rf
rm $HOME/cometbft -rf

```
