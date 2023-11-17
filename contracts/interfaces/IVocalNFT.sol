// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IVocalNFT {
    error VocalNFT_InvalidTokenURi();
    error VoclaNFT_CanOnlyBeBurnedIfOwnedByMinter();

    struct VocalInfo {
        address owner;
        string tokenURI;
        uint mintTime;
    }

    function mint(address to, string memory _tokenURI) external returns(uint);
    function burn(address from, uint tokenId) external;
    function getCurrentTokenId() external view returns (uint);
    function getUserTokenIdList(address user) external view returns (uint[] memory);
    function getTokenURI(uint tokenId) external view returns (string memory);
    function getVocalInfo(uint tokenId) external view returns(VocalInfo memory);

    event VocalNFTMint(uint tokenId, address owner, string tokenUR, uint mintTime);
    event VocalNFTBurn(address from, uint256 tokenId);
}