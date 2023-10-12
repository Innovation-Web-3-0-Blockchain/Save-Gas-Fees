// Import necessary libraries
const { expect } = require("chai");
const { ethers } = require("hardhat");

// Define a test suite for the "Caching" functionality
describe("Caching", function () {
  // Declare variables for deployer and user, and a contract instance 'squaring'
  let deployer, user;
  let squaring;

  // Define an array of numbers for testing
  const nums = [5, 10, 15, 20, 25, 30]

  // This function is run before each test case
  beforeEach(async function () {
    // Get two Ethereum signers, deployer, and user
    [deployer, user] = await ethers.getSigners();

    // Create a contract factory for the 'Squaring' contract and deploy it with 'nums'
    const SquaringFactory = await ethers.getContractFactory('Squaring', deployer);
    squaring = await SquaringFactory.deploy(nums);
  });

  // This is a test case to compare gas costs of cached and uncached item inspections
  it('Should cost less gas to execute cached versus uncached item inspections', async function () {
    let receipt;

    // Use Promise.all to execute the test for each number in 'nums' array
    await Promise.all(nums.map(async (i, indx) => {
      // Call 'sqrNumUncached' and get the gas receipt for uncached operation
      receipt = await (await squaring.sqrNumUncached(indx)).wait();
      const gasUsedUncached = receipt.gasUsed;

      // Call 'sqrNumCached' and get the gas receipt for cached operation
      receipt = await (await squaring.sqrNumCached(indx)).wait();
      const gasUsedCached = receipt.gasUsed;

      // Assert that uncached operation uses more gas than cached operation
      expect(gasUsedUncached).to.be.gt(gasUsedCached);

      // Assert that the cached result matches the expected square value
      expect(await squaring.sqrs(indx)).to.eq(i * i);

      // Calculate the percentage difference in gas efficiency
      const percDiff = Math.round(((gasUsedUncached / gasUsedCached) - 1) * 100);

      // Log the gas usage and efficiency comparison for each number
      console.log(`Gas used to square ${i}:`, `Uncached ${gasUsedUncached}, `, `Cached ${gasUsedCached} (${percDiff}% more gas efficient)`)
    }));
  });
});
