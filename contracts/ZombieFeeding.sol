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
    // address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    // = KittyInterface(ckAddress);
    KittyInterface kittyContract;

    modifier ownerOf(uint256 _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        _;
    }

    // can use onlyOwner modifier of Ownable as it is extended by ZombieFactory extended by ZombieFeeding
    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    // 1. `_triggerCooldown` 함수를 여기에 정의하게
    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(block.timestamp + cooldownTime);
    }

    // 2. `_isReady` 함수를 여기에 정의하게
    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return (_zombie.readyTime <= block.timestamp);
    }

    function feedAndMultiply(
        uint256 _zombieId,
        uint256 _targetDna,
        string memory _species
    ) internal ownerOf(_zombieId) {
        // check if the caller's address is same as the one of zombie owner
        // this line replaced with modifier "ownerOf"
        // require(zombieToOwner[_zombieId] == msg.sender);

        // storage → pointer
        Zombie storage myZombie = zombies[_zombieId];

        // check if the readyTime passed so that feed zombie
        require(_isReady(myZombie));

        _targetDna = _targetDna % dnaModulus;
        uint256 newDna = (myZombie.dna + _targetDna) / 2;

        // set a special dna when the species is kitty !
        if (keccak256(abi.encode(_species)) == keccak256("kitty")) {
            newDna = newDna - (newDna % 100) + 99;
        }

        _createZombie("NoName", newDna); // this is callable cuz it is declared as "internal"
        _triggerCooldown(myZombie); // set readyTime for the zombie feeded!
    }

    function feedOnKitty(uint256 _zombieId, uint256 _kittyId) public {
        uint256 kittyDna;
        (, , , , , , , , , kittyDna) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}
