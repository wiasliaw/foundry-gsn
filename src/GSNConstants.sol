// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "./v2.2.5/interfaces/IRelayHub.sol";
import "./v2.2.5/interfaces/IStakeManager.sol";
import "./v2.2.5/interfaces/IForwarder.sol";
import "./v2.2.5/interfaces/IPaymaster.sol";

error MissingProfile();

contract GSNConstants is Script {
    address public immutable relayerManager;
    address public immutable relayerWorker;

    constructor() {
        relayerManager = vm.addr(uint256(keccak256("relayer manager")));
        relayerWorker = vm.addr(uint256(keccak256("relayer worker")));
        // init balance
        vm.deal(relayerManager, 100 ether);
        vm.deal(relayerWorker, 100 ether);
        // label
        vm.label(relayerManager, "Relayer Manager");
        vm.label(relayerWorker, "Relayer Worker");
    }

    function profile()
        public
        view
        returns (
            IRelayHub,
            IStakeManager,
            IForwarder,
            IPaymaster
        )
    {
        uint256 chainId = block.chainid;
        if (chainId == 4) {
            return rinkebyProfile();
        } else {
            revert MissingProfile();
        }
    }
}

/// @dev https://docs-v2.opengsn.org/networks/ethereum/rinkeby.html#rinkeby-testnet
function rinkebyProfile()
    view
    returns (
        IRelayHub relayHub,
        IStakeManager stakeManager,
        IForwarder forwarder,
        IPaymaster paymaster
    )
{
    relayHub = IRelayHub(0x6650d69225CA31049DB7Bd210aE4671c0B1ca132);
    stakeManager = IStakeManager(relayHub.stakeManager());
    forwarder = IForwarder(0x83A54884bE4657706785D7309cf46B58FE5f6e8a);
    paymaster = IPaymaster(0xA6e10aA9B038c9Cddea24D2ae77eC3cE38a0c016);
}
