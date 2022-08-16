// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/GSNConstants.sol";

import "../src/v2.2.5/interfaces/IRelayHub.sol";
import "../src/v2.2.5/interfaces/IStakeManager.sol";
import "../src/v2.2.5/interfaces/IForwarder.sol";
import "../src/v2.2.5/interfaces/IPaymaster.sol";

/// @dev rely on multiple forking and `.env` file for testing
contract TestGSNConstants is Test {
    uint256[] private _forking;

    function setUp() public {
        _forking.push(vm.createFork(vm.envString("RINKEBY")));
    }

    function testProfiles() public {
        uint256 i;
        for (i = 0; i < _forking.length; ++i) {
            vm.selectFork(_forking[i]);
            GSNConstants _c = new GSNConstants();
            console.log(block.chainid);
            (
                IRelayHub hub,
                IStakeManager stakeManager,
                IForwarder forwarder,
                IPaymaster paymaster
            ) = _c.profile();

            assertEq(address(hub).code.length > 0, true);
            assertEq(address(stakeManager).code.length > 0, true);
            assertEq(address(forwarder).code.length > 0, true);
            assertEq(address(paymaster).code.length > 0, true);
        }
    }
}
