# Auto Install

    wget -O entangle https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Entangle/entangle && chmod +x entangle && ./entangle

# Command

Add new key

        entangled keys add wallet

Recover existing key

        entangled keys add wallet --recover

List All key

        entangled keys list

Delete key

        entangled keys delete wallet

Query Wallet Balance

        entangled q bank balances $(entangled keys show wallet -a)

Create Validator

        entangled tx staking create-validator \
        --amount "1000000000000000000aNGL" \
        --pubkey $(entangled tendermint show-validator) \
        --moniker "MONIKER" \
        --chain-id entangle_33133-1 \
        --commission-rate "0.05" \
        --commission-max-rate "0.20" \
        --commission-max-change-rate "0.01" \
        --min-self-delegation "1" \
        --gas-prices "10aNGL" \
        --gas "500000" \
        --gas-adjustment "1.5" \
        --from wallet \
        -y
