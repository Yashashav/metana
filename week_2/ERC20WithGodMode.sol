//SPDX-License-Identifier:MIT
pragma solidity ^0.8.13;


contract ERC20WithGodMode {
    address private ownerAddr;
    uint256 public totalSupply;
    mapping(address => uint256) public balancesMap;
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);


    constructor() {
        ownerAddr = msg.sender;
    }

    modifier isOwner() {
        require(msg.sender == ownerAddr, "Caller is not owner");
        _; // Note: _ indicates to parse rest of the function this modifier is attached to.
    }

    function mintTokensToAddress(address recipient, uint256 amount) external isOwner {
            balancesMap[recipient] += amount;
            totalSupply += amount;
            // Note: address(0) is a zero address aka Burner Address
            emit Transfer(address(0), recipient, amount);
    }

    function reduceTokensAtAddress(address target, uint256 amount) external isOwner {
            balancesMap[target] -= amount;
            totalSupply -= amount;
            emit Transfer(target, address(0), amount);
    }

    function authoritiveTransferFrom(address from, address to, uint256 amount) external isOwner {
        require(balancesMap[from] > amount, "Insufficient Funds. Transfer Failed.");
        balancesMap[from] -= amount;
        balancesMap[to] += amount;
        emit Transfer(from, to, amount);
    }

}
