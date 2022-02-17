// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11; // use the specified solc version

import "./ZombieFactory.sol";

// KittyInterface let this current contract know about the function of KittyContract
abstract contract KittyInterface {
    function getKitty(uint256 _id)
        external
        view
        virtual
        returns (
            bool isGestating,
            bool isReady,
            uint256 cooldownIndex,
            uint256 nextActionAt,
            uint256 siringWithId,
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 generation,
            uint256 genes
        );
}

// ZombieFeeding extends ZombieFactory
contract ZombieFeeding is ZombieFactory {
    // initialize the interface
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    KittyInterface kittyContract = KittyInterface(ckAddress);

    function feedAndMultiply(
        uint256 _zombieId,
        uint256 _targetDna,
        string memory _species
    ) public {
        // check if the caller's address is same as the one of zombie owner
        require(zombieToOwner[_zombieId] == msg.sender);

        // storage → pointer
        Zombie storage myZombie = zombies[_zombieId];

        _targetDna = _targetDna % dnaModulus;
        uint256 newDna = (myZombie.dna + _targetDna) / 2;

        // set a special dna when the species is kitty !
        if (keccak256(abi.encode(_species)) == keccak256("kitty")) {
            newDna = newDna - (newDna % 100) + 99;
        }

        _createZombie("NoName", newDna); // this is callable cuz it is declared as "internal"
    }

    function feedOnKitty(uint256 _zombieId, uint256 _kittyId) public {
        uint256 kittyDna;
        (, , , , , , , , , kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}
