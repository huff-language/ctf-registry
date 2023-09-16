// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {HuffCTFRegistry} from "../src/HuffCTFRegistry.sol";
import {Script, console2 as console} from "forge-std/Script.sol";

contract HuffCTFRegistryScript is Script {
    function setUp() public {}

    //forge script script/HuffCTFRegistryScript.s.sol:HuffCTFRegistryScript --rpc-url $OPTIMISM_RPC --broadcast --verify -vvvv

    function run() public {
        vm.broadcast();
        address deployed = address(new HuffCTFRegistry());
        console.log("HuffCTFRegistry deployed at address: ", deployed);
    }
}
