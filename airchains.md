---
description: The Modular zk-Rollup framework
---

# 🧊 Airchains

## Public Endpoints

[https://junction-rpc.validatorvn.com/](https://junction-rpc.validatorvn.com/)\
[https://junction-api.validatorvn.com/](https://junction-api.validatorvn.com/)

## Explorer

[https://explorer.validatorvn.com/Airchains-Testnet/staking](https://explorer.validatorvn.com/Airchains-Testnet/staking)

## Snapshot

```
sudo systemctl stop junctiond
cp $HOME/.junction/data/priv_validator_state.json $HOME/.junction/priv_validator_state.json.backup
rm -rf $HOME/.junction/data
junctiond tendermint unsafe-reset-all --home ~/.junction/ --keep-addr-book
curl https://snapshot.validatorvn.com/junction/data.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.junction
mv $HOME/.junction/priv_validator_state.json.backup $HOME/.junction/data/priv_validator_state.json
sudo systemctl restart junctiond && sudo journalctl -u junctiond -f -o cat
```

## State-sync

```
sudo systemctl stop junctiond
cp $HOME/.junction/data/priv_validator_state.json $HOME/.junction/priv_validator_state.json.backup
junctiond tendermint unsafe-reset-all --home ~/.junction/ --keep-addr-book
SNAP_RPC="https://junction-rpc.validatorvn.com:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.junction/config/config.toml
more ~/.junction/config/config.toml | grep 'rpc_servers'
more ~/.junction/config/config.toml | grep 'trust_height'
more ~/.junction/config/config.toml | grep 'trust_hash'

sudo mv $HOME/.junction/priv_validator_state.json.backup $HOME/.junction/data/priv_validator_state.json

sudo systemctl restart junctiond && journalctl -u junctiond -f -o cat
```

## Seeds & Peers

```
peers="1918bd71bc764c71456d10483f754884223959a5@35.240.206.208:26656,48887cbb310bb854d7f9da8d5687cbfca02b9968@35.200.245.190:26656,ddd9aade8e12d72cc874263c8b854e579903d21c@34.165.28.145:26656,de2e7251667dee5de5eed98e54a58749fadd23d8@34.22.237.85:266560305205b9c2c76557381ed71ac23244558a51099@162.55.65.162:26656,6a2f6a5cd2050f72704d6a9c8917a5bf0ed63b53@93.115.25.41:26656,5c5989b5dee8cff0b379c4f7273eac3091c3137b@57.128.74.22:56256,086d19f4d7542666c8b0cac703f78d4a8d4ec528@135.148.232.105:26656,8b72b2f2e027f8a736e36b2350f6897a5e9bfeaa@131.153.232.69:26656,3e5f3247d41d2c3ceeef0987f836e9b29068a3e9@168.119.31.198:56256"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.junction/config/config.toml
seeds="2d1ea4833843cc1433e3c44e69e297f357d2d8bd@5.78.118.106:26656"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.junction/config/config.toml
```

## Addrbook & Genesis

```bash
curl -L https://snapshot.validatorvn.com/junction/addrbook.json > $HOME/.junction/config/addrbook.json
curl -L https://snapshot.validatorvn.com/junction/genesis.json > $HOME/.junction/config/genesis.json
```
