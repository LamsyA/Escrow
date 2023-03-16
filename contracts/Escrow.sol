// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Escrow is ReentrancyGuard {
    address[] public arbiter;
    address[] public beneficiary;
    address public depositor;

    bool public isApproved;

    constructor(address _arbiter, address _beneficiary) payable {
        arbiter.push(_arbiter);
        beneficiary.push(_beneficiary);
        depositor = msg.sender;
    }

    event Approved(address, uint);

    function createArbiter(address _arbiter) public payable {
        arbiter.push(_arbiter);
    }

    function createBeneficiaryr(address _beneficiary) public payable {
        beneficiary.push(_beneficiary);
    }

    function approve() external nonReentrant {
        for (uint i = 0; i < arbiter.length; i++) {
            require(arbiter[i] == msg.sender, "you are not an arbiter");
        }
        uint balance = address(this).balance;
        (bool sent, ) = payable(getBeneficiary()).call{value: balance}("");
        require(sent, "Failed to send Ether");
        emit Approved(getBeneficiary(), balance);
        isApproved = true;
    }

    function getAbriter() external view returns (address arbiterAddress) {
        for (uint i = 0; i < arbiter.length; i++) {
            arbiterAddress = arbiter[i];
        }
        return arbiterAddress;
    }

    function getBeneficiary() public view returns (address beneficiaryAddress) {
        for (uint i = 0; i < beneficiary.length; i++) {
            beneficiaryAddress = beneficiary[i];
        }
        return beneficiaryAddress;
    }
}
