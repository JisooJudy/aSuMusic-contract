// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";
import "../contracts/NFT/VocalNFT.sol";

contract VocalNFTTest is Test {
    VocalNFT public vocalNFT;
    address deployer = makeAddr("deployer");
    address user = makeAddr("user");

    function setUp() public {
        vocalNFT = new VocalNFT();
        vocalNFT.intializeVocalNFT(deployer);
    }
    
    function testVocalNFTMint() public {
        uint expectedMintTime = block.number;
        vocalNFT.vocalNFTMint(user, "hello");

        assertEq(vocalNFT.vocalTotalSupply(), 1, "VOCAL NFT MINT : wrong total supply");
        assertEq(vocalNFT.getVocalNFTCurrentTokenId(), 1, "VOCAL NFT MINT : wrong current token id");
        assertEq(vocalNFT.getVocalNFTTokenURI(1), "hello", "VOCAL NFT MINT : wrong token uri");
        assertEq(vocalNFT.getVocalMinter(1), user, "VOCAL NFT MINT : wrong total supply");
        assertEq(vocalNFT.getVocalInfo(1).owner, user, "VOCAL NFT MINT : wrong vocalInfo's owner");
        assertEq(vocalNFT.getVocalInfo(1).tokenURI, "hello", "VOCAL NFT MINT : wrong vocalInfo's tokenUri");
        assertEq(vocalNFT.getVocalInfo(1).mintTime, expectedMintTime, "VOCAL NFT MINT : wrong vocalInfo's mintTime");   
    }

    function testGetUserVocalTokenIdList() public {
        vocalNFT.vocalNFTMint(user, "hello");
        vocalNFT.vocalNFTMint(user, "hello1");
        vocalNFT.vocalNFTMint(user, "hello2");
        vocalNFT.vocalNFTMint(user, "hello3");
        console.log("--------After Mint-------");
        consoleUserTokenIdList(user);

        vocalNFT.vocalNFTBurn(user, 2);
        console.log("--------After Burn-------");
        consoleUserTokenIdList(user);
    }

    function consoleUserTokenIdList(address _user) internal {
        uint[] memory userTokenIds = vocalNFT.getVocalNFTUserTokenIdList(_user);
        for(uint i = 0; i < userTokenIds.length; i++){
            console.log(userTokenIds[i]);
        }
    }
}