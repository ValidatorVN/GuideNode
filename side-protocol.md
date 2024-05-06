---
description: 'The Extension Layer of #Bitcoin'
cover: .gitbook/assets/side.jpg
coverY: 0
layout:
  cover:
    visible: true
    size: hero
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
---

# 🧊 Side Protocol

[https://twitter.com/SideProtocol](https://twitter.com/SideProtocol)\
[https://discord.gg/sideprotocol](https://discord.gg/sideprotocol)

## Public Endpoints

[https://side-rpc.validatorvn.com/](https://side-rpc.validatorvn.com/)\
[https://side-api.validatorvn.com/](https://side-api.validatorvn.com/)

## Explorer

[https://explorer.validatorvn.com/Side-Testnet](https://explorer.validatorvn.com/Side-Testnet)

## Snapshots

```
#Update every 12 hours
sudo systemctl stop sided
cp $HOME/.sided/data/priv_validator_state.json $HOME/.sided/priv_validator_state.json.backup
rm -rf $HOME/.sided/data
sided tendermint unsafe-reset-all --home ~/.sided/ --keep-addr-book
curl https://snapshot.validatorvn.com/side/data.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.sided
mv $HOME/.sided/priv_validator_state.json.backup $HOME/.sided/data/priv_validator_state.json
sudo systemctl restart sided && sudo journalctl -u sided -f -o cat
```

## State-sync

```
sudo systemctl stop sided

SNAP_RPC="https://side-rpc.validatorvn.com:443"

cp $HOME/.side/data/priv_validator_state.json $HOME/.side/priv_validator_state.json.backup
sided tendermint unsafe-reset-all --home ~/.side/ --keep-addr-book

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.side/config/config.toml
more ~/.side/config/config.toml | grep 'rpc_servers'
more ~/.side/config/config.toml | grep 'trust_height'
more ~/.side/config/config.toml | grep 'trust_hash'

sudo mv $HOME/.side/priv_validator_state.json.backup $HOME/.side/data/priv_validator_state.json

sudo systemctl restart sided && journalctl -u sided -f -o cat
```

## Genesis & Addrbook

```
curl -Ls https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/SideProtocol/genesis.json > $HOME/.side/config/genesis.json
curl -Ls https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/SideProtocol/addrbook.json > $HOME/.side/config/addrbook.json
```

## Live Peers

```
PEERS=$(curl -sS https://side-rpc.validatorvn.com/net_info | \
jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | \
awk -F ':' '{printf "%s:%s%s", $1, $(NF), NR==NF?"":","}')
echo "$PEERS"
```

```
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.side/config/config.toml
sudo systemctl restart sided && journalctl -fu sided -o cat
```

## Auto-Install

```
wget https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/SideProtocol/sida && chmod +x sida && ./sida
```
