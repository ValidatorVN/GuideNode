---
description: >-
  Creating AI platforms and services that let anyone build and deploy AI
  services at scale, anytime and anywhere.
---

# 🧊 Fetch Chain

website: [https://fetch.ai/](https://fetch.ai/)\
x: [https://twitter.com/Fetch\_ai](https://twitter.com/Fetch\_ai)\
linktr.ee: [https://linktr.ee/fetch\_ai](https://linktr.ee/fetch\_ai)\


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
cd || return
rm -rf fetch
git clone https://github.com/fetchai/fetchd fetch
cd fetch || return
git checkout v0.10.7
make install
```

## **Node configuration**

```
fetchd init Validator_Name --chain-id fetchhub-4
wget -O genesis.json https://snapshots.polkachu.com/genesis/fetch/genesis.json --inet4-only
mv genesis.json ~/.fetchd/config
wget -O addrbook.json https://snapshots.polkachu.com/addrbook/fetch/addrbook.json --inet4-only
mv addrbook.json ~/.fetchd/config
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025afet\"/;" ~/.fetchd/config/app.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.fetchd/config/config.toml
peers="c1a24d8d8c5522200bf3229c917e094fb312a7eb@65.108.131.174:15256,ebc272824924ea1a27ea3183dd0b9ba713494f83@fetchhub-mainnet-peer.autostake.com:27266"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.fetchd/config/config.toml
seeds="ebc272824924ea1a27ea3183dd0b9ba713494f83@fetchhub-mainnet-seed.autostake.com:27266"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.fetchd/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.fetchd/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.fetchd/config/config.toml
```

## **Set prunning**

```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.fetchd/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.fetchd/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.fetchd/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.fetchd/config/app.toml
```

## **Create a service**

```
sudo tee /etc/systemd/system/aurad.service > /dev/null <<EOF
[Unit]
Description=aura node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which fetchd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable fetchd

curl -o - -L https://snapshots.polkachu.com/snapshots/fetch/fetch_13749911.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.fetchd

```

## **Start the service & check logs**

```
sudo systemctl restart fetchd && journalctl -u fetchd -f -o cat | grep height
```
