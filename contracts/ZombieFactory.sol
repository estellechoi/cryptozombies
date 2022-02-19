// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11; // use the specified solc version

import "./utils/Ownable.sol";

// import "@openzeppelin/contracts/ownership/Ownable.sol";

// ZombieFactory extends Ownable to use onlyOwner modifier
contract ZombieFactory is Ownable {
    // event declaration
    event NewZombie(uint256 zombieId, string name, uint256 dna);

    uint256 dnaDigits = 16; // uint = uint256
    uint256 dnaModulus = 10**dnaDigits;
    uint256 cooldownTime = 1 days; // 24 * 60 * 60 s

    // structure is something like interface
    struct Zombie {
        string name;
        uint256 dna;
        // can save gas fee by using uint32 rather than uint256 in a struct
        // it is also helpful to declare same-typed ones continuously
        // but uint32 doesnt save gas fee if used outside of structs!
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    // a dynamic array without fixed length
    // Zombie[5] means fixed array with length 5
    Zombie[] public zombies;

    // mapping(key => value) public mappingName;
    mapping(uint256 => address) public zombieToOwner;
    mapping(address => uint256) ownerZombieCount;

    // private functions use _ prefix for its name and parameters "usually"
    // internal is private, but accessible from the contracts extending the current one.
    function _createZombie(string memory _name, uint256 _dna) internal {
        zombies.push(
            // block.timestamp returns uint256
            Zombie(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0)
        );
        uint256 id = zombies.length - 1;

        zombieToOwner[id] = msg.sender; // save the address of caller
        ownerZombieCount[msg.sender]++;

        // trigger event
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str)
        private
        view
        returns (uint256)
    {
        uint256 rand = uint256(keccak256(abi.encode(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0); // allow making only one zombie per address

        uint256 randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
