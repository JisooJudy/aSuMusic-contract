// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../contracts/NFT/LyricsNFT.sol";

contract CounterTest is Test {
    LyricsNFT public lyricsNFT;
    address deployer = makeAddr("deployer");
    address user = makeAddr("user");

    function setUp() public {
        lyricsNFT = new LyricsNFT();
        lyricsNFT.initialize(deployer);
    }

    function testIncrement() public {
        lyricsNFT.mint(user, "hello");
        assertEq(lyricsNFT.getCurrentTokenId(), 1);
    }

//    function testSetNumber(uint256 x) public {
//        counter.setNumber(x);
//        assertEq(counter.number(), x);
//    }
}
