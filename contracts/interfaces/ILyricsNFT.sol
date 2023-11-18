// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ILyricsNFT  {
    error LyricsNft__InvalidTokenUri();
    error LyricsNft__CanOnlyBeBurnedIfOwnedByMinter();

    struct LyricsInfo {
        address owner;
        string  tokenURI;
        uint    mintTime;
    }

    function lyricsNFTMint(address to, string memory _tokenURI) external returns (uint);
    function lyricsNFTBurn(address from, uint tokenId) external;
    function getLyricsNFTCurrentTokenId() external view returns (uint);
    function getLyricsNFTUserTokenIdList(address user) external view returns (uint[] memory);
    function getLyricsNFTTokenURI(uint tokenId) external view returns (string memory);
    function getLyricsInfo(uint tokenId) external view returns(LyricsInfo memory);
    function getLyricsMinter(uint tokenId) external view returns(address);

    event LyricsNFTMint(uint tokenId, address owner, string tokenURI, uint mintTime);
    event LyricsNFTBurn(address from, uint256 tokenId);
}

