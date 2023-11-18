// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";

import "../interfaces/ILyricsNFT.sol";

import "../libraries/EnumerableSet.sol";


contract LyricsNFT is ERC721URIStorageUpgradeable, ILyricsNFT {

    using EnumerableSet for EnumerableSet.UintSet;

    uint public lyricsTotalSupply;
    uint public lyricsCurrentTokenId;
    address public lyricsMinter;

    mapping(address => EnumerableSet.UintSet) userLyricsTokenIdList;
    mapping(uint => address) public lyricsMinters;
    mapping(uint => LyricsInfo) public lyricsInfos;

    function initializeLyricsNFT(address _minter) public initializer {
        __ERC721_init("Lyrics-NFT", "Lyrics");
        lyricsTotalSupply = 0;
        lyricsCurrentTokenId = 0;
        require(_minter != address(0), "LyricsNFT: minter is the zero address");
        lyricsMinter = _minter;
    }

    function lyricsNFTMint(address to, string memory _tokenURI) public returns(uint) {
        if (bytes(_tokenURI).length == 0) {
            revert LyricsNft__InvalidTokenUri();
        }
        lyricsTotalSupply += 1;
        lyricsCurrentTokenId += 1;
        _mint(to, lyricsCurrentTokenId);
        _setLyricsTokenURI(lyricsCurrentTokenId, _tokenURI);
        lyricsMinters[lyricsCurrentTokenId] = to;
        userLyricsTokenIdList[to].add(lyricsCurrentTokenId);
        lyricsInfos[lyricsCurrentTokenId] = LyricsInfo(to, _tokenURI, block.number);
        emit LyricsNFTMint(lyricsCurrentTokenId, to, _tokenURI, block.number);
        return lyricsCurrentTokenId;
    }

    function lyricsNFTBurn(address from, uint tokenId) public {
        if (!isLyricsApprovedOrOwner(from, tokenId)) {
            revert LyricsNft__CanOnlyBeBurnedIfOwnedByMinter();
        }
        _burn(tokenId);

        address owner = lyricsMinters[tokenId];

        delete lyricsMinters[tokenId];
        userLyricsTokenIdList[owner].remove(tokenId);
        delete lyricsInfos[tokenId];
        lyricsTotalSupply -= 1;
        emit LyricsNFTBurn(from, tokenId);
    }

    function _setLyricsTokenURI(
        uint256 tokenId,
        string memory _tokenURI
    ) internal {
        ERC721URIStorageUpgradeable._setTokenURI(tokenId, _tokenURI);
    }

    function isLyricsApprovedOrOwner(address spender, uint256 tokenId) public view returns (bool) {
        address owner = ERC721Upgradeable.ownerOf(tokenId);
        return (spender == owner || ERC721Upgradeable.isApprovedForAll(owner, spender) || ERC721Upgradeable.getApproved(tokenId) == spender);
    }

    function getLyricsNFTCurrentTokenId() public view returns (uint) {
        return lyricsCurrentTokenId;
    }

    function getLyricsNFTUserTokenIdList(address user) public view returns (uint[] memory) {
        return userLyricsTokenIdList[user].values();
    }

    function getLyricsNFTTokenURI(
        uint tokenId
    ) public view returns (string memory){
        return tokenURI(tokenId);
    }

    function getLyricsInfo(uint tokenId) public view returns(LyricsInfo memory){
        return lyricsInfos[tokenId];
    }

    function getLyricsMinter(uint tokenId) public view returns(address){
        return lyricsMinters[tokenId];
    }

}