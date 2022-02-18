// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "./ZombieHelper.sol";

contract ZombieBattle is ZombieHelper {
    uint256 randNonce = 0;
    uint256 attackVictoryProbability = 70;

    // 고정된 길이의 난수 생성
    function randMod(uint256 _modulus) internal returns (uint256) {
        randNonce++;
        return uint256(keccak256(now, msg.sender, randNonce)) % _modulus;
    }

    function attack(uint256 _zombieId, uint256 _targetId)
        external
        ownerOf(_zombieId)
    {
        Zombie storage myZombie = zombies[_zombieId];
        Zombie storage enemyZombie = zombies[_targetId];

        uint256 rand = randMod(100);

        if (rand <= attackVictoryProbability) {
            myZombie.winCount++;
            myZombie.level++;
            enemyZombie.lossCount++;
            feedAndMultiply(_zombieId, enemyZombie.dna, "zombie");
        } else {
            myZombie.lossCount++;
            enemyZombie.winCount++;
        }
        _triggerCooldown(myZombie);
    }
}
