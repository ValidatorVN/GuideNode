---
description: >-
  Dymension is a network of easily deployable and lightning fast modular
  blockchains called RollApps. This documentation serves as a source for all
  things Dymension.
---

# 🧊 Dymension

website: [https://dymension.xyz/](https://docs.dymension.xyz/)\
docs: [https://docs.dymension.xyz/](https://docs.dymension.xyz/)\
x: [https://twitter.com/dymension](https://twitter.com/dymension)\
\


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
git clone https://github.com/dymensionxyz/dymension.git
cd dymension
git checkout v3.0.0
make install
```

## **Node configuration**

```
dymd init ValidatorVN --chain-id=dymension_1100-1

curl -Ls https://ss.dymension.nodestake.org/genesis.json > $HOME/.dymension/config/genesis.json 
curl -Ls https://ss.dymension.nodestake.org/addrbook.json > $HOME/.dymension/config/addrbook.json

sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025udym\"/;" ~/.dymension/config/app.toml
external_address=$(wget -qO- eth0.me)
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.dymension/config/config.toml
peers=""
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.dymension/config/config.toml
seeds="ade4d8bc8cbe014af6ebdf3cb7b1e9ad36f412c0@testnet-seeds.polkachu.com:20556,92308bad858b8886e102009bbb45994d57af44e7@rpc-t.dymension.nodestake.top:666,284313184f63d9f06b218a67a0e2de126b64258d@seeds.silknodes.io:26157"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.dymension/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.dymension/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.dymension/config/config.toml
```

```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.dymension/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.dymension/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.dymension/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.dymension/config/app.toml
```

## **Create a service**

```
sudo tee /etc/systemd/system/dymd.service > /dev/null <<EOF
[Unit]
Description=dymd Daemon
After=network-online.target
[Service]
User=$USER
ExecStart=$(which dymd) start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable dymd

SNAP_NAME=$(curl -s https://ss.dymension.nodestake.org/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
curl -o - -L https://ss.dymension.nodestake.org/${SNAP_NAME}  | lz4 -c -d - | tar -x -C $HOME/.dymension

```

## **Start the service & check logs**

```
sudo systemctl restart dymd && journalctl -u dymd -f -o cat | grep height
```
