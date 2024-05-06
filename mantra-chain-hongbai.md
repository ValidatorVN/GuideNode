---
description: >-
  Mantra - The first RWA Layer 1 Blockchain, capable of adherence and
  enforcement of real world regulatory requirements.
---

# 🧊 Mantra Chain - Hongbai

[https://twitter.com/MANTRA\_Chain](https://twitter.com/MANTRA\_Chain)

[https://www.mantrachain.io/](https://www.mantrachain.io/)

## Public Endpoints

[https://mantra-rpc-testnet.validatorvn.com/](https://mantra-rpc-testnet.validatorvn.com/)

[https://mantra-api-testnet.validatorvn.com/](https://mantra-rpc-testnet.validatorvn.com/)

Peer Node: b9d6683ad129b83c668e6a396e078a62a1df885b@84.247.160.242:23656 b7556ae422275e13eb82297b5179a1b189467a89@159.69.142.51:50056 0bec22d0dbb4ca95b56d1b1555ec0699e6d7ca15@81.0.249.86:23656 a76dc91a33366d96e8875cee75b6a99cd0521693@38.242.237.130:23656 a20919f685a4a374d1a30fea5326127bfa208a01@62.169.17.140:23656 76dbb3943044e1c4bd422c3f2820b8bc044f48e0@46.250.237.236:23656 ec579fd3a9563aae863e9bfef783e41fefdaf97b@158.220.112.78:23656 4ccf2fb06244e8b39e3cb28a04602f1c4c593344@37.60.245.125:16656 ece9360315f4a818edd9c1cc6e46992d9949d559@142.93.231.24:23656 f63250c673b8d5b8e19e48f6020d4ec27b84e437@45.138.74.204:11656

## Explorer

[https://explorer.validatorvn.com/Mantra-Testnet](https://explorer.validatorvn.com/Mantra-Testnet/staking)

## Genesis & Addrbook

```
wget -O $HOME/.mantrachain/config/genesis.json https://snapshot.validatorvn.com/mantra/genesis.json
wget -O $HOME/.mantrachain/config/addrbook.json https://snapshot.validatorvn.com/mantra/addrbook.json
```

## Snapshots

```
sudo systemctl stop mantrachaind

cp $HOME/.mantrachain/data/priv_validator_state.json $HOME/.mantrachain/priv_validator_state.json.backup

rm -rf $HOME/.mantrachain/data $HOME/.mantrachain/wasmPath
curl https://snapshot.validatorvn.com/mantra/data.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.mantrachain

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









