// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {Boxv1} from "src/Boxv1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployBox is Script{
    function run() external returns(address){
        address proxy = deployBox();
        return proxy ;
    }

    function deployBox() public returns (address) {
        vm.startBroadcast();
        Boxv1 box = new Boxv1();
        ERC1967Proxy proxy = new ERC1967Proxy(address(box), "");
        vm.stopBroadcast();
        return address(proxy);
        
    }
}