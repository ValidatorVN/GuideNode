# Source

    https://blog.fleek.network/post/fleek-network-testnet-phase-1/

# Package Install

    sudo apt-get install \
    build-essential \
    clang \
    pkg-config \
    libssl-dev \
    gcc-multilib \
    protobuf-compiler

# Add User

    sudo adduser lgtn
    sudo usermod -aG sudo lgtn
    su lgtn
    cd /home/lgtn

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
