//SPDX-License-Identifier: ISC
pragma solidity ^0.8.20;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';
import '@openzeppelin/contracts/utils/Strings.sol';

contract MerkleDistribute {
    using Strings for uint;
    using Strings for address;
    bytes32 public merkleRoot = 0x81aad91921ed5de61b1dccc539b237d54366f4dab4a22ad14731c7c2ff0b0cdc;
    address public owner;
    IERC20 public USDC;
    uint public claimableUntil;
    mapping(address => bool) public isClaimed;
    constructor(address _usdc){
        USDC = IERC20(_usdc);
        owner = msg.sender;
        claimableUntil = block.timestamp + 30*86400;
    }

    function uint2String(uint a) public pure returns(string memory){
        return a.toString();
    }

    function addr2String(address _addr) public pure returns(string memory){
        return _addr.toHexString();
    }
    
    function equal(string memory a, string memory b) internal pure returns (bool) {
        return bytes(a).length == bytes(b).length && keccak256(bytes(a)) == keccak256(bytes(b));
    }

    function addressEqual(string memory _str) view internal returns(bool){
        string memory prefixed = string(abi.encodePacked("0x",_str));
        string memory addr = addr2String(msg.sender);
        return equal(prefixed,addr);
    }

     //_str is the tail of msg.sender without 0x
     // it matters whether _str is higher or lower case
     //if you want to use merkle tree, everything need to be lower case
    function claim(uint _amount,string memory _str,bytes32[] calldata _merkleProof) external {
        require(isClaimed[msg.sender] == false);
        require(block.timestamp <= claimableUntil);
        require(addressEqual(_str));
        isClaimed[msg.sender] = true;
        string memory amount2String = uint2String(_amount);
        bytes32 node = keccak256(abi.encodePacked(_str,amount2String));
        require(MerkleProof.verify(_merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
        uint transferedAmount = _amount*1e6;
        USDC.transfer(msg.sender,transferedAmount);
    }

    function withdrawAfterMonth() external {
        require(msg.sender == owner);
        require(block.timestamp > claimableUntil);
        uint usdcLeft = USDC.balanceOf(address(this));
        USDC.transfer(msg.sender,usdcLeft);
    }
}