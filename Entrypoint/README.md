# Public Enpoint:
RPC:

    https://entrypoint-rpc.validatorvn.com

API

    https://entrypoint-api.validatorvn.com

gRPC

    entrypoint-grpc.validatorvn.com
    
# Auto Install

    wget -O ent https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Entrypoint/ent && chmod +x ent && ./ent

# Command

Add new key

    entrypointd keys add wallet

Recover existing key

    entrypointd keys add wallet --recover

Query Wallet Balance

    entrypointd q bank balances $(entrypointd keys show wallet -a)

Create Validator

    entrypointd tx staking create-validator \
    --amount 1000000uentry \
    --pubkey $(entrypointd tendermint show-validator) \
    --moniker "MONIKER" \
    --identity="YOUR_KEYBASE_ID" \
    --details="YOUR_DETAILS" \
    --website="YOUR_WEBSITE_URL" \
    --chain-id entrypoint-pubtest-2 \
    --commission-rate="0.05" \
    --commission-max-rate="0.20" \
    --commission-max-change-rate="0.01" \
    --min-self-delegation "1" \
    --gas-prices="0.01ibc/8A138BC76D0FB2665F8937EC2BF01B9F6A714F6127221A0E155106A45E09BCC5" \
    --gas="auto" \
    --gas-adjustment="1.5" \
    --from wallet \
    -y

Edit Validator

    entrypointd tx staking edit-validator \
    --new-moniker="MONIKER" \
    --identity="YOUR_KEYBASE_ID" \
    --details="YOUR_DETAILS" \
    --website="YOUR_WEBSITE_URL" \
    --chain-id entrypoint-pubtest-2 \
    --commission-rate=0.05 \
    --gas-prices="0.01ibc/8A138BC76D0FB2665F8937EC2BF01B9F6A714F6127221A0E155106A45E09BCC5" \
    --gas="auto" \
    --gas-adjustment="1.5" \
    --from wallet \
    -y

Unjail Validator

    entrypointd tx slashing unjail --from wallet --chain-id entrypoint-pubtest-2 --gas-prices=0.01ibc/8A138BC76D0FB2665F8937EC2BF01B9F6A714F6127221A0E155106A45E09BCC5 --gas-adjustment 1.5 --gas auto -y 

Withdraw rewards from all validators

    entrypointd  tx distribution withdraw-all-rewards --from wallet --chain-id entrypoint-pubtest-2 --gas-prices=0.01ibc/8A138BC76D0FB2665F8937EC2BF01B9F6A714F6127221A0E155106A45E09BCC5 --gas-adjustment 1.5 --gas auto -y 

Withdraw comission and rewards from your validator

    entrypointd tx distribution withdraw-rewards $(entrypointd keys show wallet --bech val -a) --commission --from wallet --chain-id entrypoint-pubtest-2 --gas-prices=0.01ibc/8A138BC76D0FB2665F8937EC2BF01B9F6A714F6127221A0E155106A45E09BCC5 --gas-adjustment 1.5 --gas auto -y 

Delegate to your validator

    entrypointd tx staking delegate $(entrypointd keys show wallet --bech val -a) 1000000uentry --from wallet --chain-id entrypoint-pubtest-2 --gas-prices=0.01ibc/8A138BC76D0FB2665F8937EC2BF01B9F6A714F6127221A0E155106A45E09BCC5 --gas-adjustment 1.5 --gas auto -y 

Get sync status

    entrypointd status 2>&1 | jq .SyncInfo.catching_up

# Reload Service

    sudo systemctl daemon-reload
​
# Enable Service

    sudo systemctl enable entrypointd
​
# Disable Service

    sudo systemctl disable entrypointd
​
# Start Service

    sudo systemctl start entrypointd
​
# Stop Service

    sudo systemctl stop entrypointd
​
# Restart Service

    sudo systemctl restart entrypointd
​
# Check Service Status

    sudo systemctl status entrypointd
​
# Check Service Logs

    sudo journalctl -u entrypointd -f --no-hostname -o cat
​
