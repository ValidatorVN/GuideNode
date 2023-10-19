# Auto Install

    wget -O bitcana https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Bitcana/bitcana && chmod +x bitcana && ./bitcana

# Command

Add new key

    bcnad keys add wallet

Recover existing key

    bcnad keys add wallet --recover

List All key

    bcnad keys list

Delete key
    
    bcnad keys delete wallet

Query Wallet Balance

    bcnad q bank balances $(bcnad keys show wallet -a)

Create Validator

    bcnad tx staking create-validator \
    --amount "1000000ubcna" \
    --pubkey $(bcnad tendermint show-validator) \
    --moniker "MONIKER" \
    --identity "KEYBASE_ID" \
    --details "YOUR DETAILS" \
    --website "YOUR WEBSITE" \
    --chain-id bitcanna-1 \
    --commission-rate "0.05" \
    --commission-max-rate "0.20" \
    --commission-max-change-rate "0.01" \
    --min-self-delegation "1" \
    --gas-prices "0ubcna" \
    --gas "auto" \
    --gas-adjustment "1.5" \
    --from wallet \
    -y
