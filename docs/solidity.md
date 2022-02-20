# Solidity Basics

<br />

1. Access Control: `Ownable`
2. Storage is expensive
3. Uint
4. Time units
5. Modifier

<br />

## 1. Access Control: `Ownable`

Contract를 개발할 때 중요한 포인트 중 하나는 Access Control 입니다. 데이터나 함수에 적절한 Access Control을 두지 않으면 누구나 Contract를 악용할 수 있기 때문입니다. Contract의 작동 방식을 바꿔버리거나 다른 사람의 자산을 훔칠 수도 있죠. [Open Zeppelin](https://openzeppelin.com/)은 검증된 Solidity 라이브러리들을 다수 제공하는데, 그 중 [`Ownable`](https://docs.openzeppelin.com/contracts/2.x/access-control#ownership-and-ownable)이라는 Contract는 Contract를 처음 배포하는 주소를 `owner`로 지정한 후 이 `owner`만이 특정 함수와 데이터에 접근하도록 제한할 수 있게 해줍니다. 다음과 같이 Import한 후 상속하면 됩니다! `Ownable` Contract의 `onlyOwner` Modifier를 사용하면 해당 함수는 `owner`만 호출할 수 있게 됩니다. `Ownable` 코드는 [여기](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol)에서 볼 수 있습니다.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

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

## 2. Storage is expensive

> 비용을 최소화하기 위해서, 진짜 필요한 경우가 아니면 storage에 데이터를 쓰지 않는 것이 좋네. 이를 위해 때때로는 겉보기에 비효율적으로 보이는 프로그래밍 구성을 할 필요가 있네 - 어떤 배열에서 내용을 빠르게 찾기 위해, 단순히 변수에 저장하는 것 대신 함수가 호출될 때마다 배열을 memory에 다시 만드는 것처럼 말이지.
> 대부분의 프로그래밍 언어에서는, 큰 데이터 집합의 개별 데이터에 모두 접근하는 것은 비용이 비싸네. 하지만 솔리디티에서는 그 접근이 external view 함수라면 storage를 사용하는 것보다 더 저렴한 방법이네. view 함수는 사용자들의 가스를 소모하지 않기 때문이지(가스는 사용자들이 진짜 돈을 쓰는 것이네!).

<br />

## 3. Uint


> 레슨 1에서, 우리는 uint에 다른 타입들이 있다는 것을 배웠지. uint8, uint16, uint32, 기타 등등..
> 기본적으로는 이런 하위 타입들을 쓰는 것은 아무런 이득이 없네. 왜냐하면 솔리디티에서는 uint의 크기에 상관없이 256비트의 저장 공간을 미리 잡아놓기 때문이지. 예를 들자면, uint(uint256) 대신에 uint8을 쓰는 것은 가스 소모를 줄이는 데에 아무 영향이 없네.
> 하지만 여기에 예외가 하나 있지. 바로 struct의 안에서라네.
> 만약 자네가 구조체 안에 여러 개의 uint를 만든다면, 가능한 더 작은 크기의 uint를 쓰도록 하게. 솔리디티에서 그 변수들을 더 적은 공간을 차지하도록 압축할 것이네.
> 또한 동일한 데이터 타입은 하나로 묶어놓는 것이 좋네. 즉, 구조체에서 서로 옆에 있도록 선언하면 솔리디티에서 사용하는 저장 공간을 최소화한다네. 예를 들면, uint c; uint32 a; uint32 b;라는 필드로 구성된 구조체가 uint32 a; uint c; uint32 b; 필드로 구성된 구조체보다 가스를 덜 소모하네. uint32 필드가 묶여있기 때문이지.

<br />

## 4. Time units

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

## 4. Modifier

### 4-1. Visibility Modifier

- private
- internal
- public
- external

<br />

### 4-2. State Modifier

다음 두 Modifier 모두, 컨트랙트 외부에서 불렸을 때 가스를 전혀 소모하지 않네(하지만 다른 함수에 의해 내부적으로 호출됐을 경우에는 가스를 소모하지)

- view : 해당 함수를 실행해도 어떤 데이터도 저장/변경되지 않음을 알려주지
- pure : 해당 함수가 어떤 데이터도 블록체인에 저장하지 않을 뿐만 아니라, 블록체인으로부터 어떤 데이터도 읽지 않음을 알려주지.

<br />

### 4-3. Custom Modifier

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

### 4-4. `payable` Modifier

<br />

---

### References

- [How can I securely generate a random number in my smart contract? | Stack Exchange](https://ethereum.stackexchange.com/questions/191/how-can-i-securely-generate-a-random-number-in-my-smart-contract)
