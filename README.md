# CryptoZombies

Recording what I learned from CryptoZombies course!

<br />

### What I learned from the course

#### Docs

- [Contract, Immutability & Composability, Address, Gas, Finality in PoW/PoS](./docs/contract.md)
- [Solidity, Security, Access Control, Storage vs Memory](./docs/solidity.md)
- [EVM](./docs/evm.md)

<br />

#### Some results

- as a result of the lesson1, here is [my first zombie created](https://share.cryptozombies.io/ko/lesson/1/share/Estelle_Choi?id=Y3p8MTc1NTA2)
- lesson2, you can [feed my zombies, who like to eat CryptoKitties](https://share.cryptozombies.io/ko/lesson/2/share/Estelle_Choi?id=Y3p8MTc1NTA2)
- lesson3, check out [my zombies](https://share.cryptozombies.io/ko/lesson/3/share/Estelle_Choi?id=Y3p8MTc1NTA2)
- lesson4, try [a battle with my zombies](https://share.cryptozombies.io/ko/lesson/4/share/Kitty_Zombie?id=WyJjenwxNzU1MDYiLDIsMTRd)
- lesson5, check out [my new zombies](https://share.cryptozombies.io/ko/lesson/5/share/H4XF13LD_MORRIS_%F0%9F%92%AF%F0%9F%92%AF%F0%9F%98%8E%F0%9F%92%AF%F0%9F%92%AF?id=Y3p8MTc1NTA2)
- lesson6, the interface codes are [here](https://github.com/estellechoi/cryptozombies-ui), built with Vue3 and TypeScript, and check out [the phantom of web3](https://share.cryptozombies.io/ko/lesson/6/share/The_Phantom_of_Web3?id=Y3p8MTc1NTA2)

<br />

### Install Solidity compiler

```zsh
brew tap ethereum/ethereum
brew install solidity
```

```zsh
# Try solc command (solc is solidity compiler)
solc --verison
```

<br />

### Install JQ

```zsh
# jq helps with processing json content during compilation and dev
brew install jq
```

<br />

### Install packages

```zsh
# npm install -g yarn (if needed)
yarn install
```

<br />

### Compile contracts

```zsh
# combine both the abi & binary output into a json file named ZombieFactory.json
solc --combined-json abi,bin ZombieFactory.sol > ZombieFactory.json
```

```zsh
# show the content of ZombieFactory.json
cat ZombieFactory.json| jq
```

```zsh
{
    "contracts": {
        "ZombieFactory.sol:ZombieFactory": {
            "abi": "[{\"constant\":false,\"inputs\..."]}",
            "bin": "6080604052348015..."
        }
    },
    "version": "0.5.1+commit.c8a2cb62.Linux.g++"
}
```

<br />

---

### References

- [Cryptozombies](https://cryptozombies.io/ko/)
- [Understanding smart contract compilation and deployment | Kauri.io](https://kauri.io/#communities/Getting%20started%20with%20dapp%20development/understanding-smart-contract-compilation-and-depl/)
