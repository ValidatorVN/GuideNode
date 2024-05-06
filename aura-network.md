---
description: >-
  Aura Network is a high performance Layer 1 ecosystem with built-in modularity,
  leading the mass adoption of Web3 in emerging markets.
---

# 🧊 Aura Network

website: [https://aura.network/](https://aura.network/)\
x: [https://twitter.com/AuraNetworkHQ](https://twitter.com/AuraNetworkHQ)\
github: [https://github.com/aura-nw](https://github.com/aura-nw)\
telegram: [https://t.me/AuraNetworkOfficial](https://t.me/AuraNetworkOfficial)

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
cd && rm -rf aura
git clone https://github.com/aura-nw/aura
cd aura
git checkout v0.7.3
```

## **Node configuration**

```
aurad config chain-id xstaxy-1
aurad config keyring-backend file
aurad init "ValidatorVN" --chain-id xstaxy-1
wget -O $HOME/.aura/config/genesis.json "https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/AuraNetwork/genesis.json"
wget -O $HOME/.aura/config/addrbook.json "https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/AuraNetwork/addrbook.json"

sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025uaura\"/;" ~/.aura/config/app.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.aura/config/config.toml
peers="ebc272824924ea1a27ea3183dd0b9ba713494f83@auranetwork-mainnet-peer.autostake.com:26966,edbd221ceecf4e0234fb60d617a025c6b0e56bf0@178.250.154.15:36656,b91ee5c72905bc49beed2720bb882c923c68fbc9@80.92.206.66:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.aura/config/config.toml
seeds="ebc272824924ea1a27ea3183dd0b9ba713494f83@auranetwork-mainnet-peer.autostake.com:26966"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.aura/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.aura/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.aura/config/config.toml
```

## **Set prunning**

```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.aura/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.aura/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.aura/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.aura/config/app.toml
```

## **Create a service**

```
sudo tee /etc/systemd/system/aurad.service > /dev/null <<EOF
[Unit]
Description=aura node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which aurad) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable aurad

curl "https://snapshots.nodejumper.io/aura/aura_latest.tar.lz4" | lz4 -dc - | tar -xf - -C "$HOME/.aura"
```

## **Start the service & check logs**

```
sudo systemctl restart aurad && journalctl -u aurad -f -o cat | grep height
```
