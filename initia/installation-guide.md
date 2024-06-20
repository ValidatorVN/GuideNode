---
description: >-
  A network for interwoven rollups | https://discord.gg/initia | Backed by
  @BinanceLabs, @Delphi_Digital, and @hack_vc
---

# Installation Guide

## Install Initia Node

```
#A bash script to auto-install Initia node
wget https://raw.githubusercontent.com/ValidatorVN/GuideNode/main/Initia/ini && chmod +x ini && ./ini
```

```
#Youtube tutorial for new validators
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

SNAP_RPC="https://initia-rpc.validatorvn.com:443"
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
URL="https://initia-rpc.validatorvn.com/net_info"
# Fetch data from the endpoint
response=$(curl -s $URL)
# Parse JSON and construct PEERS string using jq
PEERS=$(echo $response | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):" + (.node_info.listen_addr | capture("(?<ip>.+):(?<port>[0-9]+)$").port)' | paste -sd "," -)
# Display the PEERS string
echo "PEERS=\"$PEERS\""
# Set the peers
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.initia/config/config.toml
```
