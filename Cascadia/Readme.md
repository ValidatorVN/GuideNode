# Auto Install

    wget -O cascadia https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Cascadia/cascadia && chmod +x cascadia && ./cascadia

# Command:

Add New Key

    cascadiad keys add wallet

Recover Existing Key

    cascadiad keys add wallet --recover

List All Keys

    cascadiad keys list

Delete Key

    cascadiad keys delete wallet

Query Wallet Balance

    cascadiad q bank balances $(cascadiad keys show wallet -a)

Create New Validator

    cascadiad tx staking create-validator \
    --amount=1000000aCC \
    --pubkey=$(cascadiad tendermint show-validator) \
    --moniker="Moniker" \
    --chain-id=cascadia_6102-1 \
    --commission-rate=0.10 \
    --commission-max-rate=0.20 \
    --commission-max-change-rate=0.01 \
    --min-self-delegation=1 \
    --from=wallet \
    --gas-prices=7aCC \
    --gas-adjustment=1.9 \
    --gas=auto \
    -y 
