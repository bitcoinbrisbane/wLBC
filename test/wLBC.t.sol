// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {wLBC} from "../src/wLBC.sol";

contract wLBCTest is Test {
    wLBC public token;
    address public owner;
    address public user1;
    address public user2;
    
    uint256 public constant INITIAL_SUPPLY = 1_000_000; // 1 million tokens
    uint8 public constant DECIMALS = 8; // LBRY Credits use 8 decimals
    uint256 public constant INITIAL_SUPPLY_WITH_DECIMALS = INITIAL_SUPPLY * 10**DECIMALS;

    function setUp() public {
        owner = address(this);
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        
        token = new wLBC(INITIAL_SUPPLY, DECIMALS);
    }

    function test_InitialState() public view {
        assertEq(token.name(), "Wrapped LBRY Credits");
        assertEq(token.symbol(), "wLBC");
        assertEq(token.decimals(), DECIMALS);
        assertEq(token.totalSupply(), INITIAL_SUPPLY_WITH_DECIMALS);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY_WITH_DECIMALS);
        assertEq(token.owner(), owner);
    }

    function test_Transfer() public {
        uint256 transferAmount = 100 * 10**DECIMALS;
        
        token.transfer(user1, transferAmount);
        
        assertEq(token.balanceOf(user1), transferAmount);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY_WITH_DECIMALS - transferAmount);
    }

    function test_Approve() public {
        uint256 approveAmount = 50 * 10**DECIMALS;
        
        token.approve(user1, approveAmount);
        
        assertEq(token.allowance(owner, user1), approveAmount);
    }

    function test_TransferFrom() public {
        uint256 transferAmount = 75 * 10**DECIMALS;
        
        token.approve(user1, transferAmount);
        
        vm.prank(user1);
        token.transferFrom(owner, user2, transferAmount);
        
        assertEq(token.balanceOf(user2), transferAmount);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY_WITH_DECIMALS - transferAmount);
        assertEq(token.allowance(owner, user1), 0);
    }

    function test_Mint() public {
        uint256 mintAmount = 500 * 10**DECIMALS;
        
        token.mint(user1, mintAmount);
        
        assertEq(token.balanceOf(user1), mintAmount);
        assertEq(token.totalSupply(), INITIAL_SUPPLY_WITH_DECIMALS + mintAmount);
    }

    function test_MintOnlyOwner() public {
        uint256 mintAmount = 100 * 10**DECIMALS;
        
        vm.prank(user1);
        vm.expectRevert();
        token.mint(user2, mintAmount);
    }

    function test_BatchMint() public {
        address[] memory recipients = new address[](2);
        uint256[] memory amounts = new uint256[](2);
        
        recipients[0] = user1;
        recipients[1] = user2;
        amounts[0] = 100 * 10**DECIMALS;
        amounts[1] = 200 * 10**DECIMALS;
        
        token.batchMint(recipients, amounts);
        
        assertEq(token.balanceOf(user1), amounts[0]);
        assertEq(token.balanceOf(user2), amounts[1]);
        assertEq(token.totalSupply(), INITIAL_SUPPLY_WITH_DECIMALS + amounts[0] + amounts[1]);
    }

    function test_BatchMintOnlyOwner() public {
        address[] memory recipients = new address[](1);
        uint256[] memory amounts = new uint256[](1);
        
        recipients[0] = user1;
        amounts[0] = 100 * 10**DECIMALS;
        
        vm.prank(user1);
        vm.expectRevert();
        token.batchMint(recipients, amounts);
    }

    function test_BatchMintArrayLengthMismatch() public {
        address[] memory recipients = new address[](2);
        uint256[] memory amounts = new uint256[](1);
        
        recipients[0] = user1;
        recipients[1] = user2;
        amounts[0] = 100 * 10**DECIMALS;
        
        vm.expectRevert("wLBC: arrays length mismatch");
        token.batchMint(recipients, amounts);
    }

    function test_Burn() public {
        uint256 burnAmount = 1000 * 10**DECIMALS;
        
        token.burn(burnAmount);
        
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY_WITH_DECIMALS - burnAmount);
        assertEq(token.totalSupply(), INITIAL_SUPPLY_WITH_DECIMALS - burnAmount);
    }

    function test_BurnFrom() public {
        uint256 burnAmount = 500 * 10**DECIMALS;
        
        // First transfer some tokens to user1
        token.transfer(user1, burnAmount);
        
        // User1 approves owner to burn their tokens
        vm.prank(user1);
        token.approve(owner, burnAmount);
        
        // Owner burns user1's tokens
        token.burnFrom(user1, burnAmount);
        
        assertEq(token.balanceOf(user1), 0);
        assertEq(token.totalSupply(), INITIAL_SUPPLY_WITH_DECIMALS - burnAmount);
    }

    function test_OwnershipTransfer() public {
        token.transferOwnership(user1);
        
        vm.prank(user1);
        token.acceptOwnership();
        
        assertEq(token.owner(), user1);
        
        // Old owner should not be able to mint anymore
        vm.expectRevert();
        token.mint(user2, 100 * 10**DECIMALS);
        
        // New owner should be able to mint
        vm.prank(user1);
        token.mint(user2, 100 * 10**DECIMALS);
        assertEq(token.balanceOf(user2), 100 * 10**DECIMALS);
    }

    function test_ZeroAddressMint() public {
        vm.expectRevert();
        token.mint(address(0), 100 * 10**DECIMALS);
    }

    function test_TransferExceedsBalance() public {
        uint256 excessiveAmount = INITIAL_SUPPLY_WITH_DECIMALS + 1;
        
        vm.expectRevert();
        token.transfer(user1, excessiveAmount);
    }

    function test_BurnExceedsBalance() public {
        uint256 excessiveAmount = INITIAL_SUPPLY_WITH_DECIMALS + 1;
        
        vm.expectRevert();
        token.burn(excessiveAmount);
    }

    // Fuzz testing
    function testFuzz_Mint(uint256 amount) public {
        vm.assume(amount <= type(uint256).max - token.totalSupply());
        vm.assume(amount > 0);
        
        uint256 initialSupply = token.totalSupply();
        token.mint(user1, amount);
        
        assertEq(token.balanceOf(user1), amount);
        assertEq(token.totalSupply(), initialSupply + amount);
    }

    function testFuzz_Transfer(uint256 amount) public {
        vm.assume(amount <= INITIAL_SUPPLY_WITH_DECIMALS);
        
        token.transfer(user1, amount);
        
        assertEq(token.balanceOf(user1), amount);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY_WITH_DECIMALS - amount);
    }
}
