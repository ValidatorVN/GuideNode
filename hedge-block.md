---
description: >-
  Hedge is a pioneering blockchain network built with state-of-the-art M-sig
  transaction protocols to make your on-chain transactions faster and more
  reliable.
---

# 🧊 Hedge Block

website: [https://hedgeblock.io/](https://hedgeblock.io/)\
x: [https://twitter.com/hedgeblockio](https://twitter.com/hedgeblockio)\
discord: [https://discord.gg/63TDBe9cyg](https://discord.gg/63TDBe9cyg)

## Public Endpoints:

```
RPC: https://hedge-rpc.validatorvn.com/
API: https://hedge-api.validatorvn.com/
Peer: bc64e8794465dd46399bf6f49a564098e09b0843@164.92.96.212:26656
7879005ab63c009743f4d8d220abd05b64cfee3d@54.92.167.150:26656
70f7dc74d3b6afa12b988d61707229e8e191d9a2@213.246.45.16:55656
ba022b41835088f94d19bd2526b2d47a7126416f@158.220.120.113:26656
153f0d20405f7343b7b0c93cbed8c3957379416f@57.128.63.126:26656
ae6c41aa620f3c9f2e5cb486bca1935479a640c6@185.248.24.49:27656
aa4d1cfb12ee3d8f435b3322564ea54c3f1491ce@135.181.238.46:26856
b75d61ead2bdb1c8a1b0d6803b0ae6ed5c288ea2@37.27.35.64:26656
b5c74019bad9fdebe484e5cc735144e422669ae4@34.175.135.136:26656
6ca822c4d9fa868767e8a51e8a53d2ab13e8b633@115.76.119.79:26656
ab1a74673617158aea1ed5a1a1d5a30c6a9517bd@161.97.126.171:26656
0b7dbbbf7ae007daafe3c49c142fce5dcc9a1c55@94.72.125.122:26656
95ba8f6fec78dc3822b29700b3ec03ce6a16efc8@80.79.6.202:36656
21537089d52c3883ac5d7ec1cabaaa522b580be8@66.45.236.14:26656
e01e82e12beeb44b7ff3e98b1e62f9b976356e84@206.221.176.90:29656
bd7b10a3497c6e9254fee5ce6ace0b3a1c80ca12@116.111.217.237:35656
84868ec9449ca2a9942b3af1b2ff01bed071a45b@95.216.136.240:26656
0c154a9555f551a72c429e5b993f33d13556db0e@193.26.159.34:10656
42a3c66843b0961c6caf501e0819d693304c412f@164.68.121.28:26656
```

## Manual Install



Update && Upgrade:

```
sudo apt update && sudo apt upgrade -y
```

Install package:

```
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make lz4 unzip ncdu -y
```

## Install GO:

```
ver="1.21.5" 
cd $HOME 
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" 

sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" 
rm "go$ver.linux-amd64.tar.gz"

echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

Install Node:

## Dowload ibwasmvm.x86\_64.so

```
set -eux; \
  wget -O /lib/libwasmvm.x86_64.so https://github.com/CosmWasm/wasmvm/releases/download/v1.3.0/libwasmvm.x86_64.so
```

## Dowload Hedged:

```
mkdir -p $HOME/go/bin
sudo wget -O hedged https://github.com/hedgeblock/testnets/releases/download/v0.1.0/hedged_linux_amd64_v0.1.0
chmod +x hedged
sudo mv hedged /go/bin
```

## Config Node:

```
hedged config chain-id berberis-1
hedged config keyring-backend test
hedged init "Moniker" --chain-id berberis-1

sudo wget -O $HOME/.hedge/config/genesis.json "https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/Hedge/genesis.json"
sudo wget -O $HOME/.hedge/config/addrbook.json "https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/Hedge/addrbook.json"

sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025uhedge\"/;" ~/.hedge/config/app.toml
peers=""
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.hedge/config/config.toml
seeds="7879005ab63c009743f4d8d220abd05b64cfee3d@54.92.167.150:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.hedge/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.hedge/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.hedge/config/config.toml
```

## Pruning and indexer

```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.hedge/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.hedge/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.hedge/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.hedge/config/app.toml
```

## Create Service:

```
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
```

## Check Logs:

```
sudo systemctl start hedged && journalctl -u hedged -f -o cat
```

## Statesync:

```
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

sudo systemctl restart hedged && journalctl -u hedged -f -o cat
```

## Command



Add New Key

```
hedged keys add wallet
```

Recover Existing Key

```
hedged keys add wallet --recover
```

List All Keys

```
hedged keys list
```

Delete Key

```
hedged keys delete wallet
```

Export Key (save to wallet.backup)

```
hedged keys export wallet
```

Import Key

```
hedged keys import wallet wallet.backup
```

Query Wallet Balance

```
hedged q bank balances $(hedged keys show wallet -a) 
```

Check Balance:

```
hedged q bank balances $(hedged keys show wallet -a)
```

Create a Validator:

```
hedged tx staking create-validator --amount=1000000uhedge --pubkey=$(hedged tendermint show-validator) --moniker="Moniker" --chain-id=berberis-1 --commission-rate=0.10 --commission-max-rate=0.20 --commission-max-change-rate=0.1 --min-self-delegation=1 --from=wallet --gas-prices=0.025uhedge --gas-adjustment=1.5 --gas=auto -y
```

Withdraw rewards:

```
hedged tx distribution withdraw-rewards $(hedged keys show wallet --bech val -a) --commission --from wallet --chain-id berberis-1 --gas-prices=0.025uhedge --gas-adjustment=1.5 --gas=auto -y
```

Delegate to your self:

```
hedged tx staking delegate $(hedged keys show wallet --bech val -a) 1000000uhedge --from wallet --chain-id berberis-1 --gas-prices=0.025uhedge --gas-adjustment=1.5 --gas=auto -y
```

Unjail:

```
hedged tx slashing unjail --from wallet --chain-id=berberis-1 --gas-prices=0.025uhedge --gas-adjustment=1.5 --gas=auto -y 
```

Get Validator Info

```
hedged status 2>&1 | jq -r '.ValidatorInfo // .validator_info'
```

Get Denom Info

```
hedged q bank denom-metadata -oj | jq
```

Get Sync Status

```
hedged status 2>&1 | jq -r '.SyncInfo.catching_up // .sync_info.catching_up'
```

Get Latest Height

```
hedged status 2>&1 | jq -r '.SyncInfo.latest_block_height // .sync_info.latest_block_height'
```

Get Peer

```
echo $(hedged tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.hedge/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

Reset Node

```
hedged tendermint unsafe-reset-all --home $HOME/.hedge --keep-addr-book
```

Remove Node

```
sudo systemctl stop hedged && sudo systemctl disable hedged && sudo rm /etc/systemd/system/hedged.service && sudo systemctl daemon-reload && rm -rf $HOME/.hedge && rm -rf hedge && sudo rm -rf $(which hedged) 
```
