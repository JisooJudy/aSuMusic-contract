// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../utils/ASumConstant.sol";

interface IASuMusicNFT  {
    function mint(address to, string memory _tokenURI) external returns (uint);
    function burn(address from, uint tokenId) external;
    function getCurrentTokenId() external view returns (uint);
    function getUserTokenIdList(address user) external view returns (uint[] memory);
    function getTokenURI(uint tokenId) external view returns (string memory);
    function getNFTInfo(uint tokenId) external view returns(ASumConstant.ASuMusicNFTInfo memory);
    function getMinter(uint tokenId) external view returns(address);
    function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool);
}

