---
description: >-
  An extensible L1 blockchain with parallel execution and interoperable VMs.
  EVM++
---

# 🧊 Artela Network

[https://twitter.com/Artela\_Network](https://twitter.com/Artela\_Network)\
[https://discord.gg/artela](https://discord.gg/artela)

## Public Endpoints

[https://artela-rpc.validatorvn.com/](https://artela-rpc.validatorvn.com/)\
[https://artela-api.validatorvn.com/](https://artela-api.validatorvn.com/)

## Explorer

[https://explorer.validatorvn.com/Artela-Testnet](https://explorer.validatorvn.com/Artela-Testnet)

## Snapshots

```
sudo systemctl stop artelad
cp $HOME/.artelad/data/priv_validator_state.json $HOME/.artelad/priv_validator_state.json.backup
rm -rf $HOME/.artelad/data
artelad tendermint unsafe-reset-all --home ~/.artelad/ --keep-addr-book
curl https://snapshot.validatorvn.com/artela/data.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.artelad
mv $HOME/.artelad/priv_validator_state.json.backup $HOME/.artelad/data/priv_validator_state.json
sudo systemctl restart artelad && sudo journalctl -u artelad -f -o cat

```

## State-sync

```
sudo systemctl stop artelad

SNAP_RPC="https://artela-rpc.validatorvn.com:443"

cp $HOME/.artelad/data/priv_validator_state.json $HOME/.artelad/priv_validator_state.json.backup
artelad tendermint unsafe-reset-all --home ~/.artelad/ --keep-addr-book

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.artelad/config/config.toml
more ~/.artelad/config/config.toml | grep 'rpc_servers'
more ~/.artelad/config/config.toml | grep 'trust_height'
more ~/.artelad/config/config.toml | grep 'trust_hash'

sudo mv $HOME/.artelad/priv_validator_state.json.backup $HOME/.artelad/data/priv_validator_state.json

sudo systemctl restart artelad && journalctl -u artelad -f -o cat

```

## Genesis & Addrbook

```
curl -L https://snapshot.validatorvn.com/artela/addrbook.json > $HOME/.artelad/config/addrbook.json
curl -L https://snapshot.validatorvn.com/artela/genesis.json > $HOME/.artelad/config/genesis.json
```

## Live Peers

```
PEERS=$(curl -sS https://artela-rpc.validatorvn.com/net_info | \
jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | \
awk -F ':' '{printf "%s:%s%s", $1, $(NF), NR==NF?"":","}')
echo "$PEERS"
```

```
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.artela/config/config.toml
sudo systemctl restart artelad && journalctl -fu artelad -o cat
```
