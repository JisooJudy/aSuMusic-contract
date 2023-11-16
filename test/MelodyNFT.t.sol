// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../contracts/NFT/MelodyNFT.sol";

contract MelodyNFTTest is Test {
    MelodyNFT public melodyNFT;
    address deployer = makeAddr("deployer");
    address user = makeAddr("user");

    function setUp() public {
        melodyNFT = new MelodyNFT();
        melodyNFT.initialize(deployer);
    }

    function testMelodyNFTMint() public {
        uint expectedMintTime = block.number;
        melodyNFT.mint(user, "hello");

        assertEq(melodyNFT.melodyTotalSupply(), 1, "MELODY NFT MINT : wrong total supply");
        assertEq(melodyNFT.getCurrentTokenId(), 1, "MELODY NFT MINT : wrong current token id");
        assertEq(melodyNFT.getTokenURI(1), "hello", "MELODY NFT MINT : wrong current token uri");
        assertEq(melodyNFT.getMelodyInfo(1).owner, user, "MELODY NFT MINT : wrong melodyInfo's owner");
        assertEq(melodyNFT.getMelodyInfo(1).tokenURI, "hello", "MELODY NFT MINT : wrong melodyInfo's tokenUri");
        assertEq(melodyNFT.getMelodyInfo(1).mintTime, expectedMintTime, "MELODY NFT MINT : wrong melodyInfo's mintTime");
        consoleUserTokenIdList(user);
    }

    function testMelodyNFTBurn() public {
        melodyNFT.mint(user, "hello");
        melodyNFT.burn(user, 1);
        assertEq(melodyNFT.melodyTotalSupply(), 0, "MELODY NFT BURN : wrong total supply");
        assertEq(melodyNFT.getCurrentTokenId(), 1, "MELODY NFT BURN : wrong current token id");
        assertEq(melodyNFT.getMelodyInfo(1).owner, address(0), "MELODY NFT BURN : wrong melodyInfo's owner");
        assertEq(melodyNFT.getMelodyInfo(1).tokenURI, "", "MELODY NFT BURN : wrong melodyInfo's tokenUri");
        consoleUserTokenIdList(user);
    }

    function testGetUserMelodyTokenIdList() public {
        melodyNFT.mint(user, "hello");
        melodyNFT.mint(user, "hello1");
        melodyNFT.mint(user, "hello2");
        melodyNFT.mint(user, "hello3");
        console.log("--------After Mint----------");
        consoleUserTokenIdList(user);

        melodyNFT.burn(user, 2);
        console.log("--------After Burn----------");
        consoleUserTokenIdList(user);
    }

    function consoleUserTokenIdList(address _user) internal {
        uint[] memory userTokenIds = melodyNFT.getUserTokenIdList(_user);
        for(uint i = 0; i < userTokenIds.length; i++){
            console.log(userTokenIds[i]);
        }
    }
}
