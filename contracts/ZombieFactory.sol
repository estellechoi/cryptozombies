// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11; // use the specified solc version

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./utils/SafeMath.sol";

// ZombieFactory extends Ownable to use onlyOwner modifier
contract ZombieFactory is Ownable {
    // adjust library to a data type
    // use SafeMath to avolid overflow/underflow result
    // SafeMath uses assert, which is different from require in that it spends gas.
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

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
        // 참고: 우리는 Year 2038 문제를 막지 않기로 하겠네... 그러니 readyTime에서 오버플로우를 걱정할 필요는 없네.
        // 우리 앱은 2038년에는 좀 꼬이겠지 ;)
        zombies.push(
            // block.timestamp returns uint256
            Zombie(_name, _dna, 1, uint32(block.timestamp + cooldownTime), 0, 0)
        );
        uint256 id = zombies.length - 1;

        zombieToOwner[id] = msg.sender; // save the address of caller
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);

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
