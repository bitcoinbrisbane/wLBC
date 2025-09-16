// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {wLBC} from "../src/wLBC.sol";

contract DeploywLBC is Script {
    // Default deployment parameters
    uint256 public constant DEFAULT_INITIAL_SUPPLY = 21_000_000; // 21 million tokens (same as LBRY Credits max supply)
    uint8 public constant DEFAULT_DECIMALS = 8; // LBRY Credits use 8 decimals

    function setUp() public {}

    function run() public {
        // Get deployment parameters from environment variables or use defaults
        uint256 initialSupply = vm.envOr("INITIAL_SUPPLY", DEFAULT_INITIAL_SUPPLY);
        uint8 decimals = uint8(vm.envOr("TOKEN_DECIMALS", uint256(DEFAULT_DECIMALS)));
        
        console.log("Deploying wLBC with:");
        console.log("Initial Supply:", initialSupply);
        console.log("Decimals:", decimals);
        console.log("Deployer:", msg.sender);

        vm.startBroadcast();

        wLBC token = new wLBC(initialSupply, decimals);

        vm.stopBroadcast();

        console.log("wLBC deployed at:", address(token));
        console.log("Name:", token.name());
        console.log("Symbol:", token.symbol());
        console.log("Total Supply:", token.totalSupply());
        console.log("Owner:", token.owner());
    }

    function runWithCustomParams(uint256 initialSupply, uint8 decimals) public {
        console.log("Deploying wLBC with custom parameters:");
        console.log("Initial Supply:", initialSupply);
        console.log("Decimals:", decimals);
        console.log("Deployer:", msg.sender);

        vm.startBroadcast();

        wLBC token = new wLBC(initialSupply, decimals);

        vm.stopBroadcast();

        console.log("wLBC deployed at:", address(token));
        console.log("Name:", token.name());
        console.log("Symbol:", token.symbol());
        console.log("Total Supply:", token.totalSupply());
        console.log("Owner:", token.owner());
    }
}
