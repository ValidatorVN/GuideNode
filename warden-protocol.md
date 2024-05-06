---
description: Next-gen Modular L1 Blockchain Infrastructure for Omnichain Applications
---

# 🧊 Warden Protocol

[https://twitter.com/wardenprotocol](https://twitter.com/wardenprotocol)\
[https://discord.gg/wardenprotocol](https://discord.gg/wardenprotocol)

## Public Endpoints

[https://warden-rpc.validatorvn.com/](https://warden-rpc.validatorvn.com/)

[https://warden-api.validatorvn.com/](https://warden-api.validatorvn.com/)

Peer Node: 10f75c25cddeb85de9fbea50f7df7440bc29e7a1@116.105.188.164:13657

## Explorer

[https://explorer.validatorvn.com/Warden-Testnet](https://explorer.validatorvn.com/Warden-Testnet)

## Snapshots

```
sudo systemctl stop wardend

cp $HOME/.warden/data/priv_validator_state.json $HOME/.warden/priv_validator_state.json.backup

rm -rf $HOME/.warden/data $HOME/.warden/wasmPath
curl https://snapshot.validatorvn.com/warden/data.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.warden

mv $HOME/.warden/priv_validator_state.json.backup $HOME/.warden/data/priv_validator_state.json

sudo systemctl restart wardend && sudo journalctl -u wardend -f -o cat
```

## State Sync

```
sudo systemctl stop wardend

SNAP_RPC="https://warden-rpc.validatorvn.com:443"
cp $HOME/.warden/data/priv_validator_state.json $HOME/.warden/priv_validator_state.json.backup
wardend tendermint unsafe-reset-all --home ~/.warden/ --keep-addr-book

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.warden/config/config.toml
more ~/.warden/config/config.toml | grep 'rpc_servers'
more ~/.warden/config/config.toml | grep 'trust_height'
more ~/.warden/config/config.toml | grep 'trust_hash'

sudo mv $HOME/.warden/priv_validator_state.json.backup $HOME/.warden/data/priv_validator_state.json

sudo systemctl restart wardend && journalctl -u wardend -f -o cat
```

## Genesis & Addrbook

```
curl -Ls https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/WardenProtocol/genesis.json > $HOME/.warden/config/genesis.json
curl -Ls https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/WardenProtocol/addrbook.json > $HOME/.warden/config/addrbook.json
```









