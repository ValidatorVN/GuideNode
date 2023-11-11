# Auto Install

    wget -O tgl https://raw.githubusercontent.com/NodeValidatorVN/GuideNode/main/Tangle/tgl && chmod +x tgl && ./tgl

# Command

SystemD

    sudo systemctl daemon-reload
    sudo systemctl enable tangle
    sudo systemctl restart tangle


Check logs:

    sudo journalctl -u tangle -f -o cat

Check node:

    https://telemetry.polkadot.io/#list/0xea63e6ac7da8699520af7fb540470d63e48eccb33f7273d2e21a935685bf1320

Create wallet:

    https://polkadot.js.org/apps/?rpc=wss%253A%252F%252Frpc.tangle.tools&ref=blog.webb.tools#/staking

Get key for active Validator:

    curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "author_rotateKeys", "params":[]}' http://localhost:9933
