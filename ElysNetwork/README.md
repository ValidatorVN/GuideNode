# Auto Install

    wget -O ely https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/ElysNetwork/ely && chmod +x ely && ./ely
    
# Command

Add New Key

    elysd keys add wallet

Recover Existing Key

    elysd keys add wallet --recover

List All Keys

    elysd keys list

Delete Key

    elysd keys delete wallet

Query Wallet Balance

    elysd q bank balances $(elysd keys show wallet -a)

Create New Validator

    elysd tx staking create-validator \
    --amount=1000000uelys \
    --pubkey=$(elysd tendermint show-validator) \
    --moniker="Moniker" \
    --chain-id=elystestnet-1 \
    --commission-rate=0.10 \
    --commission-max-rate=0.20 \
    --commission-max-change-rate=0.01 \
    --min-self-delegation=1 \
    --from=wallet \
    --gas-prices=0.00025uelys \
    --gas-adjustment=1.5 \
    --gas=auto \
    -y 

Unjail Validator

    elysd tx slashing unjail --from wallet --chain-id elystestnet-1 --gas-prices 0.00025uelys --gas-adjustment 1.5 --gas auto -y

Withdraw Rewards From All Validators

    elysd tx distribution withdraw-all-rewards --from wallet --chain-id elystestnet-1 --gas-prices 0.00025uelys --gas-adjustment 1.5 --gas auto -y

Withdraw Commission And Rewards From Your Validator

    elysd tx distribution withdraw-rewards $(elysd keys show wallet --bech val -a) --commission --from wallet --chain-id elystestnet-1 --gas-prices 0.00025uelys --gas-adjustment 1.5 --gas auto -y

Delegate to yourself

    elysd tx staking delegate $(elysd keys show wallet --bech val -a) 1000000elys --from wallet --chain-id elystestnet-1 --gas-prices 0.00025uelys --gas-adjustment 1.5 --gas auto -y

Get Validator Info

    elysd status 2>&1 | jq .ValidatorInfo

Get Denom Info

    elysd q bank denom-metadata -oj | jq

Get Sync Status

    elysd status 2>&1 | jq .SyncInfo.catching_up

Get Latest Height

    elysd status 2>&1 | jq .SyncInfo.latest_block_height

Get Peer

    echo $(elysd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.elys/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')

Reset Node

    elysd tendermint unsafe-reset-all --home $HOME/.elys --keep-addr-book

Remove Node

    sudo systemctl stop elysd && sudo systemctl disable elysd && sudo rm /etc/systemd/system/elysd.service && sudo systemctl daemon-reload && rm -rf $HOME/.elys && rm -rf aura && sudo rm -rf $(which elysd)

# Service Management

Reload Services

    sudo systemctl daemon-reload

Enable Service

    sudo systemctl enable elysd

Disable Service

    sudo systemctl disable elysd

Run Service

    sudo systemctl start elysd

Stop Service

    sudo systemctl stop elysd

Restart Service

    sudo systemctl restart elysd

Check Service Status

    sudo systemctl status elysd

Check Service Logs

    sudo journalctl -u elysd -f --no-hostname -o cat
