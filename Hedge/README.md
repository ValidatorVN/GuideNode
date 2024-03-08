# Public Endpoints:

    RPC: https://hedge-rpc.validatorvn.com/
    API: https://hedge-api.validatorvn.com/
    Peer: bc64e8794465dd46399bf6f49a564098e09b0843@164.92.96.212:26656
    
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
    set -eux; \
      wget -O /lib/libwasmvm.x86_64.so https://github.com/CosmWasm/wasmvm/releases/download/v1.3.0/libwasmvm.x86_64.so

Config Node:

    hedged config chain-id berberis-1
    hedged config keyring-backend test
    hedged init "Moniker" --chain-id berberis-1

    sudo wget -O $HOME/.hedge/config/genesis.json "https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Hedge/genesis.json"
    sudo wget -O $HOME/.hedge/config/addrbook.json "https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Hedge/addrbook.json"

    sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025uhedge\"/;" ~/.hedge/config/app.toml
    peers=""
    sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.hedge/config/config.toml
    seeds="7879005ab63c009743f4d8d220abd05b64cfee3d@54.92.167.150:26656"
    sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.hedge/config/config.toml
    sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.hedge/config/config.toml
    sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.hedge/config/config.toml

Pruning and indexer

    pruning="custom" && \
    pruning_keep_recent="100" && \
    pruning_keep_every="0" && \
    pruning_interval="10" && \
    sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.hedge/config/app.toml && \
    sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.hedge/config/app.toml && \
    sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.hedge/config/app.toml && \
    sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.hedge/config/app.toml

Create Service:

    sudo tee /etc/systemd/system/hedged.service > /dev/null <<EOF
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

Statesync:

    sudo systemctl stop hedged
    hedged tendermint unsafe-reset-all --home ~/.hedge/ --keep-addr-book
    SNAP_RPC="https://hedge-rpc.validatorvn.com:443"
    
    LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
    BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
    TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
    echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

    sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
    s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
    s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
    s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.hedge/config/config.toml
    more ~/.hedge/config/config.toml | grep 'rpc_servers'
    more ~/.hedge/config/config.toml | grep 'trust_height'
    more ~/.hedge/config/config.toml | grep 'trust_hash'

    sudo systemctl restart hedged && journalctl -u blockxd -f -o cat

# Command

Add New Key

    hedged keys add wallet

Recover Existing Key

    hedged keys add wallet --recover

List All Keys

    hedged keys list

Delete Key

    hedged keys delete wallet

Export Key (save to wallet.backup)

    hedged keys export wallet

Import Key

    hedged keys import wallet wallet.backup

Query Wallet Balance

    hedged q bank balances $(aurad keys show wallet -a) 

Check Balance:

    hedged q bank balances $(hedged keys show wallet -a)

Create a Validator:

    hedged tx staking create-validator --amount=1000000uhedge --pubkey=$(hedged tendermint show-validator) --moniker="Moniker" --chain-id=berberis-1 --commission-rate=0.10 --commission-max-rate=0.20 --commission-max-change-rate=0.1 --min-self-delegation=1 --from=wallet --gas-prices=0.025uhedge --gas-adjustment=1.5 --gas=auto -y

Withdraw rewards:

    hedged tx distribution withdraw-rewards $(hedged keys show wallet --bech val -a) --commission --from wallet --chain-id berberis-1 --gas-prices=0.025uhedge --gas-adjustment=1.5 --gas=auto -y

Delegate to your self:

    hedged tx staking delegate $(hedged keys show wallet --bech val -a) 1000000uhedge --from wallet --chain-id berberis-1 --gas-prices=0.025uhedge --gas-adjustment=1.5 --gas=auto -y

Unjail:

    hedged tx slashing unjail --from wallet --chain-id=berberis-1 --gas-prices=0.025uhedge --gas-adjustment=1.5 --gas=auto -y 
    
Get Validator Info

    hedged status 2>&1 | jq -r '.ValidatorInfo // .validator_info'

Get Denom Info

    hedged q bank denom-metadata -oj | jq

Get Sync Status

    hedged status 2>&1 | jq -r '.SyncInfo.catching_up // .sync_info.catching_up'

Get Latest Height

    hedged status 2>&1 | jq -r '.SyncInfo.latest_block_height // .sync_info.latest_block_height'

Get Peer

    echo $(hedged tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.hedge/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')

Reset Node

    hedged tendermint unsafe-reset-all --home $HOME/.hedge --keep-addr-book

Remove Node

    sudo systemctl stop hedged && sudo systemctl disable hedged && sudo rm /etc/systemd/system/hedged.service && sudo systemctl daemon-reload && rm -rf $HOME/.hedge && rm -rf hedge && sudo rm -rf $(which hedged) 
