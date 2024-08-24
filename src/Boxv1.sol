// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from"@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Boxv1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 public num;
    uint internal favnum;

    // @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) initializer public {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
       
    }

    function setNum(uint256 _num) external {
        num = _num;
    }

    function getVersion() external pure returns (uint) {
        return 10;
    }

    function getfavnum() external view returns (uint) {
        return favnum;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {
        // Authorization logic for upgrades
    }
}
