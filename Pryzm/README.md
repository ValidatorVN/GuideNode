# Auto Install

    wget -O prz https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Pryzm/prz && chmod +x prz && ./prz

# Command

Add New Key

    pryzmd keys add wallet

Recover Existing Key

    pryzmd keys add wallet --recover

List All Keys

    pryzmd keys list

Delete Key

    pryzmd keys delete wallet

Query Wallet Balance

    pryzmd q bank balances $(pryzmd keys show wallet -a)

Sync info

    pryzmd status 2>&1 | jq .SyncInfo

Check logs

    sudo journalctl -fu pryzmd -o cat

Create New Validator: *** replace "Moniker" -> YourName ***

    pryzmd tx staking create-validator \
    --amount 1000000upryzm \
    --from wallet \
    --commission-rate 0.1 \
    --commission-max-rate 0.2 \
    --commission-max-change-rate 0.01 \
    --min-self-delegation 1 \
    --pubkey $(pryzmd tendermint show-validator) \
    --moniker "Moniker" \
    --chain-id indigo-1 \
    --fees 3000upryzm \
    -y

Delete node

    sudo systemctl stop pryzmd && sudo systemctl disable pryzmd && sudo rm /etc/systemd/system/pryzmd.service && sudo systemctl daemon-reload && rm -rf $HOME/.pryzm && rm -rf pryzm && sudo rm -rf $(which pryzmd)
