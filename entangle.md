---
description: Omnichain Made Easy.
---

# 🧊 Entangle

[https://twitter.com/Entanglefi](https://twitter.com/Entanglefi)\
[https://discord.gg/entangle](https://discord.gg/entangle)

## Public Endpoints

[https://entangle-rpc.validatorvn.com/](https://entangle-rpc.validatorvn.com/)\
[https://entangle-api.validatorvn.com/](https://entangle-api.validatorvn.com/)

## Explorer

[https://explorer.validatorvn.com/Entangle-Mainnet](https://explorer.validatorvn.com/Entangle-Mainnet)

## Genesis & Addrbook

```
curl -Ls https://snapshot.validatorvn.com/entangle/genesis.json > $HOME/.entangled/config/genesis.json
curl -Ls https://snapshot.validatorvn.com/entangle/addrbook.json > $HOME/.entangled/config/addrbook.json
```

## Peers

```
# Configure Seeds and Peers
PEERS="$(curl -sS https://entangle-rpc.validatorvn.com/net_info | jq -r '.result.peers[] | "(.node_info.id)@(.remote_ip):(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | sed -z 's|
|,|g;s|.$||')"
sed -i -e "s|^persistent_peers *=.*|persistent_peers = "$PEERS"|" $HOME/.entangled/config/config.toml

```

## Snapshots

```
sudo systemctl stop entangled

cp $HOME/.entangled/data/priv_validator_state.json $HOME/.entangled/priv_validator_state.json.backup
entangled tendermint unsafe-reset-all --home ~/.entangled/ --keep-addr-book
curl https://snapshot.validatorvn.com/entangle/data.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.entangled
mv $HOME/.entangled/priv_validator_state.json.backup $HOME/.entangled/data/priv_validator_state.json

sudo systemctl restart entangled && sudo journalctl -u entangled -f -o cat
```

## State-sync

```
sudo systemctl stop entangled

SNAP_RPC="https://entangle-rpc.validatorvn.com:443"
cp $HOME/.entangled/data/priv_validator_state.json $HOME/.entangled/priv_validator_state.json.backup
entangled tendermint unsafe-reset-all --home ~/.entangled/ --keep-addr-book

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.entangled/config/config.toml
more ~/.entangled/config/config.toml | grep 'rpc_servers'
more ~/.entangled/config/config.toml | grep 'trust_height'
more ~/.entangled/config/config.toml | grep 'trust_hash'

sudo mv $HOME/.entangled/priv_validator_state.json.backup $HOME/.entangled/data/priv_validator_state.json

sudo systemctl restart entangled && journalctl -u entangled -f -o cat
```
