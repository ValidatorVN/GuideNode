Hi @everyone It is now time to spin up your Mainnet Goracle node!!! Thank you all for the patience and participation. 

You can follow any of these instruction options below to register your Mainnet node. The process shown is for Testnet, however, it is nearly identical to the Mainnet node setup so this should hopefully be a pretty simple process for everyone. The only difference is to ensure your Algorand node is set to Mainnet and use ./goracle init for Mainnet, as opposed to ./goracle init --network testnet that was used to set up testnet.

Video: Node setup and Validator portal registration: https://www.youtube.com/watch?v=UftAEHUCHvo (note: this is for testnet but the steps are exactly the same)

Written Instructions: Step-by-step written walkthrough is attached. (note: these are the same instructions provided for Testnet, however, the process is nearly identical. 

Quick Guide:

1. Go to https://app.goracle.io/validators to begin registering your validator. 

2. wget -N https://download.goracle.io/latest-release/linux/goracle to pull in the latest binary

3. chmod u+x goracle to change permissions to executable

4. ./goracle init to initialize the binary for mainnet

5. After running through the initialization prompts and completing registration via the validator portal, run ./goracle docker-start --background to run the node in the background. If you get a Docker error, please make sure you have set up a Docker user group. 

Additionally, just a reminder to set Algorand nodes to Mainnet and fund your participation account with a small amount of ALGO token.
