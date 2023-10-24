# About Mantra Node Testnet

    https://twitter.com/MANTRA_Chain
    https://discord.gg/gfenCRGT

# Auto Install

    wget -O mantra https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Mantra/mantra && chmod +x mantra && ./mantra


# Key Management

Add new key

    mantrachaind keys add wallet

Faucet Mantra

    https://faucet.testnet.mantrachain.io/

Recover existing key

    mantrachaind keys add wallet --recover

List All key

    mantrachaind keys list

Delete key

    mantrachaind keys delete wallet

Query Wallet Balance

    mantrachaind q bank balances $(mantrachaind keys show wallet -a)

5/ Create a validator

    mantrachaind tx staking create-validator \
    --amount "1000000uaum" \
    --pubkey $(mantrachaind tendermint show-validator) \
    --moniker "MONIKER" \
    --identity "KEYBASE_ID" \
    --details "YOUR DETAILS" \
    --website "YOUR WEBSITE" \
    --chain-id mantrachain-1 \
    --commission-rate "0.05" \
    --commission-max-rate "0.20" \
    --commission-max-change-rate "0.01" \
    --min-self-delegation "1" \
    --gas-prices "0uaum" \
    --gas "auto" \
    --gas-adjustment "1.5" \
    --from wallet \
    -y

Node & Validator VietNam News

    Github: https://github.com/NodeValidatorVN
    X: https://x.com/NodeValidatorVN
    Linktree: https://linktr.ee/validatorvn
