---
description: >-
  The layer 1 blockchain for yield. Empowering you to capitalise on price
  volatility & unstable yields, unlock future yield, and maximize profits.
---

# 🧊 Pryzm

[https://twitter.com/Pryzm\_Zone](https://twitter.com/Pryzm\_Zone)\
[https://discord.gg/pryzm](https://discord.gg/pryzm)

## Public Endpoints

[https://pryzm-rpc.validatorvn.com/](https://pryzm-rpc.validatorvn.com/)\
[https://pryzm-api.validatorvn.com/](https://pryzm-api.validatorvn.com/)

## Explorer

[https://explorer.validatorvn.com/Pryzm-Testnet](https://explorer.validatorvn.com/Pryzm-Testnet)

## Snapshots

```
sudo systemctl stop pryzmd
cp $HOME/.pryzm/data/priv_validator_state.json $HOME/.pryzm/priv_validator_state.json.backup
rm -rf $HOME/.pryzm/data
pryzmd tendermint unsafe-reset-all --home ~/.pryzm/ --keep-addr-book
curl https://snapshot.validatorvn.com/pryzm/data.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.pryzm
mv $HOME/.pryzm/priv_validator_state.json.backup $HOME/.pryzm/data/priv_validator_state.json
sudo systemctl restart pryzmd && sudo journalctl -u pryzmd -f -o cat
```

## State-sync

```
pryzmdsudo systemctl stop pryzmd

SNAP_RPC="https://pryzm-rpc.validatorvn.com:443"

cp $HOME/.pryzm/data/priv_validator_state.json $HOME/.pryzm/priv_validator_state.json.backup
pryzmd tendermint unsafe-reset-all --home ~/.pryzm/ --keep-addr-book

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.pryzm/config/config.toml
more ~/.pryzm/config/config.toml | grep 'rpc_servers'
more ~/.pryzm/config/config.toml | grep 'trust_height'
more ~/.pryzm/config/config.toml | grep 'trust_hash'

sudo mv $HOME/.pryzm/priv_validator_state.json.backup $HOME/.pryzm/data/priv_validator_state.json

sudo systemctl restart pryzmd && journalctl -u pryzmd -f -o cat
```

## Genesis & Addrbook

```
curl -L https://snapshot.validatorvn.com/pryzm/addrbook.json > $HOME/.pryzm/config/addrbook.json
curl -L https://snapshot.validatorvn.com/pryzm/genesis.json > $HOME/.pryzm/config/genesis.json
```











