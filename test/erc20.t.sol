// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {CustomERC20} from "../src/erc20.sol";

contract CustomERC20Test is Test {
    CustomERC20 public token;

    function setUp() public {
        token = new CustomERC20();
    }

    function testFuzz_SetNumber(uint256 x) public {
        // assertEq(token.number(), x);
    }
}
