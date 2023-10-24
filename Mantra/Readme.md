#About Mantra Node Testnet

    https://twitter.com/MANTRA_Chain
    https://discord.gg/gfenCRGT

# Auto Install

    wget -O mantra https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/AuraNetwork/mantra && chmod +x mantra && ./mantra

1/ Manual Installation

    sudo apt update && sudo apt upgrade -y
    sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

2/ Go Install

    ver="1.20.5"
    wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
    rm "go$ver.linux-amd64.tar.gz"
    echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
    source $HOME/.bash_profile
    go version

3/ Node Install

    # Download and install binary
    cd $HOME
    wget https://github.com/MANTRA-Finance/public/raw/main/mantrachain-testnet/mantrachaind-linux-amd64.zip
    unzip mantrachaind-linux-amd64.zip
    sudo mv mantrachaind /usr/local/bin


    # Set Configuration for your node
    mantrachaind config chain-id mantrachain-1
    mantrachaind config keyring-backend file


    # Init your node
    # You can change "Moniker" to anything you like
    mantrachaind init "Moniker" --chain-in mantrachain-1


    # Set Pruning, Enable Prometheus, Gas Prices, and Indexer
    PRUNING="custom"
    PRUNING_KEEP_RECENT="100"
    PRUNING_INTERVAL="10"

    sed -i -e "s/^pruning *=.*/pruning = \"$PRUNING\"/" $HOME/.mantrachain/config/app.toml
    sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \
    \"$PRUNING_KEEP_RECENT\"/" $HOME/.mantrachain/config/app.toml
    sed -i -e "s/^pruning-interval *=.*/pruning-interval = \
    \"$PRUNING_INTERVAL\"/" $HOME/.mantrachain/config/app.toml
    sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.mantrachain/config/config.toml
    sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.mantrachain/config/config.toml
    sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uaum\"/" $HOME/.mantrachain/config/app.toml

    # Set Service file
    sudo tee /etc/systemd/system/mantrachaind.service > /dev/null <<EOF
    [Unit]
    Description=Mantra Node
    After=network-online.target
    [Service]
    User=$USER
    ExecStart=$(which mantrachaind) start
    Restart=always
    RestartSec=3
    LimitNOFILE=65535
    [Install]
    WantedBy=multi-user.target
    EOF
    sudo systemctl daemon-reload
    sudo systemctl enable mantrachaind


    # Start the Node

    mantrachain tendermint unsafe-reset-all --home $HOME/.mantrachain
    sudo systemctl restart mantrachaind
    sudo journalctl -fu mantrachaind -o cat

4/ Key Management

Add new key

    mantrachaind keys add wallet

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
