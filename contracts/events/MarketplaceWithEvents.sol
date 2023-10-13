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

contract MarketplaceWithEvents {

    uint itemCount; // Counter for tracking the number of items in the marketplace

    struct Item {
        uint itemId;               // Unique identifier for the item
        address nftContract;       // Address of the NFT contract associated with the item
        uint tokenId;              // Unique identifier for the NFT token
        uint price;                // Price at which the item is listed for sale
        address payable seller;    // Address of the seller
        bool sold;                 // Indicates whether the item has been sold
    }

    // Mapping to store items with their unique IDs
    mapping(uint => Item) public items;

    // Event emitted when an item is listed for sale
    event Offered (
        uint itemId,             // Unique identifier for the item
        address indexed nft,     // Address of the NFT contract
        uint tokenId,            // Unique identifier for the NFT token
        uint price,              // Price at which the item is listed
        address indexed seller,  // Address of the seller
        uint timestamp           // Timestamp when the item was listed
    );

    // Event emitted when an item is purchased
    event Bought(
        uint itemId,             // Unique identifier for the item
        address indexed nft,     // Address of the NFT contract
        uint tokenId,            // Unique identifier for the NFT token
        uint price,              // Price at which the item was sold
        address indexed seller,  // Address of the seller
        address indexed buyer,   // Address of the buyer
        uint timestamp           // Timestamp when the item was bought
    );

    // Function to create a new item listing
    function makeItem(address _nftContract, uint _tokenId, uint _price) external {
        itemCount ++;
        // Add a new item to the 'items' mapping
        items[itemCount] = Item (
            itemCount,                  // Unique item ID
            _nftContract,               // Address of the NFT contract
            _tokenId,                   // Unique NFT token ID
            _price,                     // Listing price
            payable(msg.sender),        // Address of the seller
            false                       // Item is not sold initially
        );
        // Emit the 'Offered' event to notify that the item is listed for sale
        emit Offered(
            itemCount,
            address(_nftContract),
            _tokenId,
            _price,
            msg.sender,
            block.timestamp
        );
    }

    // Function to purchase an item
    function buyItem(uint _itemId) external payable {
        Item storage item = items[_itemId];
        // Mark the item as sold
        item.sold = true;
        // Emit the 'Bought' event to record the purchase
        emit Bought(
            _itemId,
            address(item.nftContract),
            item.tokenId,
            item.price,
            item.seller,
            msg.sender,
            block.timestamp
        );
    }
}
