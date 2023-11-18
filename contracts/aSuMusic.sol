// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./libraries/EnumerableSet.sol";
import "./interfaces/IASuMusicNFT.sol";
import "./interfaces/IASuMusic.sol";
import "./utils/ASumConstant.sol";

contract aSuMusic {

    event SetASuMusicInfo(address owner, uint lyricsTokenId, uint melodyTokenId, uint musicTokenId);
    event DeleteASuMusicInfo(address owner);

    IASuMusicNFT melodyNFT;
    IASuMusicNFT lyricsNFT;
    IASuMusicNFT  musicNFT;

    using EnumerableSet for EnumerableSet.UintSet;

    mapping(address => ASumConstant.ASuMusicInfo) public aSuMusicInfos;

    function sync (address _melodyNFT, address _lyricsNFT, address _musicNFT) public {
        require(_melodyNFT != address(0), "aSuMusic: MelodyNFT is the zero address");
        require(_lyricsNFT != address(0), "aSuMusic: LyricsNFT is the zero address");
        require(_musicNFT != address(0), "aSuMusic: MusicNFT is the zero address");

        melodyNFT = IASuMusicNFT(_melodyNFT);
        lyricsNFT = IASuMusicNFT(_lyricsNFT);
        musicNFT = IASuMusicNFT(_musicNFT);
    }


    function setASuMusicInfo(
        address owner,
        uint lyricsTokenId,
        uint melodyTokenId,
        uint musicTokenId
    ) public returns (ASumConstant.ASuMusicInfo memory){
        if (lyricsTokenId != 0 && aSuMusicInfos[owner].lyricsTokenId == 0){
            require(lyricsNFT.isApprovedOrOwner(owner, lyricsTokenId), "Lyrics : Not approve");
            aSuMusicInfos[owner].lyricsTokenId = lyricsTokenId;
        }

        if (melodyTokenId != 0 &&  aSuMusicInfos[owner].melodyTokenId == 0){
            require(melodyNFT.isApprovedOrOwner(owner, melodyTokenId), "Melody : Not approve");
            aSuMusicInfos[owner].melodyTokenId = melodyTokenId;
        }

        if (musicTokenId != 0 &&  aSuMusicInfos[owner].musicTokenId == 0){
            require(musicNFT.isApprovedOrOwner(owner, musicTokenId), "Music : Not approve");
            aSuMusicInfos[owner].musicTokenId = musicTokenId;
        }
        emit SetASuMusicInfo(owner, lyricsTokenId, melodyTokenId, musicTokenId);
        return aSuMusicInfos[owner];
    }

    function setLyricsTokenId(address owner, uint lyricsTokenId) public returns (ASumConstant.ASuMusicInfo memory){
        if (lyricsTokenId != 0){
            require(aSuMusicInfos[owner].lyricsTokenId == 0, "aSuMusicInfo's lyricsTokenId already exists");
            require(lyricsNFT.isApprovedOrOwner(owner, lyricsTokenId), "Lyrics : Not approve");
            aSuMusicInfos[owner].lyricsTokenId = lyricsTokenId;
        }

        return aSuMusicInfos[owner];
    }

    function setMelodyTokenId(address owner, uint melodyTokenId) public returns (ASumConstant.ASuMusicInfo memory){
        if (melodyTokenId != 0){
            require(aSuMusicInfos[owner].melodyTokenId == 0, "aSuMusicInfo's melodyTokenId already exists");
            require(melodyNFT.isApprovedOrOwner(owner, melodyTokenId), "Melody : Not approve");
            aSuMusicInfos[owner].melodyTokenId = melodyTokenId;
        }

        return aSuMusicInfos[owner];
    }

    function setMusicTokenId(address owner, uint musicTokenId) public returns (ASumConstant.ASuMusicInfo memory){
        if (musicTokenId != 0){
            require(aSuMusicInfos[owner].musicTokenId == 0, "aSuMusicInfo's musicTokenId already exists");
            require(musicNFT.isApprovedOrOwner(owner, musicTokenId), "Music : Not approve");
            aSuMusicInfos[owner].musicTokenId = musicTokenId;
        }

        return aSuMusicInfos[owner];
    }

    function getASuMusicInfo(address owner) public view returns (
        ASumConstant.ASuMusicInfo memory _aSuMusicInfo,
        ASumConstant.ASuMusicNFTInfo memory _lyricsInfo,
        ASumConstant.ASuMusicNFTInfo memory _melodyInfo,
        ASumConstant.ASuMusicNFTInfo memory _musicInfo
    ){
        _aSuMusicInfo = aSuMusicInfos[owner];
        _lyricsInfo = lyricsNFT.getNFTInfo(_aSuMusicInfo.lyricsTokenId);
        _melodyInfo = melodyNFT.getNFTInfo(_aSuMusicInfo.melodyTokenId);
        _musicInfo  = musicNFT.getNFTInfo(_aSuMusicInfo.musicTokenId);
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
    ) public returns(uint musicTokenId, ASumConstant.ASuMusicInfo memory _aSuMusicInfo){
        musicTokenId = musicNFT.mint(owner, _tokenURI);
        _aSuMusicInfo = setASuMusicInfo(owner, lyricsTokenId, melodyTokenId, musicTokenId);
    }

//    event SetASuMusicInfo(address owner, uint lyricsTokenId, uint melodyTokenId, uint musicTokenId);
//    event DeleteASuMusicInfo(address owner);
}