// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "forge-std/Test.sol";

import "../contracts/aSuMusic.sol";
import "../contracts/NFT/LyricsNFT.sol";
import "../contracts/NFT/MelodyNFT.sol";
import "../contracts/NFT/MusicNFT.sol";

contract ASuMusicTest is Test, aSuMusic {
    MelodyNFT public _melodyNFT;
    MusicNFT public _musicNFT;
    LyricsNFT public _lyricsNFT;
    aSuMusic public _aSuMusic;

    address deployer = makeAddr("deployer");
    address user = makeAddr("user");

    function setUp() public {
        _melodyNFT = new MelodyNFT();
        _lyricsNFT = new LyricsNFT();
        _musicNFT = new MusicNFT();
        _aSuMusic = new aSuMusic();

        _melodyNFT.initializeMelodyNFT(deployer);
        _lyricsNFT.initializeLyricsNFT(deployer);
        _musicNFT.initializeMusicNFT(deployer);

        _aSuMusic.sync(address(_melodyNFT), address(_lyricsNFT), address(_musicNFT));

        vm.startPrank(user);
        {
            _melodyNFT.melodyNFTMint(user, "hello");
            _lyricsNFT.lyricsNFTMint(user, "https://meebits.larvalabs.com/meebit/3 ");
        }
        vm.stopPrank();
    }

    function testMusicMintWithASuMusicInfos() public {

        _aSuMusic.musicMintWithASuMusicInfos(user, "music", 1, 1);

        consoleASuMusicInfo(user);
    }

    function consoleASuMusicInfo(address _user) public {
        (
            aSuMusicInfo memory _aSuMusicInfo,
            LyricsNFT.LyricsInfo memory _lyricsInfo,
            MelodyNFT.MelodyInfo memory _melodyInfo,
            MusicNFT.MusicInfo memory _musicInfo
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
