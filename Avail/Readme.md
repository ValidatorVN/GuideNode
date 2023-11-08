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

Get key for active Validator:

    curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "author_rotateKeys", "params":[]}' http://localhost:9944
