// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";

import "../contracts/utils/ASumConstant.sol";
import "../contracts/ASuMusic.sol";
import "../contracts/NFT/ASuMusicNFT.sol";


contract ASuMusicTest is Test {
    ASuMusicNFT public _melodyNFT;
    ASuMusicNFT public _musicNFT;
    ASuMusicNFT public _lyricsNFT;
    aSuMusic public _aSuMusic;

    address deployer = makeAddr("deployer");
    address user = makeAddr("user");

    function setUp() public {
        _melodyNFT = new ASuMusicNFT();
        _lyricsNFT = new ASuMusicNFT();
        _musicNFT = new ASuMusicNFT();
        _aSuMusic = new aSuMusic();


        _melodyNFT.initialize(deployer);
        _lyricsNFT.initialize(deployer);
        _musicNFT.initialize(deployer);
        _aSuMusic.sync(address(_melodyNFT), address(_lyricsNFT), address(_musicNFT));

        vm.startPrank(user);
        {
            _melodyNFT.mint(user, "hello");
            _lyricsNFT.mint(user, "https://meebits.larvalabs.com/meebit/3 ");
        }
        vm.stopPrank();
    }

    function testMusicMintWithASuMusicInfos() public {

        _aSuMusic.musicMintWithASuMusicInfos(user, "music", 1, 1);

        consoleASuMusicInfo(user);
    }

    function consoleASuMusicInfo(address _user) public {
        (
            ASumConstant.ASuMusicInfo memory _aSuMusicInfo,
            ASumConstant.ASuMusicNFTInfo memory _lyricsInfo,
            ASumConstant.ASuMusicNFTInfo memory _melodyInfo,
            ASumConstant.ASuMusicNFTInfo memory _musicInfo
        )
            = _aSuMusic.getASuMusicInfo(_user);

        console.log("---- a SuMusic Info ----");
        console.log("lyricsTokenId : ", _aSuMusicInfo.lyricsTokenId);
        console.log("melodyTokenId : ", _aSuMusicInfo.melodyTokenId);
        console.log("musicTokenId : ", _aSuMusicInfo.musicTokenId);

        console.log("---- a LyricsInfo ----");
        console.log("owner : ", _lyricsInfo.owner);
        console.log("tokenURI : ", _lyricsInfo.tokenURI);
        console.log("mintTime : ", _lyricsInfo.mintTime);

        console.log("---- a MelodyInfo ----");
        console.log("owner : ", _melodyInfo.owner);
        console.log("tokenURI : ", _melodyInfo.tokenURI);
        console.log("mintTime : ", _melodyInfo.mintTime);

        console.log("---- a MusicInfo ----");
        console.log("owner : ", _musicInfo.owner);
        console.log("tokenURI : ", _musicInfo.tokenURI);
        console.log("mintTime : ", _musicInfo.mintTime);
    }
}
