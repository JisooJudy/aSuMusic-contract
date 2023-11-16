// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./libraries/EnumerableSet.sol";
import "./NFT/LyricsNFT.sol";
import "./NFT/MelodyNFT.sol";
import "./NFT/MusicNFT.sol";
import "./interfaces/IASuMusic.sol";

contract aSuMusic is LyricsNFT, MelodyNFT, MusicNFT, IASuMusic{
    MelodyNFT melodyNFT;
    LyricsNFT lyricsNFT;
    MusicNFT  musicNFT;

//    struct aSuMusicInfo {
//        uint lyricsTokenId;
//        uint melodyTokenId;
//        uint musicTokenId;
//    }

    using EnumerableSet for EnumerableSet.UintSet;

    mapping(address => aSuMusicInfo) public aSuMusicInfos;

    function sync (address _melodyNFT, address _lyricsNFT, address _musicNFT) public {
        require(_melodyNFT != address(0), "aSuMusic: MelodyNFT is the zero address");
        require(_lyricsNFT != address(0), "aSuMusic: LyricsNFT is the zero address");
        require(_musicNFT != address(0), "aSuMusic: MusicNFT is the zero address");

        melodyNFT = MelodyNFT(_melodyNFT);
        lyricsNFT = LyricsNFT(_lyricsNFT);
        musicNFT = MusicNFT(_musicNFT);
    }


    function setASuMusicInfo(
        address owner,
        uint lyricsTokenId,
        uint melodyTokenId,
        uint musicTokenId
    ) public returns (aSuMusicInfo memory){
        if (lyricsTokenId != 0 && aSuMusicInfos[owner].lyricsTokenId == 0){
            require(lyricsNFT.isLyricsApprovedOrOwner(owner, lyricsTokenId), "Lyrics : Not approve");
            aSuMusicInfos[owner].lyricsTokenId = lyricsTokenId;
        }

        if (melodyTokenId != 0 &&  aSuMusicInfos[owner].melodyTokenId == 0){
            require(melodyNFT.isMelodyApprovedOrOwner(owner, melodyTokenId), "Melody : Not approve");
            aSuMusicInfos[owner].melodyTokenId = melodyTokenId;
        }

        if (musicTokenId != 0 &&  aSuMusicInfos[owner].musicTokenId == 0){
            require(musicNFT.isMusicApprovedOrOwner(owner, musicTokenId), "Music : Not approve");
            aSuMusicInfos[owner].musicTokenId = musicTokenId;
        }
        emit SetASuMusicInfo(owner, lyricsTokenId, melodyTokenId, musicTokenId);
        return aSuMusicInfos[owner];
    }

    function setLyricsTokenId(address owner, uint lyricsTokenId) public returns (aSuMusicInfo memory){
        if (lyricsTokenId != 0){
            require(aSuMusicInfos[owner].lyricsTokenId == 0, "aSuMusicInfo's lyricsTokenId already exists");
            require(lyricsNFT.isLyricsApprovedOrOwner(owner, lyricsTokenId), "Lyrics : Not approve");
            aSuMusicInfos[owner].lyricsTokenId = lyricsTokenId;
        }

        return aSuMusicInfos[owner];
    }

    function setMelodyTokenId(address owner, uint melodyTokenId) public returns (aSuMusicInfo memory){
        if (melodyTokenId != 0){
            require(aSuMusicInfos[owner].melodyTokenId == 0, "aSuMusicInfo's melodyTokenId already exists");
            require(melodyNFT.isMelodyApprovedOrOwner(owner, melodyTokenId), "Melody : Not approve");
            aSuMusicInfos[owner].melodyTokenId = melodyTokenId;
        }

        return aSuMusicInfos[owner];
    }

    function setMusicTokenId(address owner, uint musicTokenId) public returns (aSuMusicInfo memory){
        if (musicTokenId != 0){
            require(aSuMusicInfos[owner].musicTokenId == 0, "aSuMusicInfo's musicTokenId already exists");
            require(musicNFT.isMusicApprovedOrOwner(owner, musicTokenId), "Music : Not approve");
            aSuMusicInfos[owner].musicTokenId = musicTokenId;
        }

        return aSuMusicInfos[owner];
    }

    function getASuMusicInfo(address owner) public returns (
        aSuMusicInfo memory _aSuMusicInfo,
        LyricsNFT.LyricsInfo memory _lyricsInfo,
        MelodyNFT.MelodyInfo memory _melodyInfo,
        MusicNFT.MusicInfo memory _musicInfo
    ){
        _aSuMusicInfo = aSuMusicInfos[owner];
        _lyricsInfo = lyricsNFT.getLyricsInfo(_aSuMusicInfo.lyricsTokenId);
        _melodyInfo = melodyNFT.getMelodyInfo(_aSuMusicInfo.melodyTokenId);
        _musicInfo  = musicNFT.getMusicInfo(_aSuMusicInfo.musicTokenId);
    }

    function deleteASuMusicInfo(address owner) public {
        delete aSuMusicInfos[owner];
        emit DeleteASuMusicInfo(owner);
    }

    function musicMintWithASuMusicInfos(
        address owner,
        string memory _tokenURI,
        uint lyricsTokenId,
        uint melodyTokenId
    ) public returns(uint musicTokenId, aSuMusicInfo memory _aSuMusicInfo){
        musicTokenId = musicNFT.musicNFTMint(owner, _tokenURI);
        _aSuMusicInfo = setASuMusicInfo(owner, lyricsTokenId, melodyTokenId, musicTokenId);
    }

//    event SetASuMusicInfo(address owner, uint lyricsTokenId, uint melodyTokenId, uint musicTokenId);
//    event DeleteASuMusicInfo(address owner);
}