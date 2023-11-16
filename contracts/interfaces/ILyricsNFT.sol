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

    function mint(address to, string memory _tokenURI) external returns (uint);
    function burn(address from, uint tokenId) external;
    function getCurrentTokenId() external view returns (uint);
    function getUserTokenIdList(address user) external view returns (uint[] memory);
    function getTokenURI(uint tokenId) external view returns (string memory);
    function getLyricsInfo(uint tokenId) external view returns(LyricsInfo memory);

    event LyricsNFTMint(uint tokenId, address owner, string tokenURI, uint mintTime);
    event LyricsNFTBurn(address from, uint256 tokenId);
}

