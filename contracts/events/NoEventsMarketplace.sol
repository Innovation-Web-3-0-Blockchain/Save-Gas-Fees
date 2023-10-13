// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//  NOTE: This smart contract serves as a basic item storage system. It maintains a mapping   // 
//  that stores various items, each represented by a struct. These items can be created and   // 
//  bought using the makeItem and buyItem functions, respectively. The primary focus of this  // 
//  contract is to manage item data, including their identification, associated NFT contract  //
//  and token ID, price, seller, listing timestamp, buyer (if sold), and sale timestamp. It   //
//  doesn't encompass the full functionality of a typical marketplace contract; instead, it   //
//  is designed to illustrate how item data is stored and modified.                           //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////

contract NoEventsMarketplace {

    uint itemCount; // Counter for tracking the number of items in the marketplace
    
    struct Item {
        uint itemId;            // Unique identifier for each item
        address nftContract;    // Address of the NFT contract associated with the item
        uint tokenId;           // Token ID of the NFT
        uint price;             // Price of the item in ether
        address payable seller; // Address of the seller
        uint timestampListed;   // Timestamp when the item was listed
        address buyer;          // Address of the buyer (0x0 if not sold)
        uint timestampSold;     // Timestamp when the item was sold (0 if not sold)
        bool sold;              // Flag indicating whether the item is sold or not
    }
    
    // Mapping from item ID to Item struct
    mapping(uint => Item) public items;

    // Function to create a new item in the marketplace
    function makeItem(address _nftContract, uint _tokenId, uint _price) external {
        itemCount++; // Increment the item counter
        
        // Create a new item and add it to the 'items' mapping
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
    
    // Function to buy an item from the marketplace
    function buyItem(uint _itemId) external payable {
        Item storage item = items[_itemId]; // Get the item with the specified ID
        
        // Update the item to mark it as sold
        item.sold = true;
        item.buyer = msg.sender; // Set the buyer's address
        item.timestampSold = block.timestamp; // Record the sale timestamp
    }
}
