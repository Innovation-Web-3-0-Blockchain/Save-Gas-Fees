# Methods

- [Caching](#caching)
- [Caching Test](#caching-test)

---

## Caching 

Caching refers to the practice of storing and reusing previously computed or fetched data to improve the efficiency and performance of contract operations. It involves temporarily holding data in memory or storage so that it can be quickly accessed without the need to recalculate or retrieve it from external sources.

**Squaring.sol:**

1. Function with a Higher Gas Consumption

```solidity
// Function to calculate the square of a number without caching
function sqrNumUncached(uint _index) external {
    uint sqr;
    
    for (uint i = 0; i <= nums[_index]; i++) {
        sqr += nums[_index];
    }
    
    sqrs[_index] = sqr;
}
```

2. Function with a Lower Gas Consumption

```solidity
// Function to calculate the square of a number with caching
function sqrNumCached(uint _index) external {
    uint sqr;
    uint num = nums[_index]; // Cache the value of 'nums[_index]'

    for (uint i = 1; i <= num; i++) {
        sqr += num;
    }

    sqrs[_index] = sqr;
}
```

When calling these functions, you will observe that the uncached operation uses more gas compared to the cached operation, especially when you repeatedly call the function with the same input.

---

## Caching Test

   ```bash
   npx hardhat test test/Caching.js
   ```

---

***Will be updated soon***

---
