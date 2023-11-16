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
        melodyNFT.initializeMelodyNFT(deployer);
    }

    function testMelodyNFTMint() public {
        uint expectedMintTime = block.number;
        melodyNFT.melodyNFTMint(user, "hello");

        assertEq(melodyNFT.melodyTotalSupply(), 1, "MELODY NFT MINT : wrong total supply");
        assertEq(melodyNFT.getMelodyNFTCurrentTokenId(), 1, "MELODY NFT MINT : wrong current token id");
        assertEq(melodyNFT.getMelodyNFTTokenURI(1), "hello", "MELODY NFT MINT : wrong token uri");
        assertEq(melodyNFT.getMelodyMinter(1), user, "MELODY NFT MINT : wrong melody minter");
        assertEq(melodyNFT.getMelodyInfo(1).owner, user, "MELODY NFT MINT : wrong melodyInfo's owner");
        assertEq(melodyNFT.getMelodyInfo(1).tokenURI, "hello", "MELODY NFT MINT : wrong melodyInfo's tokenUri");
        assertEq(melodyNFT.getMelodyInfo(1).mintTime, expectedMintTime, "MELODY NFT MINT : wrong melodyInfo's mintTime");
        consoleUserTokenIdList(user);
    }

    function testMelodyNFTBurn() public {
        melodyNFT.melodyNFTMint(user, "hello");
        melodyNFT.melodyNFTBurn(user, 1);
        assertEq(melodyNFT.melodyTotalSupply(), 0, "MELODY NFT BURN : wrong total supply");
        assertEq(melodyNFT.getMelodyNFTCurrentTokenId(), 1, "MELODY NFT BURN : wrong current token id");
        assertEq(melodyNFT.getMelodyMinter(1), address(0), "MELODY NFT BURN : wrong melody minter");
        assertEq(melodyNFT.getMelodyInfo(1).owner, address(0), "MELODY NFT BURN : wrong melodyInfo's owner");
        assertEq(melodyNFT.getMelodyInfo(1).tokenURI, "", "MELODY NFT BURN : wrong melodyInfo's tokenUri");
        consoleUserTokenIdList(user);
    }

    function testGetUserMelodyTokenIdList() public {
        melodyNFT.melodyNFTMint(user, "hello");
        melodyNFT.melodyNFTMint(user, "hello1");
        melodyNFT.melodyNFTMint(user, "hello2");
        melodyNFT.melodyNFTMint(user, "hello3");
        console.log("--------After Mint----------");
        consoleUserTokenIdList(user);

        melodyNFT.melodyNFTBurn(user, 2);
        console.log("--------After Burn----------");
        consoleUserTokenIdList(user);
    }

    function consoleUserTokenIdList(address _user) internal {
        uint[] memory userTokenIds = melodyNFT.getMelodyNFTUserTokenIdList(_user);
        for(uint i = 0; i < userTokenIds.length; i++){
            console.log(userTokenIds[i]);
        }
    }
}
