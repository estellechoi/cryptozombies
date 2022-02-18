# Cryptozombies

Recording what I learned from CryptoZombies course!

Lesson1 : [here](https://share.cryptozombies.io/ko/lesson/1/share/Estelle_Choi?id=Y3p8MTc1NTA2) is my first zombie created

Lesson2 : [you can feed zombies CryptoKitties](https://share.cryptozombies.io/ko/lesson/2/share/Estelle_Choi?id=Y3p8MTc1NTA2)

Lesson3 : [Check out my zombies](https://share.cryptozombies.io/ko/lesson/3/share/Estelle_Choi?id=Y3p8MTc1NTA2)

Lesson4 : [Try a battle with my zombies](https://share.cryptozombies.io/ko/lesson/4/share/Kitty_Zombie?id=WyJjenwxNzU1MDYiLDIsMTRd)

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
