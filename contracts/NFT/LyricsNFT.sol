// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";

//import "../interfaces/ILyricsNFT.sol";

import "../libraries/EnumerableSet.sol";

contract LyricsNFT is ERC721URIStorageUpgradeable {
    error LyricsNft__InvalidTokenUri();
    error LyricsNft__CanOnlyBeBurnedIfOwnedByMinter();

    struct LyricsInfo {
        address owner;
        string  tokenURI;
        uint    mintTime;
    }

    using EnumerableSet for EnumerableSet.UintSet;

    uint public totalSupply;
    uint public currentTokenId;
    address public minter;

    mapping(address => EnumerableSet.UintSet) userLyricsTokenIdList;
    mapping(uint => address) public minters;
    mapping(uint => LyricsInfo) public lyricsInfos;

    function initialize(address _minter) public initializer {
        __ERC721_init("Lyrics-NFT", "Lyrics");
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
        minters[currentTokenId] = to;
        userLyricsTokenIdList[to].add(currentTokenId);
        lyricsInfos[currentTokenId] = LyricsInfo(to, _tokenURI, block.number);
        emit Mint(currentTokenId, to, _tokenURI, block.number);
        return currentTokenId;
    }

    function burn(address from, uint tokenId) public {
        if (!isApprovedOrOwner(from, tokenId)) {
            revert LyricsNft__CanOnlyBeBurnedIfOwnedByMinter();
        }
        _burn(tokenId);

        address owner = minters[tokenId];

        delete minters[tokenId];
        userLyricsTokenIdList[owner].remove(tokenId);
        delete lyricsInfos[tokenId];

        emit Burn(from, tokenId);
    }

    function _setTokenURI(
        uint256 tokenId,
        string memory _tokenURI
    ) internal override(ERC721URIStorageUpgradeable) {
        super._setTokenURI(tokenId, _tokenURI);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address owner = ERC721Upgradeable.ownerOf(tokenId);
        return (spender == owner || ERC721Upgradeable.isApprovedForAll(owner, spender) || ERC721Upgradeable.getApproved(tokenId) == spender);
    }

    function getCurrentTokenId() public view returns (uint) {
        return currentTokenId;
    }

    function getUserTokenIdList(address user) public view returns (uint[] memory) {
        return userLyricsTokenIdList[user].values();
    }

    function getTokenURI(
        uint tokenId
    ) public view returns (string memory){
        return tokenURI(tokenId);
    }

    function getLyricsInfo(uint tokenId) public view returns(LyricsInfo memory){
        return lyricsInfos[tokenId];
    }

    event Mint(uint tokenId, address owner, string tokenURI, uint mintTime);
    event Burn(address from, uint256 tokenId);

}