// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11; // use the specified solc version

contract ZombieFactory {
    // event declaration
    event NewZombie(uint256 zombieId, string name, uint256 dna);

    uint256 dnaDigits = 16; // uint = uint256
    uint256 dnaModulus = 10**dnaDigits;

    // structure is something like interface
    struct Zombie {
        string name;
        uint256 dna;
    }

    // a dynamic array without fixed length
    // Zombie[5] means fixed array with length 5
    Zombie[] public zombies;

    // private functions use _ prefix for its name and parameters "usually"
    function _createZombie(string memory _name, uint256 _dna) private {
        zombies.push(Zombie(_name, _dna));
        uint256 id = zombies.length - 1;
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
        uint256 randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
