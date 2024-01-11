# Auto Install

    wget -O art https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Artela/art && chmod +x art && ./art

Creat a wallet

    artelad keys add wallet

Export wallet -> private key -> Import metamask

    artelad keys unsafe-export-eth-key wallet

Create a validator

    artelad tx staking create-validator --amount 900000000000000000uart --pubkey $(artelad tendermint show-validator) --moniker "Moniker" --chain-id artela_11822-1 --commission-rate 0.1 --commission-max-rate 0.20 --commission-max-change-rate 0.05 --min-self-delegation 1 --from wallet --gas-adjustment 1.4 --gas auto --gas-prices 200000uart -y

Delegate to yourself

    artelad tx staking delegate $(artelad keys show wallet --bech val -a) 1000000000000000000uart --from wallet --chain-id artela_11822-1 --gas-adjustment 1.4 --gas auto --gas-prices 200000uart -y
