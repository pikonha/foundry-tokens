// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

uint256 constant INITIAL_SUPPLY = 100 ether;

contract CustomERC20 is IERC20, Ownable {
    string public _name;
    string public _symbol;
    uint256 public _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor(
        string memory name_,
        string memory symbol_
    ) Ownable(msg.sender) {
        _name = name_;
        _symbol = symbol_;

        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "invalid account");
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 value) external returns (bool) {
        require(to != address(0), "invalid destination");
        require(_balances[msg.sender] >= value, "insufficient funds");
        _balances[msg.sender] -= value;
        _balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 value) external returns (bool) {
        _allowances[msg.sender][spender] += value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool) {
        require(_balances[from] >= value, "insufficient funds");
        require(_allowances[from][msg.sender] >= value, "insufficient funds");
        _balances[from] -= value;
        _balances[to] += value;
        _allowances[from][to] -= value;

        emit Transfer(from, to, value);
        return true;
    }

    receive() external payable {}

    function withdraw() public onlyOwner {
        (bool sent, ) = payable(owner()).call{value: address(this).balance}("");
        require(sent, "unable to send funds");
    }
}
