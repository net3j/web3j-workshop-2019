#!/usr/bin/env bash

set -e
set -o pipefail

baseDir="../src/main/resources/solidity"

targets="
greeter/Greeter
"

for target in ${targets}; do
    dirName=$(dirname "${target}")
    fileName=$(basename "${target}")

    cd $baseDir
    echo "Compiling Solidity file ${target}.sol"

    solc --bin --abi --optimize --overwrite \
            --allow-paths "$(pwd)" \
            ${dirName}/${fileName}.sol -o ${dirName}/build/
    echo "Complete"

    echo "Generating contract bindings"
    web3j solidity generate \
        -b ${dirName}/build/${fileName}.bin \
        -a ${dirName}/build/${fileName}.abi \
        -p io.blk.contracts.generated \
        -o ../../java/ > /dev/null
    echo "Complete"

    cd -
done
