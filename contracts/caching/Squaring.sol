// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Contract for performing square calculations on an array of numbers
contract Squaring {
    // Public arrays to store input numbers and their squared results
    uint[] public nums;
    uint[] public sqrs;

    // Constructor to initialize the 'nums' array with input values
    constructor (uint[] memory _nums) {
        nums = _nums;
        // Initialize the 'sqrs' array with the same length as 'nums'
        sqrs = new uint[](nums.length);
    }

    // Function to calculate the square of a number without caching
    function sqrNumUncached(uint _index) external {
        uint sqr;
        // Loop through numbers up to 'nums[_index]' and calculate the square
        for (uint i = 0; i <= nums[_index]; i++) {
            sqr += nums[_index];
        }
        // Store the result in the 'sqrs' array
        sqrs[_index] = sqr;
    }

    // Function to calculate the square of a number with caching
    function sqrNumCached(uint _index) external {
        uint sqr;
        uint num = nums[_index]; // Cache the value of 'nums[_index]'
        // Loop through numbers up to 'num' and calculate the square
        for (uint i = 1; i <= num; i++) {
            sqr += num;
        }
        // Store the result in the 'sqrs' array
        sqrs[_index] = sqr;
    }
}
