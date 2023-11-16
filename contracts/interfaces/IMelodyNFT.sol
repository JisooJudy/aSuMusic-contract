// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IMelodyNFT  {
    error MelodyNft__InvalidTokenUri();
    error MelodyNft__CanOnlyBeBurnedIfOwnedByMinter();

    struct MelodyInfo {
        address owner;
        string  tokenURI;
        uint    mintTime;
    }

    function mint(address to, string memory _tokenURI) external returns (uint);
    function burn(address from, uint tokenId) external;
    function getCurrentTokenId() external view returns (uint);
    function getUserTokenIdList(address user) external view returns (uint[] memory);
    function getTokenURI(uint tokenId) external view returns (string memory);
    function getMelodyInfo(uint tokenId) external view returns(MelodyInfo memory);

    event MelodyNFTMint(uint tokenId, address owner, string tokenURI, uint mintTime);
    event MelodyNFTBurn(address from, uint256 tokenId);
}

