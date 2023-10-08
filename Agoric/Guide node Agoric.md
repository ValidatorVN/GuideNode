1/ Install Golang, GCC, Nodejs, Yarn.

    Golang >= 1.20.5
    GCC >= 9.x
    Nọdejs >= 16
    Yarn >= 1.22.2
    Network Type: mainnet
    Chain ID: agoric-3

2/ Node Install:

    git clone https://github.com/agoric/agoric-sdk.git
    cd agoric-sdk
    git fetch --all
    git checkout agoric-upgrade-11
    yarn install
    yarn build
    cd packages/cosmic-swingset && make

3/ SystemD:

a/

    sudo tee /etc/systemd/system/agoricd.service > /dev/null << EOF
    [Unit]
    Description=Agoric Node
    After=network-online.target
    [Service]
    User=$USER
    ExecStart=$(which agoricd) start
    Restart=on-failure
    RestartSec=10
    LimitNOFILE=65536
    [Install]
    WantedBy=multi-user.target
    EOF

b/

    agoricd tendermint unsafe-reset-all --home $HOME/.agoric --keep-addr-book

c/

    sudo systemctl daemon-reload
    sudo systemctl enable agoricd
    sudo systemctl start agoricd

    sudo journalctl -u agoricd -f --no-hostname -o cat

4/ Wallet:

    agd keys add wallet

    agd keys add wallet --recover

    agd q bank balances $(agd keys show wallet -a)

5/ Create a validator:

    aurad tx staking create-validator \
    --amount=1000000ubld \
    --pubkey=$(agd tendermint show-validator) \
    --moniker="Moniker" \
    --identity="your keybase" \
    --details="your details" \
    --chain-id=agoric-3 \
    --commission-rate=0.10 \
    --commission-max-rate=0.20 \
    --commission-max-change-rate=0.01 \
    --min-self-delegation=1 \
    --from=wallet \
    --gas-prices=0.1ubld \
    --gas-adjustment=1.5 \
    --gas=auto \
    -y

6/ Chanel:

    Node & Validator VietNam News
    Chat: https://t.me/NodeValidatorVN
    Github: https://github.com/NodeValidatorVN
    X: https://x.com/NodeValidatorVN
    Linktree: https://linktr.ee/validatorvn
