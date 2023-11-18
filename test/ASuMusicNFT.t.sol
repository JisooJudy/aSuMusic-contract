// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../contracts/NFT/ASuMusicNFT.sol";

contract ASuMusicNFTTest is Test {
    ASuMusicNFT public aSuMusicNFT;
    address deployer = makeAddr("deployer");
    address user = makeAddr("user");

    function setUp() public {
        aSuMusicNFT = new ASuMusicNFT();
        aSuMusicNFT.initialize(deployer);
    }

    function testASuMusicNFTMint() public {
        uint expectedMintTime = block.number;
        aSuMusicNFT.mint(user, "hello");

        assertEq(aSuMusicNFT.totalSupply(), 1, "LYRICS NFT MINT : wrong total supply");
        assertEq(aSuMusicNFT.getCurrentTokenId(), 1, "LYRICS NFT MINT : wrong current token id");
        assertEq(aSuMusicNFT.getTokenURI(1), "hello", "LYRICS NFT MINT : wrong token uri");
        assertEq(aSuMusicNFT.getMinter(1), user, "LYRICS NFT MINT : wrong lyrics minter");
        assertEq(aSuMusicNFT.getNFTInfo(1).owner, user, "LYRICS NFT MINT : wrong lyricsInfo's owner");
        assertEq(aSuMusicNFT.getNFTInfo(1).tokenURI, "hello", "LYRICS NFT MINT : wrong lyricsInfo's tokenUri");
        assertEq(aSuMusicNFT.getNFTInfo(1).mintTime, expectedMintTime, "LYRICS NFT MINT : wrong lyricsInfo's mintTime");
        consoleUserTokenIdList(user);
    }

    function testaSuMusicNFTBurn() public {
        aSuMusicNFT.mint(user, "hello");
        aSuMusicNFT.burn(user, 1);
        assertEq(aSuMusicNFT.totalSupply(), 0, "LYRICS NFT BURN : wrong total supply");
        assertEq(aSuMusicNFT.getCurrentTokenId(), 1, "LYRICS NFT BURN : wrong current token id");
        assertEq(aSuMusicNFT.getMinter(1), address(0), "LYRICS NFT BURN : wrong lyrics minter");
        assertEq(aSuMusicNFT.getNFTInfo(1).owner, address(0), "LYRICS NFT BURN : wrong lyricsInfo's owner");
        assertEq(aSuMusicNFT.getNFTInfo(1).tokenURI, "", "LYRICS NFT BURN : wrong lyricsInfo's tokenUri");
        consoleUserTokenIdList(user);
    }

    function testGetUserLyricsTokenIdList() public {
        aSuMusicNFT.mint(user, "hello");
        aSuMusicNFT.mint(user, "hello1");
        aSuMusicNFT.mint(user, "hello2");
        aSuMusicNFT.mint(user, "hello3");
        console.log("--------After Mint----------");
        consoleUserTokenIdList(user);

        aSuMusicNFT.burn(user, 2);
        console.log("--------After Burn----------");
        consoleUserTokenIdList(user);
    }

    function consoleUserTokenIdList(address _user) internal {
        uint[] memory userTokenIds = aSuMusicNFT.getUserTokenIdList(_user);
        for(uint i = 0; i < userTokenIds.length; i++){
            console.log(userTokenIds[i]);
        }
    }
}
