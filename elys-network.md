---
description: >-
  NextGen oracle-based decentralized perpetual trading and lending platform
  featuring native #USDC.  Premier UX, low fees, scalable. Powered by #Cosmos
  SDK ⚛️
---

# 🧊 Elys Network

website: [https://elys.network/](https://elys.network/)\
x: [https://twitter.com/elys\_network](https://twitter.com/elys\_network)\
discord: [https://discord.com/invite/elysnetwork](https://discord.com/invite/elysnetwork)\
linktr.ee: [https://linktr.ee/elysnetwork](https://linktr.ee/elysnetwork)\


## Public Endpoints:

```
RPC: https://elys-rpc.validatorvn.com
API: https://elys-api.validatorvn.com
gRPC: elys-grpc.validatorvn.com
```

## **Building from source**

```
sudo apt update
sudo apt install -y curl git jq lz4 build-essential
```

## **Install go**

```
sudo rm -rf /usr/local/go
curl -L https://go.dev/dl/go1.21.5.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile
source .bash_profile
```

## **Clone project repository**

```
git clone https://github.com/elys-network/elys elys
cd elys
git checkout v0.29.30-p2
make install
```

## **Node configuration**

```
elysd init Validator --chain-id=elystestnet-1

wget -O $HOME/.elys/config/genesis.json "https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/ElysNetwork/genesis.json"
wget -O $HOME/.elys/config/addrbook.json "https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/ElysNetwork/addrbook.json"

sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0018ibc/2180E84E20F5679FCC760D8C165B60F42065DEF7F46A72B447CFF1B7DC6C0A65,0.00025ibc/E2D2F6ADCC68AA3384B2F5DFACCA437923D137C14E86FB8A10207CF3BED0C8D4,0.00025uelys\"/;" ~/.elys/config/app.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.elys/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.elys/config/config.toml
```

## **Set prunning**

```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.elys/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.elys/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.elys/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.elys/config/app.toml
```

## **Create a service**

```
sudo tee /etc/systemd/system/elysd.service > /dev/null <<EOF
[Unit]
Description=aura node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which elysd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable elysd

SNAP_NAME=$(curl -s https://ss-t.elys.nodestake.top/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
curl -o - -L https://ss-t.elys.nodestake.top/${SNAP_NAME}  | lz4 -c -d - | tar -x -C $HOME/.elys
```

## **Start the service & check logs**

```
sudo systemctl restart elysd && journalctl -u elysd -f -o cat | grep heigh t
```

## State Sync

```
sudo systemctl stop elysd
elysd tendermint unsafe-reset-all --home ~/.hedge/ --keep-addr-book
SNAP_RPC="https://elys-rpc.validatorvn.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.elys/config/config.toml
more ~/.elys/config/config.toml | grep 'rpc_servers'
more ~/.elys/config/config.toml | grep 'trust_height'
more ~/.elys/config/config.toml | grep 'trust_hash'

sudo systemctl restart elysd && journalctl -u elysd -f -o cat
```

