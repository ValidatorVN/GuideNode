# Auto Install

    wget -O xprt https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Persistence/xprt && chmod +x xprt && ./xprt

# Command
Add New Key

    persistenceCore keys add wallet

Recover Existing Key

    persistenceCore keys add wallet --recover

List All Keys

    persistenceCore keys list

Delete Key

    persistenceCore keys delete wallet

Query Wallet Balance

    persistenceCore q bank balances $(aurad keys show wallet -a)

Create New Validator

    persistenceCore tx staking create-validator \
    --amount=1000000uxprt \
    --pubkey=$(persistenceCore tendermint show-validator) \
    --moniker="Moniker" \
    --chain-id=core-1 \
    --commission-rate=0.10 \
    --commission-max-rate=0.20 \
    --commission-max-change-rate=0.01 \
    --min-self-delegation=1 \
    --from=wallet \
    --gas-prices=0.01uxprt \
    --gas-adjustment=1.5 \
    --gas=auto \
    -y
