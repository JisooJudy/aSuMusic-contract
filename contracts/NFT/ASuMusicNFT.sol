// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";

import "../interfaces/IASuMusicNFT.sol";
import "../libraries/EnumerableSet.sol";
import "../utils/ASumConstant.sol";

contract ASuMusicNFT is ERC721URIStorageUpgradeable{

    using EnumerableSet for EnumerableSet.UintSet;

    uint public totalSupply;
    uint public currentTokenId;
    address public minter;

    mapping(address => EnumerableSet.UintSet) userTokenIdList;
    mapping(uint => address) public minters;
    mapping(uint => ASumConstant.ASuMusicNFTInfo) public aSuMusicNFTInfos;

    event NFTMint(uint tokenId, address owner, string tokenURI, uint mintTime);
    event NFTBurn(address from, uint256 tokenId);

    function initialize(address _minter) public initializer {
        __ERC721_init("ASuMusic-NFT", "ASMNFT");
        totalSupply = 0;
        currentTokenId = 0;
        require(_minter != address(0), "ASuMusic NFT: minter is the zero address");
        minter = _minter;
    }

    function mint(address to, string memory _tokenURI) public returns(uint) {
        if (bytes(_tokenURI).length == 0) {
            revert nft__InvalidTokenUri();
        }
        totalSupply += 1;
        currentTokenId += 1;
        _mint(to, currentTokenId);
        _setTokenURI(currentTokenId, _tokenURI);
        minters[currentTokenId] = to;
        userTokenIdList[to].add(currentTokenId);
        aSuMusicNFTInfos[currentTokenId] = ASumConstant.ASuMusicNFTInfo(to, _tokenURI, block.number);
        emit NFTMint(currentTokenId, to, _tokenURI, block.number);
        return currentTokenId;
    }

    function burn(address from, uint tokenId) public {
        if (!isApprovedOrOwner(from, tokenId)) {
            revert nft__CanOnlyBeBurnedIfOwnedByMinter();
        }
        _burn(tokenId);

        address owner = minters[tokenId];

        delete minters[tokenId];
        userTokenIdList[owner].remove(tokenId);
        delete aSuMusicNFTInfos[tokenId];
        totalSupply -= 1;
        emit NFTBurn(from, tokenId);
    }

    function _setTokenURI(
        uint256 tokenId,
        string memory _tokenURI
    ) internal override{
        super._setTokenURI(tokenId, _tokenURI);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) public view returns (bool) {
        address owner = ERC721Upgradeable.ownerOf(tokenId);
        return (spender == owner || ERC721Upgradeable.isApprovedForAll(owner, spender) || ERC721Upgradeable.getApproved(tokenId) == spender);
    }

    function getCurrentTokenId() public view returns (uint) {
        return currentTokenId;
    }

    function getUserTokenIdList(address user) public view returns (uint[] memory) {
        return userTokenIdList[user].values();
    }

    function getTokenURI(
        uint tokenId
    ) public view returns (string memory){
        return tokenURI(tokenId);
    }

    function getNFTInfo(uint tokenId) public view returns(ASumConstant.ASuMusicNFTInfo memory){
        return aSuMusicNFTInfos[tokenId];
    }

    function getMinter(uint tokenId) public view returns(address){
        return minters[tokenId];
    }

    error nft__InvalidTokenUri();
    error nft__CanOnlyBeBurnedIfOwnedByMinter();

}