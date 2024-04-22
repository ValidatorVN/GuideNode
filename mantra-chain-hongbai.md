---
description: >-
  Mantra - The first RWA Layer 1 Blockchain, capable of adherence and
  enforcement of real world regulatory requirements.
---

# Mantra Chain - Hongbai

[https://twitter.com/MANTRA\_Chain](https://twitter.com/MANTRA\_Chain)

[https://www.mantrachain.io/](https://www.mantrachain.io/)

## Public Endpoints

[https://mantra-rpc-testnet.validatorvn.com/](https://mantra-rpc-testnet.validatorvn.com/)

[https://mantra-api-testnet.validatorvn.com/](https://mantra-rpc-testnet.validatorvn.com/)

Peer Node: 723496f58f26b90d604bdb18bde79c378e3a5e01@65.21.219.229:10016

## Explorer

[https://explorer.validatorvn.com/Mantra-Testnet](https://explorer.validatorvn.com/Mantra-Testnet/staking)

## Snapshots

```
sudo systemctl stop mantrachaind

cp $HOME/.mantrachain/data/priv_validator_state.json $HOME/.mantrachain/priv_validator_state.json.backup

rm -rf $HOME/.mantrachain/data $HOME/.mantrachain/wasmPath
curl https://snapshot.validatorvn.com/mantra/snap_mantra.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.mantrachain

mv $HOME/.mantrachain/priv_validator_state.json.backup $HOME/.mantrachain/data/priv_validator_state.json

sudo systemctl restart mantrachaind && sudo journalctl -u mantrachaind -f -o cat
```

## State Sync

```
sudo systemctl stop mantrachaind
cp $HOME/.mantrachain/data/priv_validator_state.json $HOME/.mantrachain/priv_validator_state.json.backup
mantrachaind tendermint unsafe-reset-all --home ~/.mantrachain/ --keep-addr-book
SNAP_RPC="https://mantra-rpc-testnet.validatorvn.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.mantrachain/config/config.toml
more ~/.mantrachain/config/config.toml | grep 'rpc_servers'
more ~/.mantrachain/config/config.toml | grep 'trust_height'
more ~/.mantrachain/config/config.toml | grep 'trust_hash'

sudo mv $HOME/.mantrachain/priv_validator_state.json.backup $HOME/.mantrachain/data/priv_validator_state.json
sudo systemctl restart mantrachaind && journalctl -u mantrachaind -f -o cat
```









