// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {Boxv2} from "../src/Boxv2.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

// Minimal interface for the ERC1967Proxy upgrade functionality
interface IERC1967Proxy {
    function upgradeTo(address newImplementation) external;
}

contract UpgradeBox is Script {
    function run() external returns (address) {
        // Get the most recently deployed proxy contract address
        address mostRecentlyDeployedProxy = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        // Deploy the new implementation of Boxv2
        vm.startBroadcast();
        Boxv2 newBox = new Boxv2();
        vm.stopBroadcast();

        // Upgrade the proxy to use the new implementation
        address proxy = upgradeBox(mostRecentlyDeployedProxy, address(newBox));
        return proxy;
    }

    function upgradeBox(address proxyAddress, address newBox) public returns (address) {
        // Cast the proxy address to the IERC1967Proxy interface
        IERC1967Proxy proxy = IERC1967Proxy(proxyAddress);
        
        // Broadcast the upgrade transaction
        vm.startBroadcast();
        proxy.upgradeTo(newBox);
        vm.stopBroadcast();

        return proxyAddress;
    }
}
