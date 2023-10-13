# Methods

- [Caching](#caching)
- [Caching Test](#caching-test)
- [Events](#events)
- [Events Test](#events-test)
- [Dependencies](#dependencies)

---

## Caching 

Caching refers to the practice of storing and reusing previously computed or fetched data to improve the efficiency and performance of contract operations. It involves temporarily holding data in memory or storage so that it can be quickly accessed without the need to recalculate or retrieve it from external sources.

**Squaring.sol:**

1. Function with a Higher Gas Consumption

```solidity
// Code snippet with a higher gas consumption
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
// Code snippet with a lower gas consumption
function sqrNumCached(uint _index) external {
    uint sqr;
    uint num = nums[_index];

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

## Events

Events primarily serve the crucial role of enhancing transparency within smart contracts and notifying off-chain entities about important on-chain events. By emitting events, smart contracts can communicate actions, state changes, and significant occurrences to external applications and users. This transparency ensures that relevant parties are aware of critical updates and historical interactions Moreover, events are designed to be cost-effective in terms of gas fees, making them an efficient mechanism for broadcasting information to the broader Ethereum network without incurring substantial computational costs.

***NoEventsMarketplace.sol***

1. Functions with a Higher Gas Consumption

```solidity
// Code snippet with higher gas consumption
function makeItem(address _nftContract, uint _tokenId, uint _price) external {
    itemCount++; 

    items[itemCount] = Item (
        itemCount,
        _nftContract,
        _tokenId,
        _price,
        payable(msg.sender),
        block.timestamp,
        address(0),
        0,
        false
    );
}

function buyItem(uint _itemId) external payable {
    Item storage item = items[_itemId]; 

    item.sold = true;
    item.buyer = msg.sender; 
    item.timestampSold = block.timestamp; 
}

```

***MarketplaceWithEvents.sol***


2. Functions with a Lower Gas Consumption

```solidity
// Code snippet with lower gas consumption
event Offered (
    uint itemId,             
    address indexed nft,     
    uint tokenId,            
    uint price,              
    address indexed seller,  
    uint timestamp           
);

event Bought(
    uint itemId,             
    address indexed nft,     
    uint tokenId,            
    uint price,              
    address indexed seller,  
    address indexed buyer,   
    uint timestamp           
);

// Code for the function goes here //

// Then emit the event:
emit Offered(
    itemCount,
    address(_nftContract),
    _tokenId,
    _price,
    msg.sender,
    block.timestamp
);

// Code for the function goes here //

// Then emit the event:
emit Bought(
    _itemId,
    address(item.nftContract),
    item.tokenId,
    item.price,
    item.seller,
    msg.sender,
    block.timestamp
);
```

When calling these functions, it becomes evident that the contract employing the event operation results in reduced gas expenses compared to the one without events. This is because only one field in the struct needs to be updated on the blockchain, as opposed to the three fields that require modification in the alternative case. 

---

## Events Test

   ```bash
   npx hardhat test test/Events.js
   ```

---

## Dependencies

In this project, we've included the "hardhat-gas-reporter" dependency. This is a valuable tool for anyone working on smart contracts, as it allows you to monitor gas consumption directly in your terminal. It provides insights into gas usage per method created, making it easier to assess the deployment cost of the contract.

It's worth noting that many newer versions of the Solidity compiler come with built-in gas optimization features. This means that experienced Solidity developers may not need to employ as many optimization techniques to reduce gas consumption. However, it remains important to understand these techniques to gain a deeper insight into how the Ethereum Virtual Machine (EVM) operates. This knowledge can help you make more informed decisions and better manage gas costs when working with smart contracts.

---