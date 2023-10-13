// Import necessary libraries
const { expect } = require("chai");
const { ethers } = require("hardhat");

// Define a test suite for the "Events" functionality
describe("Events", function () {
    let deployer, user;
    let noEvents, events;

    // Before running each test case, set up the deployer and user accounts and deploy the contracts.
    beforeEach(async function () {
        [deployer, user] = await ethers.getSigners();

        // Deploy a contract called NoEventsMarketplace and assign it to the noEvents variable.
        const NoEventsFactory = await ethers.getContractFactory('NoEventsMarketplace', deployer);
        noEvents = await NoEventsFactory.deploy()

        // Deploy a contract called MarketplaceWithEvents and assign it to the events variable.
        const EventsFactory = await ethers.getContractFactory('MarketplaceWithEvents', deployer);
        events = await EventsFactory.deploy()
    });

    // Test the gas cost of transactions in two different marketplaces.
    it('Should cost less gas to transact from a marketplace with events instead of one without', async function () {
        let receipt, percDiff

        // Make an item transaction in the NoEventsMarketplace and record the gas used.
        receipt = await (await noEvents.makeItem(noEvents.address, 1, 100)).wait()
        const gasUsedNoEventsMake = receipt.gasUsed

        // Make an item transaction in the MarketplaceWithEvents and record the gas used.
        receipt = await (await events.makeItem(noEvents.address, 1, 100)).wait()
        const gasUsedEventsMake = receipt.gasUsed

        // Buy an item transaction in the NoEventsMarketplace and record the gas used.
        receipt = await (await noEvents.buyItem(1)).wait()
        const gasUsedNoEventsBuy = receipt.gasUsed

        // Buy an item transaction in the MarketplaceWithEvents and record the gas used.
        receipt = await (await events.buyItem(1)).wait()
        const gasUsedEventsBuy = receipt.gasUsed

        // Assert that it costs more gas to make an item in a marketplace without events compared to one with events.
        expect(gasUsedNoEventsMake).to.be.gt(gasUsedEventsMake)

        // Assert that it costs more gas to buy an item in a marketplace without events compared to one with events.
        expect(gasUsedNoEventsBuy).to.be.gt(gasUsedEventsBuy)

        // Calculate and log the percentage difference in gas efficiency for making items.
        percDiff = Math.round(((gasUsedNoEventsMake/gasUsedEventsMake) - 1)*100)
        console.log(`Gas cost to make item:`, `No Events ${gasUsedNoEventsMake}, `, `Events ${gasUsedEventsMake} (${percDiff}% more gas efficient)`)

        // Calculate and log the percentage difference in gas efficiency for buying items.
        percDiff = Math round(((gasUsedNoEventsBuy/gasUsedEventsBuy) - 1)*100)
        console.log(`Gas cost to buy item:`, `No Events ${gasUsedNoEventsBuy}, `, `Events ${gasUsedEventsBuy} (${percDiff}% more gas efficient)`)
    });
});
