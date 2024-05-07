---
description: 'The Ultimate Web3 Identity Stack | Turning Hashes Into Souls | #GNET'
cover: .gitbook/assets/galactica.jpg
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

# 🧊 Galactica

[https://discord.gg/galactica](http://discord.gg/galactica)\
[https://galactica.com/](https://galactica.com/)

## Public Endpoints

[https://galactica-rpc.validatorvn.com](https://galactica-rpc.validatorvn.com/)\
[https://galactica-api.validatorvn.com](https://galactica-api.validatorvn.com)

## Explorer

[https://explorer.validatorvn.com/Galactica-Testnet](https://explorer.validatorvn.com/Galactica-Testnet)

## Snapshots

```
#Update every 24 hours
sudo systemctl stop galacticad
cp $HOME/.galactica/data/priv_validator_state.json $HOME/.galactica/priv_validator_state.json.backup
rm -rf $HOME/.galactica/data
galacticad tendermint unsafe-reset-all --home ~/.galactica/ --keep-addr-book
curl https://snapshot.validatorvn.com/galactica/data.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.galactica
mv $HOME/.galactica/priv_validator_state.json.backup $HOME/.galactica/data/priv_validator_state.json
sudo systemctl restart galacticad && sudo journalctl -u galacticad -f -o cat
```

## State-sync

```
sudo systemctl stop galacticad

SNAP_RPC="https://galactica-rpc.validatorvn.com:443"

cp $HOME/.galactica/data/priv_validator_state.json $HOME/.galactica/priv_validator_state.json.backup
galacticad tendermint unsafe-reset-all --home ~/.galactica/ --keep-addr-book

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.galactica/config/config.toml
more ~/.galactica/config/config.toml | grep 'rpc_servers'
more ~/.galactica/config/config.toml | grep 'trust_height'
more ~/.galactica/config/config.toml | grep 'trust_hash'

sudo mv $HOME/.galactica/priv_validator_state.json.backup $HOME/.galactica/data/priv_validator_state.json

sudo systemctl restart galacticad && journalctl -u galacticad -f -o cat
```

## Genesis & Addrbook

```
wget -O $HOME/.galactica/config/genesis.json https://snapshot.validatorvn.com/galactica/genesis.json
wget -O $HOME/.galactica/config/addrbook.json https://snapshot.validatorvn.com/galactica/addrbook.json
```

## Live Peers

```
PEERS=$(curl -sS https://galactica-rpc.validatorvn.com/net_info | \
jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | \
awk -F ':' '{printf "%s:%s%s", $1, $(NF), NR==NF?"":","}')
echo "$PEERS"
```

```
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.galactica/config/config.toml
sudo systemctl restart galacticad && journalctl -fu galacticad -o cat
```



