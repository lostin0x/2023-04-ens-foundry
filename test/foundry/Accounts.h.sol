// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
// import {CommonBase} from "forge-std/Base.sol";
// import {StdCheats} from "forge-std/StdCheats.sol";
// import {StdUtils} from "forge-std/StdUtils.sol";
import "forge-std/Test.sol";
uint256 constant ETH_SUPPLY = 120_500_000 ether;
contract AccountsHelper is Test {
    uint256 public chainId;
    string public prefixChain;
    // uint256 public deployerKey;
    // address public deployer;
    // uint256 public ownerKey;
    // address public owner;
    // uint256 public testMakerKey;
    // address public testMaker;
    // uint256 public feeToKey;
    // address public feeTo;
    // uint256 public buyerKey;
    // address public buyer;
    struct UserAttributes {
        address addr;
        uint256 key;
        uint256 balance;
    }
    mapping(string => UserAttributes) public users;
    // function _initialization() public virtual {
    //     if(chainId != 0){
    //         prefixChain = "TEST_PRIVATE_KEY_";
    //         if (chainId == 31337) {
    //             prefixChain = "LOCALHOST_PRIVATE_KEY_";
    //         }
            
    //         deployerKey = vm.envUint(string(abi.encodePacked(prefixChain, "DEPLOYER")));
    //         ownerKey = vm.envUint(string(abi.encodePacked(prefixChain, "OWNER")));
    //         testMakerKey = vm.envUint(string(abi.encodePacked(prefixChain, "TEST_MAKER")));
    //         feeToKey = vm.envUint(string(abi.encodePacked(prefixChain, "FEE_TO")));
    //         buyerKey = vm.envUint(string(abi.encodePacked(prefixChain, "BUYER")));
    //     } else {
    //         deployerKey = uint256(keccak256(abi.encodePacked("DEPLOYER")));
    //         ownerKey = uint256(keccak256(abi.encodePacked("OWNER")));
    //         testMakerKey = uint256(keccak256(abi.encodePacked("TEST_MAKER")));
    //         feeToKey = uint256(keccak256(abi.encodePacked("FEE_TO")));
    //         buyerKey = uint256(keccak256(abi.encodePacked("BUYER")));
    //     }
    //     deployer = vm.addr(deployerKey);
    //     deal(deployer, ETH_SUPPLY);
    //     owner = vm.addr(ownerKey);
    //     deal(owner, ETH_SUPPLY);
    //     testMaker = vm.addr(testMakerKey);
    //     deal(testMaker, ETH_SUPPLY);
    //     feeTo = vm.addr(feeToKey);
    //     deal(feeTo, ETH_SUPPLY);
    //     buyer = vm.addr(buyerKey);
    //     deal(buyer, ETH_SUPPLY);
    //     vm.label(deployer, "deployer");
    //     vm.label(owner, "owner");
    //     vm.label(testMaker, "testMaker");
    //     vm.label(feeTo, "feeTo");
    //     vm.label(buyer, "buyer");
    // }
    function createUsers(string[] memory names) public {
        if(chainId != 0){
            prefixChain = "TEST_PRIVATE_KEY_";
            if (chainId == 31337) {
                prefixChain = "LOCALHOST_PRIVATE_KEY_";
            }
        }
        for (uint256 i = 0; i < names.length; i++) {
            string memory name = names[i];
            uint256 key = getPrivateKey(name);
            address addr = vm.addr(key);
            deal(addr, ETH_SUPPLY);
            users[name] = UserAttributes(addr, key, ETH_SUPPLY);
            vm.label(addr, name);
        }
    }
    function getPrivateKey(string memory name) public view returns (uint256) {
        if(chainId != 0){
            return vm.envUint(string(abi.encodePacked(prefixChain, name)));
        } else {
            return uint256(keccak256(abi.encodePacked(name)));
        }
    }

}
