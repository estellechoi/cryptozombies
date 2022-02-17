// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11; // use the specified solc version

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {
    // modifier can get params
    modifier aboveLevel(uint256 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _; // require passed so go back to the function where this modifier is attached and execute it !
    }

    function changeName(uint256 _zombieId, string memory _newName)
        external
        aboveLevel(2, _zombieId)
    {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].name = _newName;
    }

    function changeDna(uint256 _zombieId, uint256 _newDna)
        external
        aboveLevel(20, _zombieId)
    {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].dna = _newDna;
    }

    function getZombiesByOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](ownerZombieCount[_owner]);
        // * why using "for" statement not "mapping" ? to avoid using storage and to use array on memory!
        // cuz mutating storage causes gas fee! it would be needed later to transfer zombies to another owner.
        // and for statement doesnt cause gas if in external view function.
        uint256 counter = 0;
        for (uint256 i = 0; i < zombies.length; i++) {
            // i is zombieId(index)
            if (zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
