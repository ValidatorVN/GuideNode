# Auto Install

    wget -O bbl https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Babylon/bbl && chmod +x bbl && ./bbl

# Create wallet & validator

Wallet

    babylond config chain-id bbn-test-2
    babylond config keyring-backend test
    babylond keys add wallet
    
Validator

    babylond tx checkpointing create-validator \
    --amount 1000000ubbn \
    --pubkey $(babylond tendermint show-validator) \
    --moniker "Validator" \
    --chain-id bbn-test-2 \
    --commission-rate 0.05 \
    --commission-max-rate 0.20 \
    --commission-max-change-rate 0.01 \
    --min-self-delegation 1 \
    --from wallet \
    --gas-adjustment 1.4 \
    --gas auto \
    --fees 10ubbn \
    -y

