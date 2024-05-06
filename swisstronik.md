---
description: >-
  Layer 1 solution designed to build scalable dApps that ensure users' data
  protection and privacy, while remaining compliant | Built on @cosmos
---

# 🧊 Swisstronik

website: [https://swisstronik.com/](https://swisstronik.com/)\
twitter: [https://twitter.com/swisstronik](https://twitter.com/swisstronik)\
social: [https://linktr.ee/swisstronik](https://linktr.ee/swisstronik)

## Setup SGX

```
wget https://download.01.org/intel-sgx/sgx-linux/2.22/distro/ubuntu22.04-server/sgx_linux_x64_driver_2.11.54c9c4c.bin 
chmod +x sgx_linux_x64_driver_2.11.54c9c4c.bin
sudo ./sgx_linux_x64_driver_2.11.54c9c4c.bin

```

## Install Intel AESM service

```
echo "deb https://download.01.org/intel-sgx/sgx_repo/ubuntu $(lsb_release -cs) main" | sudo tee -a /etc/apt/sources.list.d/intel-sgx.list >/dev/null
curl -sSL "https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key" | sudo -E apt-key add -
sudo apt update
sudo apt install sgx-aesm-service libsgx-aesm-launch-plugin libsgx-aesm-epid-plugin
```

## Install all required libraries

```
echo "deb https://download.01.org/intel-sgx/sgx_repo/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/intel-sgx.list >/dev/null
curl -sSL "https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key" | sudo -E apt-key add -
sudo apt update
sudo apt install libsgx-launch libsgx-urts libsgx-epid libsgx-quote-ex sgx-aesm-service libsgx-aesm-launch-plugin libsgx-aesm-epid-plugin libsgx-quote-ex libsgx-dcap-ql libsnappy1v5
```

## Install RUST

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
```

## Build & Install SGX tool

```
cargo install sgxs-tools
```

```
sudo $(which sgx-detect)

Detecting SGX, this may take a minute...
✔  SGX instruction set
  ✔  CPU support
  ✔  CPU configuration
  ✔  Enclave attributes
  ✔  Enclave Page Cache
  SGX features
    ✔  SGX2  ✔  EXINFO  ✔  ENCLV  ✔  OVERSUB  ✔  KSS  
    Total EPC size: 92.2MiB
✔  Flexible launch control
  ✔  CPU support
  ✔  CPU configuration
  ✔  Able to launch production mode enclave
✔  SGX system software
  ✔  SGX kernel device (/dev/sgx_enclave)
  ✔  libsgx_enclave_common
  ✔  AESM service
  ✔  Able to launch enclaves
    ✔  Debug mode
    ✔  Production mode
    ✔  Production mode (Intel whitelisted)

You're all set to start running SGX programs!
```

## Public Endpoints:

```
RPC: https://swiss-rpc.validatorvn.com
API: https://swiss-api.validatorvn.com
gRPC: swiss-grpc.validatorvn.com
```

## **Building from source**

```
sudo apt update
sudo apt install -y curl git jq lz4 build-essential unzip sudo apt install gcc protobuf-compiler pkg-config libssl-dev
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
wget https://github.com/SigmaGmbH/swisstronik-chain/releases/download/v1.0.1/swisstronikd.deb.zip 
unzip swisstronikd.deb.zip  
dpkg -i swisstronik_1.0.1-updated-binaries_amd64.deb 
swisstronikd version

mkdir -p /root/.swisstronik-enclave/
cp /usr/lib/enclave.signed.so /root/.swisstronik-enclave/enclave.signed.so
```

## **Node configuration**

```
swisstronikd enclave request-master-key rpc.testnet.swisstronik.com:46789
swisstronikd init YOUR_MONIKER --chain-id swisstronik_1291-1

wget -O $HOME/.swisstronik/config/genesis.json "https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/Swisstronik/genesis.json"
wget -O $HOME/.swisstronik/config/addrbook.json "https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/Swisstronik/addrbook.json"

sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"7uswtr\"/;" ~/.swisstronik/config/app.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 50/g' $HOME/.swisstronik/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 50/g' $HOME/.swisstronik/config/config.toml
```

## **Set prunning**

```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.swisstronik/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.swisstronik/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.swisstronik/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.swisstronik/config/app.toml
```

## **Create a service**

```
sudo tee /etc/systemd/system/swisstronikd.service > /dev/null <<EOF
[Unit]
Description=swisstronik node
After=network-online.target

[Service]
User=$USER
ExecStart=$(which swisstronikd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable swisstronikd

SNAP_NAME=$(curl -s https://snap.konsortech.xyz/swisstronik/ | egrep -o ">swisstronik-snapshot.*\.tar.lz4" | tr -d ">")
curl https://snap.konsortech.xyz/swisstronik/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.swisstronik
```

## **Start the service & check logs**

```
sudo systemctl restart swisstronikd && journalctl -u swisstronikd -f -o cat | grep height
```

## State Sync

```
sudo systemctl stop swisstronikd

SNAP_RPC="https://rpc.testnet.swisstronik.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.swisstronik/config/config.toml

swisstronikd tendermint unsafe-reset-all --home $HOME/.swisstronik --keep-addr-book
sudo systemctl restart swisstronikd && journalctl -u swisstronikd -f -o cat | grep height
```
