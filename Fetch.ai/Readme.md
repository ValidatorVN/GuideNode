# Auto Install

    wget -O fet https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Fetch.ai/fet && chmod +x fet && ./fet

# Command

Add new key

    fetchd keys add wallet

Recover existing key

    fetchd keys add wallet --recover

List All key

    fetchd keys list

Delete key

    fetchd keys delete wallet

Query Wallet Balance

    fetchd q bank balances $(fetchd keys show wallet -a)

Create Validator

    fetchd tx staking create-validator \
    --amount "1000000afet" \
    --pubkey $(fetchd tendermint show-validator) \
    --moniker "MONIKER" \
    --identity "KEYBASE_ID" \
    --details "YOUR DETAILS" \
    --website "YOUR WEBSITE" \
    --chain-id fetchhub-4 \
    --commission-rate "0.05" \
    --commission-max-rate "0.20" \
    --commission-max-change-rate "0.01" \
    --min-self-delegation "1" \
    --gas-prices "200000afet" \
    --gas "auto" \
    --gas-adjustment "1.5" \
    --from wallet \
    -y

Withdraw reward

    fetchd tx distribution withdraw-all-rewards --from wallet --chain-id fetchhub-4 --gas-prices 200000afet --gas-adjustment 1.5 --gas auto -y
