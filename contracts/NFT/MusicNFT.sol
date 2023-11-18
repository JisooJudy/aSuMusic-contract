// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";

import "../interfaces/IMusicNFT.sol";

import "../libraries/EnumerableSet.sol";

contract MusicNFT is ERC721URIStorageUpgradeable, IMusicNFT {

    using EnumerableSet for EnumerableSet.UintSet;

    uint public musicTotalSupply;
    uint public musicCurrentTokenId;
    address public musicMinter;

    mapping(address => EnumerableSet.UintSet) userMusicTokenIdList;
    mapping(uint => address) public musicMinters;
    mapping(uint => MusicInfo) public musicInfos;

    function initializeMusicNFT(address _minter) public initializer {
        __ERC721_init("Music-NFT", "Music");
        musicTotalSupply = 0;
        musicCurrentTokenId = 0;
        require(_minter != address(0), "WithdrawalNFT: minter is the zero address");
        musicMinter = _minter;
    }

    function musicNFTMint(address to, string memory _tokenURI) public returns(uint) {
        if (bytes(_tokenURI).length == 0) {
            revert MusicNft__InvalidTokenUri();
        }
        musicTotalSupply += 1;
        musicCurrentTokenId += 1;
        _mint(to, musicCurrentTokenId);
        _setMusicTokenURI(musicCurrentTokenId, _tokenURI);
        musicMinters[musicCurrentTokenId] = to;
        userMusicTokenIdList[to].add(musicCurrentTokenId);
        musicInfos[musicCurrentTokenId] = MusicInfo(to, _tokenURI, block.number);
        emit MusicNFTMint(musicCurrentTokenId, to, _tokenURI, block.number);
        return musicCurrentTokenId;
    }

    function musicNFTBurn(address from, uint tokenId) public {
        if (!isMusicApprovedOrOwner(from, tokenId)) {
            revert MusicNft__CanOnlyBeBurnedIfOwnedByMinter();
        }
        _burn(tokenId);

        address owner = musicMinters[tokenId];

        delete musicMinters[tokenId];
        userMusicTokenIdList[owner].remove(tokenId);
        delete musicInfos[tokenId];
        musicTotalSupply -= 1;
        emit MusicNFTBurn(from, tokenId);
    }

    function _setMusicTokenURI(
        uint256 tokenId,
        string memory _tokenURI
    ) internal {
        ERC721URIStorageUpgradeable._setTokenURI(tokenId, _tokenURI);
    }

    function isMusicApprovedOrOwner(address spender, uint256 tokenId) public view returns (bool) {
        address owner = ERC721Upgradeable.ownerOf(tokenId);
        return (spender == owner || ERC721Upgradeable.isApprovedForAll(owner, spender) || ERC721Upgradeable.getApproved(tokenId) == spender);
    }

    function getMusicNFTCurrentTokenId() public view returns (uint) {
        return musicCurrentTokenId;
    }

    function getMusicNFTUserTokenIdList(address user) public view returns (uint[] memory) {
        return userMusicTokenIdList[user].values();
    }

    function getMusicNFTTokenURI(
        uint tokenId
    ) public view returns (string memory){
        return tokenURI(tokenId);
    }

    function getMusicInfo(uint tokenId) public view returns(MusicInfo memory){
        return musicInfos[tokenId];
    }

    function getMusicMinter(uint tokenId) public view returns(address){
        return musicMinters[tokenId];
    }

}