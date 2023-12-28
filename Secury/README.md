# Install package

    sudo apt -q update
    sudo apt -qy install curl git jq lz4 build-essential fail2ban ufw
    sudo apt -qy upgrade

# Add user & enable ufw

    sudo adduser node --disabled-password -q
    sudo usermod -aG sudo node
    sudo -u node bash -c 'mkdir -p ~/.ssh && echo "YOUR_PUBLIC_SSH_KEY" >> ~/.ssh/authorized_keys && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys'
    echo "node ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
    su - node -c 'sudo sed -i "s|^PermitRootLogin .*|PermitRootLogin no|" /etc/ssh/sshd_config'
    su - node -c 'sudo sed -i "s|^ChallengeResponseAuthentication .*|ChallengeResponseAuthentication no|" /etc/ssh/sshd_config'
    su - node -c 'sudo sed -i "s|^#PasswordAuthentication .*|PasswordAuthentication no|" /etc/ssh/sshd_config'
    su - node -c 'sudo sed -i "s|^#PermitEmptyPasswords .*|PermitEmptyPasswords no|" /etc/ssh/sshd_config'
    su - node -c 'sudo sed -i "s|^#PubkeyAuthentication .*|PubkeyAuthentication yes|" /etc/ssh/sshd_config'
    sudo systemctl restart sshd
    sudo apt install -y ufw
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    sudo ufw enable
