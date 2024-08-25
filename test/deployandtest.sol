// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {Boxv1} from "../src/Boxv1.sol";
import {Boxv2} from "../src/Boxv2.sol";

contract DeployAndUpgradeTest is StdCheats, Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;
    address public OWNER = makeAddr("owner");
    address public proxy;

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        proxy = deployer.run();
    }

    function testBoxWorks() public {
        address proxyAddress = deployer.deployBox();
        uint256 expectedVersion = 1;
        assertEq(expectedVersion, Boxv1(proxyAddress).getVersion());
    }

    function testDeploymentIsV1() public {
       address proxyAddress = deployer.deployBox();
        uint256 expectedValue = 7;
        vm.expectRevert();
        Boxv2(proxyAddress).setNum(expectedValue);
    }

    /*function testUpgradeWorks() public {
        //address proxyAddress = deployer.deployBox();

        Boxv2 box2 = new Boxv2();

        // Simulate the ownership transfer to the test contract
        //vm.prank(Boxv1(proxyAddress).owner());
        //Boxv1(proxyAddress).transferOwnership(address(this));

        // Upgrade the Boxv1 implementation to Boxv2
        upgrader.upgradeBox(proxy, address(box2));

        uint256 expectedVersion = 2;
        assertEq(expectedVersion, Boxv2(proxy).getVersion());

       
        Boxv2(proxy).setNum(717);
        assertEq(717, Boxv2(proxy).num());

        Boxv2(proxy).getfavnum(17);
        assertEq(17, Boxv2(proxy).favnum());

    }*/
    function testUpgradeWorks() public {
    // Deploy Boxv2
    Boxv2 box2 = new Boxv2();
    
    // Initialize Boxv2 with the owner
    box2.initialize(OWNER);

    console.log("Proxy Address Before Upgrade:", proxy);
    console.log("New Boxv2 Implementation Address:", address(box2));

    // Upgrade the Boxv1 implementation to Boxv2
    upgrader.upgradeBox(proxy, address(box2));

    // Check if the version is correctly updated
    uint256 expectedVersion = 2;
    uint256 actualVersion = Boxv2(proxy).getVersion();
    console.log("Boxv2 Version After Upgrade:", actualVersion);
    assertEq(expectedVersion, actualVersion);

    // Set and check values in Boxv2
    Boxv2(proxy).setNum(717);
    uint256 numValue = Boxv2(proxy).num();
    console.log("Boxv2 num value after setting:", numValue);
    assertEq(717, numValue);
    
    // Set and check the favorite number
    Boxv2(proxy).setfavnum(17);
    uint256 favnumValue = Boxv2(proxy).getfavnum();
    console.log("Boxv2 favnum value after setting:", favnumValue);
    assertEq(17, favnumValue);
}

   

    
}

  

