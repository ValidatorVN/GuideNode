---
description: >-
  Delve into our dynamic ecosystem of products within DeFi, NFTs, Identity,
  Collective Intelligence, Asset Tokenization, Smart Healthcare, and more.
---

# 🧊 Orai Chain

website: [https://orai.io/](https://orai.io/)\
x: [https://twitter.com/oraichain](https://twitter.com/oraichain)\
telegram: [https://t.me/oraichain\_official](https://t.me/oraichain\_official)\


Public Endpoints:\
RPC: https://orai-rpc.validatorvn.com\
API: https://orai-api.validatorvn.com\
gRPC: orai-grpc.validatorvn.com\
StateSync: Enable

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
cd $HOME
rm -rf orai
git clone https://github.com/oraichain/orai
cd orai/orai
git checkout v0.41.7-1s-block-time
make install
```

## **Node configuration**

```
oraid init ValidatorVN --chain-id Oraichain

wget -O $HOME/.oraid/config/genesis.json "https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/Oraichain/genesis.json"
wget -O $HOME/.oraid/config/addrbook.json "https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/Oraichain/addrbook.json"

sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0orai\"/;" ~/.oraid/config/app.toml
peers=""
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.oraid/config/config.toml
seeds="5f5cfac5c38506fbb4275c19e87c4107ec48808d@seeds.nodex.one:11210"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.oraid/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.oraid/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.oraid/config/config.toml
```

## **Set prunning**

```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.oraid/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.oraid/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.oraid/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.oraid/config/app.toml
```

## **Create a service**

```
sudo tee /etc/systemd/system/oraid.service > /dev/null <<EOF
[Unit]
Description=oraid node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which oraid) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable oraid

curl -L https://snap.nodex.one/orai/orai-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.oraid
```

## **Start the service & check logs**

```
sudo systemctl restart oraid && journalctl -u oraid -f -o cat | grep height
```
