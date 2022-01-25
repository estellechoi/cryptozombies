# Cryptozombies

Recording what I learned from Cryptozombies course (my first Solidity project), and [here](https://share.cryptozombies.io/ko/lesson/1/share/estellechoi) is my zombie created!

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
