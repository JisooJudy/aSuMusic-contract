// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library ASumConstant {
    struct ASuMusicInfo {
        uint lyricsTokenId;
        uint melodyTokenId;
        uint musicTokenId;
    }

    struct ASuMusicNFTInfo {
        address owner;
        string  tokenURI;
        uint    mintTime;
    }
}