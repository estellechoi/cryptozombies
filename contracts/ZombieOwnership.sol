// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "./ZombieBattle.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/**
 * @title a contract that handles transfering ownership of zombies.
 * @author estellechoi
 * @dev follows ERC721 by OpenZeppelin
 * the above comments follow parts of natspec
 */
abstract contract ZombieOwnership is ZombieBattle, ERC721 {
    mapping(uint256 => address) zombieApprovals;

    function balanceOf(address _owner)
        public
        view
        override
        returns (uint256 _balance)
    {
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 _tokenId)
        public
        view
        override
        returns (address _owner)
    {
        return zombieToOwner[_tokenId];
    }

    function _transfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal override {
        // use SafeMath methods to avoid overflow/underflow
        // if they occurs, SafeMath throws error but does not rollback the gas spent already unlike require statement.
        ownerZombieCount[_to] = ownerZombieCount[_to].add(1);
        ownerZombieCount[_from] = ownerZombieCount[_from].sub(1);
        zombieToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function transfer(address _to, uint256 _tokenId)
        public
        onlyOwnerOf(_tokenId)
    {
        _transfer(msg.sender, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId)
        public
        override
        onlyOwnerOf(_tokenId)
    {
        zombieApprovals[_tokenId] = _to;
        emit Approval(msg.sender, _to, _tokenId);
    }

    function takeOwnership(uint256 _tokenId) public {
        require(msg.sender == zombieApprovals[_tokenId]);
        address owner = ownerOf(_tokenId);
        _transfer(owner, msg.sender, _tokenId);
    }
}
