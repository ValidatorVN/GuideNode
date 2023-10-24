# Auto Install

    Wait an announcement from admin imLuuTong

# Command

Add New Key

    celestia-appd keys add wallet

Recover Existing Key

    celestia-appd keys add wallet --recover

List All Keys

    celestia-appd keys list

Delete Key

    celestia-appd keys delete wallet

Query Wallet Balance

    celestia-appd q bank balances $(celestia-appd keys show wallet -a)

Create New Validator

celestia-appd tx staking create-validator \
--amount=1000000utia \
--pubkey=$(celestia-appd tendermint show-validator) \
--moniker="Moniker" \
--chain-id=celestia \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=wallet \
--gas-prices=0.1utia \
--gas-adjustment=1.5 \
--gas=auto \
-y 
