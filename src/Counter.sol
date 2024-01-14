// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
    uint256 public number;

    function setNumber(uint256 newNumber) public {
        assembly {
            sstore(0, newNumber)
        }
    }

    function increment() public {
        assembly {
            sstore(0, add(sload(0), 1))
        }
    }
}
