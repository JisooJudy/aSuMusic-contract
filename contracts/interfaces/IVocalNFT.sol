// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IVocalNFT {
    error VocalNFT__InvalidTokenUri();
    error VocalNFT__CanOnlyBeBurnedIfOwnedByMinter();

    struct VocalInfo {
        address owner;
        string tokenURI;
        uint mintTime;
    }

    function vocalNFTMint(address to, string memory _tokenURI) external returns(uint);
    function vocalNFTBurn(address from, uint tokenId) external;
    function getVocalNFTCurrentTokenId() external view returns (uint);
    function getVocalNFTUserTokenIdList(address user) external view returns (uint[] memory);
    function getVocalNFTTokenURI(uint tokenId) external view returns (string memory);
    function getVocalInfo(uint tokenId) external view returns(VocalInfo memory);
    function getVocalMinter(uint tokenId) external view returns(address);

    event VocalNFTMint(uint tokenId, address owner, string tokenUR, uint mintTime);
    event VocalNFTBurn(address from, uint256 tokenId);
}