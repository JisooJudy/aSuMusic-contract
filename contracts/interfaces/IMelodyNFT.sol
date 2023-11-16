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

    function melodyNFTMint(address to, string memory _tokenURI) external returns (uint);
    function melodyNFTBurn(address from, uint tokenId) external;
    function getMelodyNFTCurrentTokenId() external view returns (uint);
    function getMelodyNFTUserTokenIdList(address user) external view returns (uint[] memory);
    function getMelodyNFTTokenURI(uint tokenId) external view returns (string memory);
    function getMelodyInfo(uint tokenId) external view returns(MelodyInfo memory);
    function getMelodyMinter(uint tokenId) external view returns(address);

    event MelodyNFTMint(uint tokenId, address owner, string tokenURI, uint mintTime);
    event MelodyNFTBurn(address from, uint256 tokenId);
}

