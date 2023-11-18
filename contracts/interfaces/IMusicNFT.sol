// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IMusicNFT  {
    error MusicNft__InvalidTokenUri();
    error MusicNft__CanOnlyBeBurnedIfOwnedByMinter();

    struct MusicInfo {
        address owner;
        string  tokenURI;
        uint    mintTime;
    }

    function musicNFTMint(address to, string memory _tokenURI) external returns (uint);
    function musicNFTBurn(address from, uint tokenId) external;
    function getMusicNFTCurrentTokenId() external view returns (uint);
    function getMusicNFTUserTokenIdList(address user) external view returns (uint[] memory);
    function getMusicNFTTokenURI(uint tokenId) external view returns (string memory);
    function getMusicInfo(uint tokenId) external view returns(MusicInfo memory);
    function getMusicMinter(uint tokenId) external view returns(address);

    event MusicNFTMint(uint tokenId, address owner, string tokenURI, uint mintTime);
    event MusicNFTBurn(address from, uint256 tokenId);
}

