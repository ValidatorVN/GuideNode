# Source

    https://blog.fleek.network/post/fleek-network-testnet-phase-1/

# Auto Install

    curl https://get.fleek.network | bash

# Commmand

Start systemD

    sudo systemctl daemon-reload
    sudo systemctl start lightning.service

Restart

    sudo systemctl restart lightning

Stop

    sudo systemctl stop lightning

Backup key

    cd $HOME/.lightning/keystore

Show Node key & Consensus

    lgtn keys show
