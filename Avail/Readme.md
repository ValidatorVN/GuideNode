# Auto Install

    wget -O avail https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Avail/avail && chmod +x avail && ./avail

# Command

SystemD

    sudo systemctl daemon-reload
    sudo systemctl enable availd
    sudo systemctl start availd


Check logs:

    sudo journalctl -u availd -f -o cat

Check node:

    https://telemetry.avail.tools/

Create wallet:

    https://goldberg.avail.tools/
