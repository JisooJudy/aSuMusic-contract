// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";

interface IMelodyNFT is IERC721Upgradeable {
    error MelodyNft__InvalidTokenUri();
    error MelodyNft__CanOnlyBeBurnedIfOwnedByMinter();

    struct MelodyInfo {
        address owner;
        string  tokenURI;
        uint    mintTime;
    }

    function mint(address to, string memory _tokenURI) external returns (uint);
    function burn(uint tokenId) external;
    function getCurrentTokenId() external view returns (uint);
    function getUserTokenIdList(address user) external view returns (uint[]);
    function getTokenURI(uint tokenId) external view returns (string memory);
    function getMelodyInfo(uint tokenId) external view returns(MelodyInfo memory);

    event Mint(uint tokenId, address owner, string tokenURI, uint mintTime);
    event Burn(uint256 tokenId);
}