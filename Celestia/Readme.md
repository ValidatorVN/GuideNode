# Auto Install

    Wait an announcement from admin imLuuTong

# Command

Add New Key

    celestia-appd keys add wallet

Recover Existing Key

    celestia-appd keys add wallet --recover

List All Keys

    celestia-appd keys list

Delete Key

    celestia-appd keys delete wallet

Query Wallet Balance

    celestia-appd q bank balances $(celestia-appd keys show wallet -a)

Create New Validator

    celestia-appd tx staking create-validator \
    --amount=1000000utia \
    --pubkey=$(celestia-appd tendermint show-validator) \
    --moniker="Moniker" \
    --chain-id=celestia \
    --commission-rate=0.10 \
    --commission-max-rate=0.20 \
    --commission-max-change-rate=0.01 \
    --min-self-delegation=1 \
    --from=wallet \
    --gas-prices=0.1utia \
    --gas-adjustment=1.5 \
    --gas=auto \
    -y 

Unjail Validator

    celestia-appd tx slashing unjail --from wallet --chain-id celestia --gas-prices 0.1utia --gas-adjustment 1.5 --gas auto -y

Signing Info

    celestia-appd query slashing signing-info $(celestia-appd tendermint show-validator)

List All Active Validators

    celestia-appd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl

List All Inactive Validators

    celestia-appd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED") or .status=="BOND_STATUS_UNBONDING")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl

View Validator Details

    celestia-appd q staking validator $(celestia-appd keys show wallet --bech val -a)

Withdraw Rewards From All Validators

    celestia-appd tx distribution withdraw-all-rewards --from wallet --chain-id celestia --gas-prices 0.1utia --gas-adjustment 1.5 --gas auto -y

Withdraw Commission And Rewards From Your Validator

    celestia-appd tx distribution withdraw-rewards $(celestia-appd keys show wallet --bech val -a) --commission --from wallet --chain-id celestia --gas-prices 0.1utia --gas-adjustment 1.5 --gas auto -y

Delegate to yourself

    celestia-appd tx staking delegate $(celestia-appd keys show wallet --bech val -a) 1000000utia --from wallet --chain-id celestia --gas-prices 0.1utia --gas-adjustment 1.5 --gas auto -y

Delegate

    celestia-appd tx staking delegate YOUR_TO_VALOPER_ADDRESS 1000000utia --from wallet --chain-id celestia --gas-prices 0.1utia --gas-adjustment 1.5 --gas auto -y

Redelegate

    celestia-appd tx staking redelegate $(celestia-appd keys show wallet --bech val -a) YOUR_TO_VALOPER_ADDRESS 1000000utia --from wallet --chain-id celestia --gas-prices 0.1utia --gas-adjustment 1.5 --gas auto -y

Unbond

    celestia-appd tx staking unbond $(celestia-appd keys show wallet --bech val -a) 1000000utia --from wallet --chain-id celestia --gas-prices 0.1utia --gas-adjustment 1.5 --gas auto -y

Send

    celestia-appd tx bank send wallet YOUR_TO_WALLET_ADDRESS 1000000tia --from wallet --chain-id celestia --gas-prices 0.1utia --gas-adjustment 1.5 --gas auto -y

Get Validator Info

    celestia-appd status 2>&1 | jq .ValidatorInfo

Get Denom Info

    celestia-appd q bank denom-metadata -oj | jq

Get Sync Status

    celestia-appd status 2>&1 | jq .SyncInfo.catching_up

Get Latest Height

    celestia-appd status 2>&1 | jq .SyncInfo.latest_block_height

Get Peer

    echo $(celestia-appd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.celestia-app/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')

Reset Node

    celestia-appd tendermint unsafe-reset-all --home $HOME/.celestia-app --keep-addr-book

Remove Node

    sudo systemctl stop celestia-appd && sudo systemctl disable celestia-appd && sudo rm /etc/systemd/system/celestia-appd.service && sudo systemctl daemon-reload && rm -rf $HOME/.celestia-app && rm -rf aura && sudo rm -rf $(which celestia-appd)

# Service Management

Reload Services

    sudo systemctl daemon-reload

Enable Service

    sudo systemctl enable celestia-appd

Disable Service

    sudo systemctl disable celestia-appd

Run Service

    sudo systemctl start celestia-appd

Stop Service

    sudo systemctl stop celestia-appd

Restart Service

    sudo systemctl restart celestia-appd

Check Service Status

    sudo systemctl status celestia-appd

Check Service Logs

    sudo journalctl -u celestia-appd -f --no-hostname -o cat
