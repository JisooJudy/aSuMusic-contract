// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/token/ERC721/ERC721Upgradeable.sol";

import "../interfaces/ILyricsNFT.sol";

import "../libraries/EnumerableSet.sol";

contract LyricsNFT is ERC721Upgradeable, ILyricsNFT, OwnableUpgradeable {
    using EnumerableSet for EnumerableSet.UintSet;

    uint256 public currentTokenId;
    address public minter;

    mapping(address => EnumerableSet.UintSet) public userLyricsTokenIdList;
    mapping(uint => address) public minters;
    mapping(uint => LyricsInfo) public lyricsInfos;

    function initialize(address _minter) public initializer {
        __ERC721_init("Lyrics-NFT", "Lyrics");
        __Ownable_init();
        totalSupply = 0;
        currentTokenId = 0;
        require(_minter != address(0), "WithdrawalNFT: minter is the zero address");
        minter = _minter;
    }

    function mint(address to, string memory _tokenURI) public returns(uint) {
        if (bytes(_tokenURI).length == 0) {
            revert LyricsNft__InvalidTokenUri();
        }
        totalSupply += 1;
        currentTokenId += 1;
        _mint(to, currentTokenId);
        _setTokenURI(currentTokenId, _tokenURI);
        minters[tokenId] = to;
        userLyricsTokenIdList.add(currentTokenId);
        lyricsInfos[currentTokenId] = LyricsInfo(to, _tokenURI, block.number);
        emit Mint(currentTokenId, to, _tokenURI, block.number);
        return currentTokenId;
    }

    function burn(uint tokenId) public override {
        if (!_isAuthorized(minters[tokenId], msg.sender, tokenId) && minters[tokenId] != msg.sender) {
            revert LyricsNft__CanOnlyBeBurnedIfOwnedByMinter();
        }
        _burn(tokenId);
        emit Burn(tokenId);

    }

    function _setTokenURI(
        uint256 tokenId,
        string memory _tokenURI
    ) internal override(ERC721URIStorageUpgradeable) {
        super._setTokenURI(tokenId, _tokenURI);
    }

    function _burn(uint tokenId) internal override(ERC721Upgradeable, ERC721URIStorageUpgradeable) {
        super._burn(tokenId);

        address owner = minters[tokenId];

        delete minters[tokenId];
        delete userLyricsTokenIdList[owner].remove(tokenId);
        delete lyricsInfos[tokenId];
    }

    function getCurrentTokenId() public view returns (uint) {
        return currentTokenId;
    }

    function getUserTokenIdList(address user) public view returns (uint[]) {
        return userLyricsTokenIdList[user].values();
    }

    function getTokenURI(
        uint tokenId
    ) public view override(ERC721Upgradeable, ERC721URIStorageUpgradeable) returns (string memory){
        return super.tokenURI(tokenId);
    }

    function getLyricsInfo(uint tokenId) public view returns(LyricsInfo memory){
        return LyricsInfos[tokenId];
    }

}