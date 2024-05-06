# 🧊 Blockx Network

BlockX Network is a Layer 1 Ethereum alternative blockchain that offers multi-chain operability, an off-chain oracle infrastructure, and enables sovereign digital identity for the next-gen of Web3.

The BlockX ecosystem is built to utilize the Delegated Proof-of-Stake (DPoS) consensus algorithm which helps it to process and verify transactions instantly while helping dApps scale seamlessly.

Additionally, BlockX can be deployed by organizations in the traditional financial sector looking to transition to the blockchain. The list of these sectors includes - _banks, exchanges, trade finance, CBDC, stock, bond, loans, funds,_ and _real estate_.



website: [https://www.blockxnet.com/](https://www.blockxnet.com/)\
docs: [https://docs.blockxnet.com/](https://docs.blockxnet.com/)\
explorer: [https://ping.blockxnet.com/](https://ping.blockxnet.com/)\
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
rm -rf blockx
curl -LO https://github.com/defi-ventures/blockx-node-public-compiled/releases/download/v10.0.0/blockxd
chmod +x blockxd
mkdir -p $HOME/go/bin/
mv blockxd $HOME/go/bin/
```

## **Node configuration**

```
blockxd config chain-id blockx_100-1
blockxd init "ValidatorVN" --chain-id blockx_100-1

wget -O $HOME/.blockxd/config/genesis.json "https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/Blockx/genesis.json"
wget -O $HOME/.blockxd/config/addrbook.json "https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/Blockx/addrbook.json"

SEEDS="479dfa1948f49b08810cd16bf6c2d3256ae85423@137.184.7.64:26656,e15f4d31281036c69fa17269d9b26ff8733511c6@147.182.238.235:26656,9b84b33d44a880a520006ae9f75ef030b259cbaf@137.184.38.212:26656,85d0069266e78896f9d9e17915cdfd271ba91dfd@146.190.153.165:26656"
PEERS=""
sed -i 's|^seeds *=.*|seeds = "'$SEEDS'"|; s|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.blockxd/config/config.toml

sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0abcx"|g' $HOME/.blockxd/config/app.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.blockxd/config/config.toml
```

## **Set prunning**

```
sed -i 's|^pruning *=.*|pruning = "custom"|g' $HOME/.blockxd/config/app.toml
sed -i 's|^pruning-keep-recent  *=.*|pruning-keep-recent = "100"|g' $HOME/.blockxd/config/app.toml
sed -i 's|^pruning-interval *=.*|pruning-interval = "10"|g' $HOME/.blockxd/config/app.toml
sed -i 's|^snapshot-interval *=.*|snapshot-interval = 0|g' $HOME/.blockxd/config/app.toml
```

## **Create a service**

```
sudo tee /etc/systemd/system/blockxd.service > /dev/null << EOF
[Unit]
Description=blockxd node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which blockxd) start
Restart=on-failure
RestartSec=10
LimitNOFILE=10000
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable blockxd

blockxd tendermint unsafe-reset-all --home $HOME/.blockxd --keep-addr-book
SNAP_NAME=$(curl -s https://ss.blockx.nodestake.org/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
curl -o - -L https://ss.blockx.nodestake.org/${SNAP_NAME}  | lz4 -c -d - | tar -x -C $HOME/.blockxd
```

## **Start the service & check logs**

```
sudo systemctl restart blockxd && journalctl -u blockxd -f -o cat | grep height
```
