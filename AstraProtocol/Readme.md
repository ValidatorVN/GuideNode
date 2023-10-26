# Auto Install

    wget -O astra https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/AstraProtocol/astra && chmod +x astra && ./astra

# Command

Add New Key

    astrad keys add wallet

Recover Existing Key

    astrad keys add wallet --recover

List All Keys

    astrad keys list

Delete Key

    astrad keys delete wallet

Query Wallet Balance

    astrad q bank balances $(astrad keys show wallet -a)

Create New Validator

    astrad tx staking create-validator \
    --amount=1000000000000000000000aastra \
    --pubkey=$(astrad tendermint show-validator) \
    --moniker="Moniker" \
    --chain-id=astra_11110-1 \
    --commission-rate=0.10 \
    --commission-max-rate=0.20 \
    --commission-max-change-rate=0.01 \
    --min-self-delegation=1 \
    --from=wallet \
    --fees 30000000000000000aastra \
    --gas=auto \
    -y 

Withdraw Commission And Rewards From Your Validator

    astrad tx distribution withdraw-rewards $(astrad keys show wallet --bech val -a) --commission --from wallet --chain-id astra_11110-1 --fees 30000000000000000aastra --gas=auto -y 

Delegate to your self

    astrad tx staking delegate $(astrad keys show wallet --bech val -a) aastra --from wallet --chain-id astra_11110-1 --fees 30000000000000000aastra --gas=auto -y
