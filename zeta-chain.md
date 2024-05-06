---
description: >-
  Simple, Fast, and Secure Omnichain Blockchain. Build interoperable dApps. Span
  chains from Ethereum to Bitcoin and beyond. Access all of crypto from one
  chain.
---

# 🧊 Zeta Chain

link3.to: [https://link3.to/zetachain](https://link3.to/zetachain)

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
git clone https://github.com/zeta-chain/node.git
cd node
git checkout v14.0.1
make install
```

## **Node configuration**

```
zetacored init Moniker --chain-id=zetachain_7000-1

curl -Ls https://ss.zetachain.nodestake.org/genesis.json > $HOME/.zetacored/config/genesis.json 
curl -Ls https://ss.zetachain.nodestake.org/addrbook.json > $HOME/.zetacored/config/addrbook.json
```

## **Set prunning**

```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.zetacored/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.zetacored/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.zetacored/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.zetacored/config/app.toml
```

## **Create a service**

```
sudo tee /etc/systemd/system/zetacored.service > /dev/null <<EOF
[Unit]
Description=zetacored Daemon
After=network-online.target
[Service]
User=$USER
ExecStart=$(which zetacored) start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable zetacored

SNAP_NAME=$(curl -s https://ss.zetachain.nodestake.org/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
curl -o - -L https://ss.zetachain.nodestake.org/${SNAP_NAME}  | lz4 -c -d - | tar -x -C $HOME/.zetacored
```

## **Start the service & check logs**

```
sudo systemctl restart zetacored && journalctl -u zetacored -f -o cat | grep height
```
