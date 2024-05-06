---
description: Secure Server Setup
cover: .gitbook/assets/teamplate yTB-02.png
coverY: 64
layout:
  cover:
    visible: true
    size: hero
  title:
    visible: true
  description:
    visible: true
  tableOfContents:
    visible: true
  outline:
    visible: true
  pagination:
    visible: true
---

# ⛓️ Testnet Network

**generate ssh keys**

```
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub # "your public key"
```

**add new node user**

```
sudo adduser node --disabled-password -q

# upload public ssh key

mkdir /home/node/.ssh
echo "your public key" >> /home/node/.ssh/authorized_keys
sudo chown node: /home/node/.ssh
sudo chown node: /home/node/.ssh/authorized_keys

# disable root login

sudo sed -i 's|^PermitRootLogin .*|PermitRootLogin no|' /etc/ssh/sshd_config
sudo sed -i 's|^ChallengeResponseAuthentication .*|ChallengeResponseAuthentication no|' /etc/ssh/sshd_config
sudo sed -i 's|^#PasswordAuthentication .*|PasswordAuthentication no|' /etc/ssh/sshd_config
sudo sed -i 's|^#PermitEmptyPasswords .*|PermitEmptyPasswords no|' /etc/ssh/sshd_config
sudo sed -i 's|^#PubkeyAuthentication .*|PubkeyAuthentication yes|' /etc/ssh/sshd_config

sudo systemctl restart sshd

# enable firewall

sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw allow ssh
sudo ufw allow 9100
sudo ufw allow 26656
sudo ufw enable
```
