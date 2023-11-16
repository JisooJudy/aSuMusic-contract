// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../contracts/NFT/LyricsNFT.sol";

contract LyricsNFTTest is Test {
    LyricsNFT public lyricsNFT;
    address deployer = makeAddr("deployer");
    address user = makeAddr("user");

    function setUp() public {
        lyricsNFT = new LyricsNFT();
        lyricsNFT.initializeLyricsNFT(deployer);
    }

    function testLyricsNFTMint() public {
        uint expectedMintTime = block.number;
        lyricsNFT.lyricsNFTMint(user, "hello");

        assertEq(lyricsNFT.lyricsTotalSupply(), 1, "LYRICS NFT MINT : wrong total supply");
        assertEq(lyricsNFT.getLyricsNFTCurrentTokenId(), 1, "LYRICS NFT MINT : wrong current token id");
        assertEq(lyricsNFT.getLyricsNFTTokenURI(1), "hello", "LYRICS NFT MINT : wrong token uri");
        assertEq(lyricsNFT.getLyricsMinter(1), user, "LYRICS NFT MINT : wrong lyrics minter");
        assertEq(lyricsNFT.getLyricsInfo(1).owner, user, "LYRICS NFT MINT : wrong lyricsInfo's owner");
        assertEq(lyricsNFT.getLyricsInfo(1).tokenURI, "hello", "LYRICS NFT MINT : wrong lyricsInfo's tokenUri");
        assertEq(lyricsNFT.getLyricsInfo(1).mintTime, expectedMintTime, "LYRICS NFT MINT : wrong lyricsInfo's mintTime");
        consoleUserTokenIdList(user);
    }

    function testLyricsNFTBurn() public {
        lyricsNFT.lyricsNFTMint(user, "hello");
        lyricsNFT.lyricsNFTBurn(user, 1);
        assertEq(lyricsNFT.lyricsTotalSupply(), 0, "LYRICS NFT BURN : wrong total supply");
        assertEq(lyricsNFT.getLyricsNFTCurrentTokenId(), 1, "LYRICS NFT BURN : wrong current token id");
        assertEq(lyricsNFT.getLyricsMinter(1), address(0), "LYRICS NFT BURN : wrong lyrics minter");
        assertEq(lyricsNFT.getLyricsInfo(1).owner, address(0), "LYRICS NFT BURN : wrong lyricsInfo's owner");
        assertEq(lyricsNFT.getLyricsInfo(1).tokenURI, "", "LYRICS NFT BURN : wrong lyricsInfo's tokenUri");
        consoleUserTokenIdList(user);
    }

    function testGetUserLyricsTokenIdList() public {
        lyricsNFT.lyricsNFTMint(user, "hello");
        lyricsNFT.lyricsNFTMint(user, "hello1");
        lyricsNFT.lyricsNFTMint(user, "hello2");
        lyricsNFT.lyricsNFTMint(user, "hello3");
        console.log("--------After Mint----------");
        consoleUserTokenIdList(user);

        lyricsNFT.lyricsNFTBurn(user, 2);
        console.log("--------After Burn----------");
        consoleUserTokenIdList(user);
    }

    function consoleUserTokenIdList(address _user) internal {
        uint[] memory userTokenIds = lyricsNFT.getLyricsNFTUserTokenIdList(_user);
        for(uint i = 0; i < userTokenIds.length; i++){
            console.log(userTokenIds[i]);
        }
    }
}
