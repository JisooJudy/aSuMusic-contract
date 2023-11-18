// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./IASuMusicNFT.sol";
import "../utils/ASumConstant.sol";


interface IASuMusic is IASuMusicNFT {

    function setASumConstant(
        address owner,
        uint lyricsTokenId,
        uint melodyTokenId,
        uint musicTokenId
    ) external returns (ASumConstant.ASuMusicInfo memory);

    function setLyricsTokenId(address owner, uint lyricsTokenId) external returns (ASumConstant.ASuMusicInfo memory);
    function setMelodyTokenId(address owner, uint melodyTokenId) external returns (ASumConstant.ASuMusicInfo memory);
    function setMusicTokenId(address owner, uint musicTokenId) external returns (ASumConstant.ASuMusicInfo memory);
    function getASuMusicInfo(address owner) external view returns (
        ASumConstant.ASuMusicInfo memory, 
        ASumConstant.ASuMusicNFTInfo memory, 
        ASumConstant.ASuMusicNFTInfo memory, 
        ASumConstant.ASuMusicNFTInfo memory
    );

    function musicMintWithASuMusicInfos(
        address owner,
        string memory _tokenURI,
        uint lyricsTokenId,
        uint melodyTokenId
    ) external returns(uint musicTokenId, ASumConstant.ASuMusicInfo memory);
}

