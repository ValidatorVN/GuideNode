# Auto Install

    wget -O dym https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Dymension/dym && chmod +x dym && ./dym

# Command

Add New Key

    dymd keys add wallet

Recover Existing Key

    dymd keys add wallet --recover

List All Keys

    dymd keys list

Delete Key

    dymd keys delete wallet

Export Key (save to wallet.backup)

    dymd keys export wallet

Import Key

    dymd keys import wallet wallet.backup

Query Wallet Balance

    dymd q bank balances $(dymd keys show wallet -a)

Create New Validator

    dymd tx staking create-validator \
    --amount=1000000udym \
    --pubkey=$(dymd tendermint show-validator) \
    --moniker="Moniker" \
    --chain-id=froopyland_100-1 \
    --commission-rate=0.1 \
    --commission-max-rate=0.3 \
    --commission-max-change-rate=0.05 \
    --min-self-delegation=1 \
    --from=wallet \
    --gas-prices=0.1udym \
    --gas-adjustment=1.5 \
    --gas=auto \
    -y 
