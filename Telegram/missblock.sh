#!/bin/bash

rpc_url="http://localhost:26657"
blocks_to_scan=1000

#default validator address
get_default_validator_address() {
  default_validator_address=$(curl -s "$rpc_url/status" | jq -r '.result.validator_info.address')
}

# as argument
if [ $# -eq 0 ]; then
  get_default_validator_address
  validator_addresses=("$default_validator_address")
else
  # as arguments
  IFS=',' read -ra validator_addresses <<< "$1"
fi


# latest block height
latest_block=$(curl -s "$rpc_url/status" | jq -r .result.sync_info.latest_block_height)

# start and end block heights
start_block=$((latest_block - blocks_to_scan))
end_block=$latest_block

# Initialize 
total_blocks=0
total_signed=0
total_missed=0

# Loop 
for ((block_height = start_block; block_height < end_block; block_height++)); do
  # block data
  block_data=$(curl -s "$rpc_url/block?height=$block_height")

  # validator addresses from block 
  validator_addresses_in_block=($(echo "$block_data" | jq -r '.result.block.last_commit.signatures[].validator_address'))

  # Loop 
  for address in "${validator_addresses[@]}"; do
    signed=false

    # validator address found?
    for validator_address_in_block in "${validator_addresses_in_block[@]}"; do
      if [[ "$address" == "$validator_address_in_block" ]]; then
        signed=true
        break
      fi
    done

    # Update counters 
    if $signed; then
      ((total_signed++))
    else
      ((total_missed++))
    fi
  done

  ((total_blocks++))

  printf "\rScanning Blocks... [%d/%d]" "$total_blocks" "$((end_block - start_block))"
done

echo

# display results
for address in "${validator_addresses[@]}"; do
  signed_count=0
  missed_count=0

  for ((block_height = start_block; block_height < end_block; block_height++)); do
    block_data=$(curl -s "$rpc_url/block?height=$block_height")
    validator_addresses_in_block=($(echo "$block_data" | jq -r '.result.block.last_commit.signatures[].validator_address'))

    signed=false

    for validator_address_in_block in "${validator_addresses_in_block[@]}"; do
      if [[ "$address" == "$validator_address_in_block" ]]; then
        signed=true
        break
      fi
    done

    if $signed; then
      ((signed_count++))
    else
      ((missed_count++))
    fi
  done

  ratio=$((signed_count * 100 / (signed_count + missed_count)))

   echo -e "Validator Address: $address - Signed: \033[1;33m$signed_count\033[0m, Missed: \033[1;33m$missed_count\033[0m, Ratio: \033[1;33m$ratio%\033[0m"
done

echo "Start Block: $start_block | End Block: $end_block"
