# Solidity, Security, Access Control, Storage vs Memory

> This doc is WIP

<br />

1. Solidity, Bytecode, ABI, Deploy
2. Security: History, Re-entrancy, Checks Effecs Interactions, Secure Ether Transfer, How to
3. Access Control: `Ownable`
4. Storage vs Memory
5. Uint
6. Time units
7. Modifier

<br />

## 1. Solidity

### 1-1. Solidity

[Solidity](https://docs.soliditylang.org/en/latest/)는 Contract 개발에 사용될 목적으로 만들어진 언어로, 객체 지향의 정적 타입 고수준 언어입니다. Solidity의 런타임은 [EVM](https://docs.soliditylang.org/en/latest/introduction-to-smart-contracts.html#the-ethereum-virtual-machine) 이구요.

<br />

### 1-2. Compilation

#### Bytecode

Solidity로 작성한 Contract는 EVM이 실행할 수 있는 byte 코드로 컴파일한 후 배포합니다. Contract를 컴파일한 결과물은 다음과 같이 [opcode](https://ethereum.org/en/developers/docs/evm/opcodes/)들로 구성됩니다. Ethereum 공식문서에서 opcode마다 발생하는 Gas 비용을 확인할 수 있습니다.

```
PUSH1 0x80 PUSH1 0x40 MSTORE PUSH1 0x4 CALLDATASIZE LT PUSH2 0x41 JUMPI PUSH1 0x0 CALLDATALOAD PUSH29 0x100000000000000000000000000000000000000000000000000000000 SWAP1 DIV PUSH4 0xFFFFFFFF AND DUP1 PUSH4 0xCFAE3217 EQ PUSH2 0x46 JUMPI JUMPDEST PUSH1 0x0 DUP1 REVERT JUMPDEST CALLVALUE DUP1 ISZERO PUSH2 0x52 JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST POP PUSH2 0x5B PUSH2 0xD6 JUMP JUMPDEST PUSH1 0x40 MLOAD DUP1 DUP1 PUSH1 0x20 ADD DUP3 DUP2 SUB DUP3 MSTORE DUP4 DUP2 DUP2 MLOAD DUP2 MSTORE PUSH1 0x20 ADD SWAP2 POP DUP1 MLOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP4 DUP4 PUSH1 0x0 JUMPDEST DUP4 DUP2 LT ISZERO PUSH2 0x9B JUMPI DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD MSTORE PUSH1 0x20 DUP2 ADD SWAP1 POP PUSH2 0x80 JUMP JUMPDEST POP POP POP POP SWAP1 POP SWAP1 DUP2 ADD SWAP1 PUSH1 0x1F AND DUP1 ISZERO PUSH2 0xC8 JUMPI DUP1 DUP3 SUB DUP1 MLOAD PUSH1 0x1 DUP4 PUSH1 0x20 SUB PUSH2 0x100 EXP SUB NOT AND DUP2 MSTORE PUSH1 0x20 ADD SWAP2 POP JUMPDEST POP SWAP3 POP POP POP PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 RETURN JUMPDEST PUSH1 0x60 PUSH1 0x40 DUP1 MLOAD SWAP1 DUP2 ADD PUSH1 0x40 MSTORE DUP1 PUSH1 0x5 DUP2 MSTORE PUSH1 0x20 ADD PUSH32 0x48656C6C6F000000000000000000000000000000000000000000000000000000 DUP2 MSTORE POP SWAP1 POP SWAP1 JUMP STOP LOG1 PUSH6 0x627A7A723058 KECCAK256 SLT 0xec 0xe 0xf5 0xf8 SLT 0xc7 0x2d STATICCALL ADDRESS SHR 0xdb COINBASE 0xb1 BALANCE 0xe8 0xf8 DUP14 0xda 0xad DUP13 LOG1 0x4c 0xb4 0x26 0xc2 DELEGATECALL PUSH7 0x8994D3E002900
```

<br />

#### ABI(Application Binary Interface)

Solidity 컴파일 도구들은 보통 EVM에서 실행될 byte 코드 외에 ABI도 생성합니다. ABI는 JSON 파일로, 배포된 Contract와 함수들에 대한 정보를 담고 있습니다. 이 ABI는 외부에서 Contract를 참조하고 함수들을 호출하기 위한 Key 역할을 하는데, 가령 웹 프론트엔드에서 Ethereum에 배포된 Contract에 접근해서 데이터를 읽거나 추가할 수 있도록 endpoint로서 역할을 합니다. 실제로는 [`web3`]() 같은 [JavaScript 라이브러리](https://ethereum.org/en/developers/docs/apis/javascript/)를 사용하지요.

<br />

예로 [ERC20 토큰 Contract의 ABI](https://ethereum.org/en/developers/docs/smart-contracts/compiling/#web-applications)를 확인해보세요.

<br />

### 1-3. Deploy

Contract 배포는 Ethereum에 Transaction을 전송함으로써 이루어집니다. 수신자를 명시하지 않고 Contract의 컴파일된 코드를 담은 Transaction을 보내면 되고요, 당연히 Gas 비용이 발생합니다. 보통은 [Truffle](https://trufflesuite.com/docs/truffle/advanced/networks-and-app-deployment), [Hardhat](https://hardhat.org/guides/deploying.html) 같은 프레임워크를 사용해서 배포 단계를 핸들링하는 스크립트를 작성합니다. Contract 배포가 완료되면 Ethereum 상에서의 주소를 갖게 됩니다.

<br />

## 2. Security: History, Re-entrancy, Checks Effecs Interactions, Secure Ether Transfer, How to

### 2-1. History

Contract 개발에서 가장 중요한 것 중 하나는 단연코 보안입니다. [Ethereum Smart Contract Best Practices](https://consensys.github.io/smart-contract-best-practices/attacks/)에서 잘 알려진 Attack 유형들도 확인할 수 있고요, [Ethereum 공식문서](https://ethereum.org/en/developers/docs/smart-contracts/security/#re-entrancy)에서 소개하는 Attack 히스토리들을 통해 어떤 종류의 Attack이 있었는지 알아볼 수도 있습니다!

- [$30 Million: Ether Reported Stolen Due to Parity Wallet Breach](https://www.coindesk.com/markets/2017/07/19/30-million-ether-reported-stolen-due-to-parity-wallet-breach/)
- ['$300m in cryptocurrency' accidentally lost forever due to bug](https://www.theguardian.com/technology/2017/nov/08/cryptocurrency-300m-dollars-stolen-bug-ether)
- [Analysis of the DAO exploit](https://hackingdistributed.com/2016/06/18/analysis-of-the-dao-exploit/)

<br />

### 2-2. Re-entrancy, Checks Effecs Interactions, Secure Ether Transfer

[Re-entrancy](https://consensys.github.io/smart-contract-best-practices/attacks/reentrancy/)는 대표적인 Contract Attack 유형으로, 외부 주소를 호출할 때 Control Flow를 외부 Contract에 빼앗길 때 발생할 수 있습니다. 다행히(?) Re-entrancy는 잘 알려진 유형으로 이를 방지하기 위한 방법론들이 있습니다.

- [Checks Effecs Interactions 패턴](https://fravoll.github.io/solidity-patterns/checks_effects_interactions.html): 외부 주소를 호출하는 함수의 로직 순서에 대한 패턴으로, _권한 체크 → 함수의 결과 반영 → 외부 주소_ 호출 순으로 로직을 짜면 Re-entrancy를 막을 수 있다는 아이디어

- [Secure Ether Transfer 패턴](https://fravoll.github.io/solidity-patterns/secure_ether_transfer.html): Ether를 전송할 때 특별한 경우가 아니라면 [`transfer()`](https://github.com/ethereum/solidity/issues/610) 메소드를 사용하라는 패턴, Exception 발생시 Throw하고 State 변경을 자동으로 되돌리는데, 이 때문에 ChecksEffecsInteractions 패턴 사용도 쉬워짐

<br />

### 2-3. How to

Contract를 배포한 후에는 보안 취약점이 발견되어도 Contract를 변경할 수 없기 때문에, 충분한 Test Suite를 통과시키고, 검증된 툴을 사용해서 충분한 Audit을 진행한 Contract만 배포해야합니다. 다음은 Ethereum 공식문서에서 권장하는 Work Flow의 일부입니다.

- [Mythril](https://github.com/ConsenSys/mythril), [Slither](https://github.com/crytic/slither) 같은 툴을 사용하여 코드 분석을 통과한 코드만 PR

- [Truffle](https://trufflesuite.com/docs/truffle/) 같은 Solidity 프레임워크를 사용하여 Test Suite를 배포 스크립트에 포함

- [DeFiSafety](https://www.defisafety.com/)의 [Process Quality Review Process](https://docs.defisafety.com/master/process-quality-audit-process) 사용

<br />

## 3. Access Control: `Ownable`

Contract를 개발할 때 중요한 포인트 중 하나는 Access Control 입니다. 데이터나 함수에 적절한 Access Control을 두지 않으면 누구나 Contract를 악용할 수 있기 때문입니다. Contract의 작동 방식을 바꿔버리거나 다른 사람의 자산을 훔칠 수도 있죠. [Open Zeppelin](https://openzeppelin.com/)은 검증된 Solidity 라이브러리들을 다수 제공하는데, 그 중 [`Ownable`](https://docs.openzeppelin.com/contracts/2.x/access-control#ownership-and-ownable)이라는 Contract는 Contract를 처음 배포하는 주소를 `owner`로 지정한 후 이 `owner`만이 특정 함수와 데이터에 접근하도록 제한할 수 있게 해줍니다. 다음과 같이 Import한 후 상속하면 됩니다! `Ownable` Contract의 `onlyOwner` Modifier를 사용하면 해당 함수는 `owner`만 호출할 수 있게 됩니다. `Ownable` Contract 코드는 [여기](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol)에서 볼 수 있습니다.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

// This will load the @openzeppelin/contracts library from your node_modules
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract MyContract is Ownable {
    function normalThing() public {
        // anyone can call this normalThing()
    }

    function specialThing() public onlyOwner {
        // only the owner can call specialThing()!
    }
}
```

<br />

Open Zeppelin은 `Ownable` 외에도 유용한 재사용 Contract를 다수 제공하는데요, 이러한 Contract 라이브러리들은 [Yarn](https://yarnpkg.com/)과 같은 Node 패키지 매니저를 사용해서 다운로드할 수 있습니다. 대부분의 Solidity 컴파일 도구들이 Import된 Contract를 프로젝트의 `node_modules` 디렉토리에서 탐색하기 때문입니다. Solidity 공식문서에서는 이러한 오픈소스 라이브러리를 사용하기를 적극 권장하고 있는데, 개발시간 단축 뿐만 아니라 보안 측면에서도 오픈소스 라이브러리들이 충분한 Audit을 통과한 경우가 많다는 이점이 있기 때문입니다.

```zsh
# see https://yarnpkg.com/package/@openzeppelin/contracts
yarn add @openzeppelin/contracts
```

<br />

## 4. Storage vs Memory

### 4-1. Storage

Contract에서 모든 데이터는 [Storage/Memory](https://docs.soliditylang.org/en/latest/introduction-to-smart-contracts.html?highlight=memory#storage-memory-and-the-stack) 중 하나에 저장됩니다. Contract뿐만 아니라 모든 Ethereum 계정은 Storage라고 불리는 데이터 저장소를 갖는데, 이 Storage에 저장되는 데이터는 블록체인상에 영구적으로 존재하게 됩니다. Contract 코드 상에서는 State 변수에 할당되는 데이터가 이에 해당합니다.

```solidity
contract SampleContract {
    uint aData; // State variable
}
```

<br />

> 비용을 최소화하기 위해서, 진짜 필요한 경우가 아니면 storage에 데이터를 쓰지 않는 것이 좋네. 이를 위해 때때로는 겉보기에 비효율적으로 보이는 프로그래밍 구성을 할 필요가 있네 - 어떤 배열에서 내용을 빠르게 찾기 위해, 단순히 변수에 저장하는 것 대신 함수가 호출될 때마다 배열을 memory에 다시 만드는 것처럼 말이지. (..ABBR..) 대부분의 프로그래밍 언어에서는, 큰 데이터 집합의 개별 데이터에 모두 접근하는 것은 비용이 비싸네. 하지만 솔리디티에서는 그 접근이 external view 함수라면 storage를 사용하는 것보다 더 저렴한 방법이네. view 함수는 사용자들의 가스를 소모하지 않기 때문이지(가스는 사용자들이 진짜 돈을 쓰는 것이네!). - CryptoZombies Course

<br />

### 4-2. Memory

Contract의 특정 함수가 실행되는 동안만 유지되는 데이터는 Memory에 저장됩니다. 예를 들어, 다음과 같이 주어지는 문자열을 사용하여 랜덤 `uint` 값을 반환하는 함수의 파라미터인 `_str` 값은 함수가 실행되는 동안만 유지되면 되므로 Memory에 저장하게 되죠!

```solidity
function _generateRandomUint(string memory _str)
        private
        view
        returns (uint256)
    {
        uint256 rand = uint256(keccak256(abi.encode(_str)));
        return rand % dnaModulus;
    }
```

<br />

## 5. Uint

> 레슨 1에서, 우리는 uint에 다른 타입들이 있다는 것을 배웠지. uint8, uint16, uint32, 기타 등등..
> 기본적으로는 이런 하위 타입들을 쓰는 것은 아무런 이득이 없네. 왜냐하면 솔리디티에서는 uint의 크기에 상관없이 256비트의 저장 공간을 미리 잡아놓기 때문이지. 예를 들자면, uint(uint256) 대신에 uint8을 쓰는 것은 가스 소모를 줄이는 데에 아무 영향이 없네.
> 하지만 여기에 예외가 하나 있지. 바로 struct의 안에서라네.
> 만약 자네가 구조체 안에 여러 개의 uint를 만든다면, 가능한 더 작은 크기의 uint를 쓰도록 하게. 솔리디티에서 그 변수들을 더 적은 공간을 차지하도록 압축할 것이네.
> 또한 동일한 데이터 타입은 하나로 묶어놓는 것이 좋네. 즉, 구조체에서 서로 옆에 있도록 선언하면 솔리디티에서 사용하는 저장 공간을 최소화한다네. 예를 들면, uint c; uint32 a; uint32 b;라는 필드로 구성된 구조체가 uint32 a; uint c; uint32 b; 필드로 구성된 구조체보다 가스를 덜 소모하네. uint32 필드가 묶여있기 때문이지.

<br />

## 6. Time units

now : 현재의 유닉스 타임스탬프(1970년 1월 1일부터 지금까지의 초 단위 합) 값

> 참고: 유닉스 타임은 전통적으로 32비트 숫자로 저장되네. 이는 유닉스 타임스탬프 값이 32비트로 표시가 되지 않을 만큼 커졌을 때 많은 구형 시스템에 문제가 발생할 "Year 2038" 문제를 일으킬 것이네. 그러니 만약 우리 DApp이 지금부터 20년 이상 운영되길 원한다면, 우리는 64비트 숫자를 써야 할 것이네. 하지만 우리 유저들은 그동안 더 많은 가스를 소모해야 하겠지. 설계를 보고 결정을 해야 하네!

<br />

- seconds
- minutes
- hours
- days
- weeks
- years

<br />

## 7. Modifier

### 7-1. Visibility Modifier

- private
- internal
- public
- external

<br />

### 7-2. State Modifier

다음 두 Modifier 모두, 컨트랙트 외부에서 불렸을 때 가스를 전혀 소모하지 않네(하지만 다른 함수에 의해 내부적으로 호출됐을 경우에는 가스를 소모하지)

- view : 해당 함수를 실행해도 어떤 데이터도 저장/변경되지 않음을 알려주지
- pure : 해당 함수가 어떤 데이터도 블록체인에 저장하지 않을 뿐만 아니라, 블록체인으로부터 어떤 데이터도 읽지 않음을 알려주지.

<br />

### 7-3. Custom Modifier

```solidity
  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
```

<br />

### 7-4. `payable` Modifier

<br />

---

### References

- [How can I securely generate a random number in my smart contract? | Stack Exchange](https://ethereum.stackexchange.com/questions/191/how-can-i-securely-generate-a-random-number-in-my-smart-contract)
