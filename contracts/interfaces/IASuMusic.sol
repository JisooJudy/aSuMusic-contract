// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ILyricsNFT.sol";
import "./IMelodyNFT.sol";
import "./IMusicNFT.sol";

interface IASuMusic is IMelodyNFT, ILyricsNFT, IMusicNFT {

    struct aSuMusicInfo {
        uint lyricsTokenId;
        uint melodyTokenId;
        uint musicTokenId;
    }

    function setASuMusicInfo(
        address owner,
        uint lyricsTokenId,
        uint melodyTokenId,
        uint musicTokenId
    ) external returns (aSuMusicInfo memory);

    function setLyricsTokenId(address owner, uint lyricsTokenId) external returns (aSuMusicInfo memory);
    function setMelodyTokenId(address owner, uint melodyTokenId) external returns (aSuMusicInfo memory);
    function setMusicTokenId(address owner, uint musicTokenId) external returns (aSuMusicInfo memory);
    function getASuMusicInfo(address owner) external returns (aSuMusicInfo memory, LyricsInfo memory, MelodyInfo memory, MusicInfo memory);

    function musicMintWithASuMusicInfos(
        address owner,
        string memory _tokenURI,
        uint lyricsTokenId,
        uint melodyTokenId
    ) external returns(uint musicTokenId, aSuMusicInfo memory);

    event SetASuMusicInfo(address owner, uint lyricsTokenId, uint melodyTokenId, uint musicTokenId);
    event DeleteASuMusicInfo(address owner);
}

