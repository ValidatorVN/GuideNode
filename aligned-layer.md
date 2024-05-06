---
description: >-
  Universal Verification Layer for @ethereum using @eigenlayer. A product by
  @yetanotherco and @class_lambda.
---

# 🧊 Aligned Layer

[https://twitter.com/alignedlayer](https://twitter.com/alignedlayer)\
[https://discord.gg/alignedlayer](https://discord.gg/alignedlayer)

## Public Endpoints

[https://aligned-rpc.validatorvn.com/](https://aligned-rpc.validatorvn.com/)\
[https://aligned-api.validatorvn.com/](https://aligned-api.validatorvn.com/)

## Explorer

[https://explorer.validatorvn.com/AlignedLayer-Testnet](https://explorer.validatorvn.com/AlignedLayer-Testnet)

## Snapshots

```
sudo systemctl stop alignedlayerd
cp $HOME/.alignedlayer/data/priv_validator_state.json $HOME/.alignedlayer/priv_validator_state.json.backup
rm -rf $HOME/.alignedlayer/data
alignedlayerd tendermint unsafe-reset-all --home ~/.alignedlayer/ --keep-addr-book
curl https://snapshot.validatorvn.com/aligned/data.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.alignedlayer
mv $HOME/.alignedlayer/priv_validator_state.json.backup $HOME/.alignedlayer/data/priv_validator_state.json
sudo systemctl restart alignedlayerd && sudo journalctl -u alignedlayerd -f -o cat

```

## State-sync

```
sudo systemctl stop alignedlayerd

SNAP_RPC="https://aligned-rpc.validatorvn.com:443"

cp $HOME/.alignedlayer/data/priv_validator_state.json $HOME/.alignedlayer/priv_validator_state.json.backup
alignedlayerd tendermint unsafe-reset-all --home ~/.alignedlayer/ --keep-addr-book

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.alignedlayer/config/config.toml
more ~/.alignedlayer/config/config.toml | grep 'rpc_servers'
more ~/.alignedlayer/config/config.toml | grep 'trust_height'
more ~/.alignedlayer/config/config.toml | grep 'trust_hash'

sudo mv $HOME/.alignedlayer/priv_validator_state.json.backup $HOME/.alignedlayer/data/priv_validator_state.json

sudo systemctl restart alignedlayerd && journalctl -u alignedlayerd -f -o cat

```

## Genesis & Addrbook

```
curl -Ls https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/AlignedLayer/genesis.json > $HOME/.alignedlayer/config/genesis.json
curl -Ls https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/AlignedLayer/addrbook.json > $HOME/.alignedlayer/config/addrbook.json
```

