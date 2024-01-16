# Auto Install

    wget -O blx https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Blockx/blx && chmod +x blx && ./blx

# Command

Add New Key

    blockxd keys add wallet

Recover Existing Key

    blockxd keys add wallet --recover

List All Keys

    blockxd keys list

Delete Key

    blockxd keys delete wallet

Export Key (save to wallet.backup)

    blockxd keys export wallet

Import Key

    blockxd keys import wallet wallet.backup

Query Wallet Balance

    blockxd q bank balances $(aurad keys show wallet -a)

Create New Validator

    blockxd tx staking create-validator \
    --amount=1000000uaura \
    --pubkey=$(blockxd tendermint show-validator) \
    --moniker="Moniker" \
    --chain-id=blockx_100-1 \
    --commission-rate=0.10 \
    --commission-max-rate=0.20 \
    --commission-max-change-rate=0.01 \
    --min-self-delegation=1 \
    --from=wallet \
    --gas-prices=0.1abcx \
    --gas-adjustment=1.5 \
    --gas=auto \
    -y 

Edit Existing Validator

    blockxd tx staking edit-validator \
    --new-moniker="Moniker" \
    --chain-id=blockx_100-1 \
    --commission-rate=0.1 \
    --from=wallet \
    --gas-prices=0.1abcx \
    --gas-adjustment=1.5 \
    --gas=auto \
    -y 

Unjail Validator

    blockxd tx slashing unjail --from wallet --chain-id blockx_100-1 --gas-prices 0.1uaura --gas-adjustment 1.5 --gas auto -y

Signing Info

    blockxd query slashing signing-info $(blockxd tendermint show-validator)

List All Active Validators

    blockxd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl

List All Inactive Validators

    blockxd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED") or .status=="BOND_STATUS_UNBONDING")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl

View Validator Details

    blockxd q staking validator $(blockxd keys show wallet --bech val -a)

Withdraw Rewards From All Validators

    blockxd tx distribution withdraw-all-rewards --from wallet --chain-id blockx_100-1 --gas-prices 0.1uaura --gas-adjustment 1.5 --gas auto -y

Withdraw Commission And Rewards From Your Validator

    blockxd tx distribution withdraw-rewards $(aurad keys show wallet --bech val -a) --commission --from wallet --chain-id blockx_100-1 --gas-prices 0.1abcx --gas-adjustment 1.5 --gas auto -y

Delegate to yourself

    blockxd tx staking delegate $(blockxd keys show wallet --bech val -a) 1000000abcx --from wallet --chain-id blockx_100-1 --gas-prices 0.1abcx --gas-adjustment 1.5 --gas auto -y

Delegate

    blockxd tx staking delegate YOUR_TO_VALOPER_ADDRESS 1000000abcx --from wallet --chain-id blockx_100-1 --gas-prices 0.1abcx --gas-adjustment 1.5 --gas auto -y

Redelegate

    blockxd tx staking redelegate $(blockxd keys show wallet --bech val -a) YOUR_TO_VALOPER_ADDRESS 1000000abcx --from wallet --chain-id blockx_100-1 --gas-prices 0.1abcx --gas-adjustment 1.5 --gas auto -y

Unbond

    blockxd tx staking unbond $(blockxd keys show wallet --bech val -a) 1000000abcxa --from wallet --chain-id blockx_100-1 --gas-prices 0.1abcx --gas-adjustment 1.5 --gas auto -y

Send

    blockxd tx bank send wallet YOUR_TO_WALLET_ADDRESS 1000000abcx --from wallet --chain-id blockx_100-1 --gas-prices 0.1abcx --gas-adjustment 1.5 --gas auto -y

