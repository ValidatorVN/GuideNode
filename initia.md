---
description: >-
  A network for interwoven rollups | https://discord.gg/initia | Backed by
  @BinanceLabs, @Delphi_Digital, and @hack_vc
---

# 🧊 Initia

[https://twitter.com/initiaFDN](https://twitter.com/initiaFDN)\
[https://discord.gg/initia](https://discord.gg/initia)

## Install Initia Node

```
wget https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/Initia/ini && chmod +x ini && ./ini
```

```
https://youtu.be/ZnTA2sPzSnc
```

## Snapshots (Every 24 hours at 2AM UTC)

```
sudo systemctl stop initiad.service
cp $HOME/.initia/data/priv_validator_state.json $HOME/.initia/priv_validator_state.json.backup
rm -rf $HOME/.initia/data
curl https://snapshot.validatorvn.com/initia/data.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.initia
mv $HOME/.initia/priv_validator_state.json.backup $HOME/.initia/data/priv_validator_state.json
sudo systemctl start initiad.service && sudo journalctl -u initiad.service -f --no-hostname -o cat

```

## State Sync

```
sudo systemctl stop initiad

SNAP_RPC="https://rpc-initia-testnet.trusted-point.com:443"
cp $HOME/.initia/data/priv_validator_state.json $HOME/.initia/priv_validator_state.json.backup
initiad tendermint unsafe-reset-all --home ~/.initia/ --keep-addr-book

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.initia/config/config.toml
more ~/.initia/config/config.toml | grep 'rpc_servers'
more ~/.initia/config/config.toml | grep 'trust_height'
more ~/.initia/config/config.toml | grep 'trust_hash'

sudo mv $HOME/.initia/priv_validator_state.json.backup $HOME/.initia/data/priv_validator_state.json

sudo systemctl restart initiad && journalctl -u initiad -f -o cat
```

## Genesis & Addrbook

```
curl -L https://snapshot.validatorvn.com/initia/addrbook.json > $HOME/.initia/config/addrbook.json
curl -L https://snapshot.validatorvn.com/initia/genesis.json > $HOME/.initia/config/genesis.json
```

## Seeds & Peers

```
PEERS="40d3f977d97d3c02bd5835070cc139f289e774da@168.119.10.134:26313,841c6a4b2a3d5d59bb116cc549565c8a16b7fae1@23.88.49.233:26656,e6a35b95ec73e511ef352085cb300e257536e075@37.252.186.213:26656,2a574706e4a1eba0e5e46733c232849778faf93b@84.247.137.184:53456,ff9dbc6bb53227ef94dc75ab1ddcaeb2404e1b0b@178.170.47.171:26656,edcc2c7098c42ee348e50ac2242ff897f51405e9@65.109.34.205:36656,07632ab562028c3394ee8e78823069bfc8de7b4c@37.27.52.25:19656,028999a1696b45863ff84df12ebf2aebc5d40c2d@37.27.48.77:26656,140c332230ac19f118e5882deaf00906a1dba467@185.219.142.119:53456,1f6633bc18eb06b6c0cab97d72c585a6d7a207bc@65.109.59.22:25756,065f64fab28cb0d06a7841887d5b469ec58a0116@84.247.137.200:53456,767fdcfdb0998209834b929c59a2b57d474cc496@207.148.114.112:26656,093e1b89a498b6a8760ad2188fbda30a05e4f300@35.240.207.217:26656,12526b1e95e7ef07a3eb874465662885a586e095@95.216.78.111:26656" && \
SEEDS="2eaa272622d1ba6796100ab39f58c75d458b9dbc@34.142.181.82:26656,c28827cb96c14c905b127b92065a3fb4cd77d7f6@testnet-seeds.whispernode.com:25756" && \
sed -i \
    -e "s/^seeds *=.*/seeds = \"$SEEDS\"/" \
    -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" \
    "$HOME/.initia/config/config.toml"
```

