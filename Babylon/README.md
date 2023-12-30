# Auto Install

    wget -O bbl https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Babylon/bbl && chmod +x bbl && ./bbl

# Create wallet & validator

Wallet

    babylond keys add wallet
    
Validator

    babylond tx staking create-validator \
    --amount=1000000ubbn \
    --pubkey=$(babylond tendermint show-validator) \
    --moniker="Moniker" \
    --chain-id=bbn-test-2 \
    --commission-rate=0.10 \
    --commission-max-rate=0.20 \
    --commission-max-change-rate=0.01 \
    --min-self-delegation=1 \
    --from=wallet \
    --gas-prices=0.1ubbn \
    --gas-adjustment=1.5 \
    --gas=auto \
    -y
