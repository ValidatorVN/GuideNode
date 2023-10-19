# Auto Install

    wget -O aura https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/AuraNetwork/aura && chmod +x aura && ./aura

# Command

Add New Key

        aurad keys add wallet

Recover Existing Key

        aurad keys add wallet --recover

List All Keys

        aurad keys list

Delete Key

        aurad keys delete wallet

Query Wallet Balance

        aurad q bank balances $(aurad keys show wallet -a)

Create New Validator

        aurad tx staking create-validator \
        --amount=1000000uaura \
        --pubkey=$(aurad tendermint show-validator) \
        --moniker="Moniker" \
        --chain-id=xstaxy-1 \
        --commission-rate=0.10 \
        --commission-max-rate=0.20 \
        --commission-max-change-rate=0.01 \
        --min-self-delegation=1 \
        --from=wallet \
        --gas-prices=0.1uaura \
        --gas-adjustment=1.5 \
        --gas=auto \
        -y 
