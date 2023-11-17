# Auto install

    wget -O ctk https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Shentu/ctk && chmod +x ctk && ./ctk

# Command

Add New Key

    shentud keys add wallet

Recover Existing Key

    shentud keys add wallet --recover

List All Keys

    shentud keys list

Delete Key

    shentud keys delete wallet

Export Key (save to wallet.backup)

    shentud keys export wallet

Import Key

    shentud keys import wallet wallet.backup

Query Wallet Balance

    shentud q bank balances $(shentud keys show wallet -a)

Unjail Validator

    shentud tx slashing unjail --from wallet --chain-id shentu-2.2 --gas-prices 0uctk --gas-adjustment 1.5 --gas auto -y

Withdraw rewards & commission validator

    shentud tx distribution withdraw-rewards $(shentud keys show wallet --bech val -a) --commission --from wallet --chain-id shentu-2.2 --gas-prices 0uctk --gas-adjustment 1.5 --gas auto -y 

Delegate to yourself

    shentud tx staking delegate $(shentud keys show wallet --bech val -a) 1000000uctk --from wallet --chain-id shentu-2.2 --gas-prices 0uctk --gas-adjustment 1.5 --gas auto -y

Edit Existing Validator

    shentud tx staking edit-validator \
    --new-moniker="Moniker" \
    --chain-id=shentu-2.2 \
    --commission-rate=0.1 \
    --from=wallet \
    --gas-prices=0uctk \
    --gas-adjustment=1.5 \
    --gas=auto \
    -y

Reload systemD

    sudo systemctl enable shentud 
    sudo systemctl daemon-reload
    sudo systemctl restart shentud && journalctl -u shentud -f --no-hostname -o cat
    
Get Sync Status

    shentud status 2>&1 | jq .SyncInfo.catching_up

Get Latest Height

    shentud status 2>&1 | jq .SyncInfo.latest_block_height
