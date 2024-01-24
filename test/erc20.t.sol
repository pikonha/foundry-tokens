// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {CustomERC20} from "../src/erc20.sol";

contract CustomERC20Test is Test {
    CustomERC20 private _token;
    address private _owner = 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496;
    address private _laranja = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function setUp() public {
        _token = new CustomERC20("BIGO", "BIGO");
    }

    function test_BalanceOf() public {
        uint256 balance = _token.balanceOf(_owner);
        assertEq(balance, 100 ether);
    }

    function test_Approval() public {
        _token.approve(_laranja, 10 ether);
        assertEq(_token.allowance(_owner, _laranja), 10 ether);

        vm.prank(_laranja);
        _token.transferFrom(_owner, _laranja, 2 ether);
        assertEq(_token.allowance(_owner, _laranja), 8 ether);
        assertEq(_token.balanceOf(_laranja), 2 ether);
        assertEq(_token.balanceOf(_owner), 98 ether);
    }

    function testFail_RevertWhen_NotAllowed() public {
        vm.prank(_laranja);
        _token.transferFrom(_owner, _laranja, 2 ether);
    }

    function test_Transfer() public {
        _token.transfer(_laranja, 10 ether);
        assertEq(_token.balanceOf(_laranja), 10 ether);
        assertEq(_token.balanceOf(_owner), 90 ether);
    }
}
