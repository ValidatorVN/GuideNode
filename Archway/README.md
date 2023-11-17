# Auto Install

    wget -O arch https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Archway/arch && chmod +x arch && ./arch

# Command

Add New Key

    archwayd keys add wallet

Recover Existing Key

    archwayd keys add wallet --recover

List All Keys

    archwayd keys list

Delete Key

    archwayd keys delete wallet

Export Key (save to wallet.backup)

    archwayd keys export wallet

Import Key

    archwayd keys import wallet wallet.backup

Query Wallet Balance

    archwayd q bank balances $(archwayd keys show wallet -a)

Unjail Validator

    archwayd tx slashing unjail --from wallet --chain-id archway-1 --gas-prices 0archway --gas-adjustment 1.5 --gas auto -y

Delegate to yourself

    archwayd tx staking delegate $(archwayd keys show wallet --bech val -a) 1000000archway --from wallet --chain-id archway-1 --gas-prices 0archway --gas-adjustment 1.5 --gas auto -y

Reload systemD

    sudo systemctl enable archwayd 
    sudo systemctl daemon-reload
    sudo systemctl restart archwayd && journalctl -u archwayd -f --no-hostname -o cat

Get Sync Status

    archwayd status 2>&1 | jq .SyncInfo.catching_up

Get Latest Height

    archwayd status 2>&1 | jq .SyncInfo.latest_block_height

Create a validator

    archwayd tx staking create-validator \
    --amount 500000000000aarch \
    --pubkey $(archwayd tendermint show-validator) \
    --moniker "Name" \
    --chain-id archway-1 \
    --commission-rate 0.05 \
    --commission-max-rate 0.20 \
    --commission-max-change-rate 0.01 \
    --min-self-delegation 1 \
    --from=wallet \
    --gas-adjustment 1.4 \
    --gas auto \
    --gas-prices 1000000000000aarch \
    -y
