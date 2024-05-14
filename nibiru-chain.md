---
description: >-
  The Web3 hub ushering in the next era of money. Nibiru is an L1 blockchain
  powering a smart contract hub with DeFi, RWAs, and more. https://nibiru.fi
---

# 🧊 Nibiru Chain

website: [https://nibiru.fi/](https://nibiru.fi/)\
x: [https://twitter.com/NibiruChain](https://twitter.com/NibiruChain)\
discord: [https://discord.com/invite/nibirufi](https://discord.com/invite/nibirufi)\
link tr.ee: [https://linktr.ee/nibiruchain](https://linktr.ee/nibiruchain)\
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
git clone https://github.com/NibiruChain/nibiru.git
cd nibiru
git checkout v1.3.0
make install
```

## **Node configuration**

```
nibid init Moniker --chain-id=cataclysm-1

wget -O $HOME/.nibid/config/genesis.json "https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/Nibiru/genesis.json"
wget -O $HOME/.nibid/config/addrbook.json "https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/Nibiru/addrbook.json"

```

## **Set prunning**

```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.nibid/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.nibid/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.nibid/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.nibid/config/app.toml
```

## **Create a service**

```
sudo tee /etc/systemd/system/nibid.service > /dev/null <<EOF
[Unit]
Description=nibid Daemon
After=network-online.target
[Service]
User=$USER
ExecStart=$(which nibid) start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable nibid

SNAP_NAME=$(curl -s https://ss.nibiru.nodestake.org/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
curl -o - -L https://ss.nibiru.nodestake.org/${SNAP_NAME}  | lz4 -c -d - | tar -x -C $HOME/.nibid

```

## **Start the service & check logs**

```
sudo systemctl restart nibid && journalctl -u nibid -f -o cat | grep height
```
