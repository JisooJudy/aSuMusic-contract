// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";

import "../interfaces/IMelodyNFT.sol";

import "../libraries/EnumerableSet.sol";

contract MelodyNFT is ERC721URIStorageUpgradeable, IMelodyNFT {

    using EnumerableSet for EnumerableSet.UintSet;

    uint public melodyTotalSupply;
    uint public melodyCurrentTokenId;
    address public melodyMinter;

    mapping(address => EnumerableSet.UintSet) userMelodyTokenIdList;
    mapping(uint => address) public melodyMinters;
    mapping(uint => MelodyInfo) public melodyInfos;

    function initializeMelodyNFT(address _minter) public initializer {
        __ERC721_init("Melody-NFT", "Melody");
        melodyTotalSupply = 0;
        melodyCurrentTokenId = 0;
        require(_minter != address(0), "WithdrawalNFT: minter is the zero address");
        melodyMinter = _minter;
    }

    function melodyNFTMint(address to, string memory _tokenURI) public returns(uint) {
        if (bytes(_tokenURI).length == 0) {
            revert MelodyNft__InvalidTokenUri();
        }
        melodyTotalSupply += 1;
        melodyCurrentTokenId += 1;
        _mint(to, melodyCurrentTokenId);
        _setMelodyTokenURI(melodyCurrentTokenId, _tokenURI);
        melodyMinters[melodyCurrentTokenId] = to;
        userMelodyTokenIdList[to].add(melodyCurrentTokenId);
        melodyInfos[melodyCurrentTokenId] = MelodyInfo(to, _tokenURI, block.number);
        emit MelodyNFTMint(melodyCurrentTokenId, to, _tokenURI, block.number);
        return melodyCurrentTokenId;
    }

    function melodyNFTBurn(address from, uint tokenId) public {
        if (!isMelodyApprovedOrOwner(from, tokenId)) {
            revert MelodyNft__CanOnlyBeBurnedIfOwnedByMinter();
        }
        _burn(tokenId);

        address owner = melodyMinters[tokenId];

        delete melodyMinters[tokenId];
        userMelodyTokenIdList[owner].remove(tokenId);
        delete melodyInfos[tokenId];
        melodyTotalSupply -= 1;
        emit MelodyNFTBurn(from, tokenId);
    }

    function _setMelodyTokenURI(
        uint256 tokenId,
        string memory _tokenURI
    ) internal {
        ERC721URIStorageUpgradeable._setTokenURI(tokenId, _tokenURI);
    }

    function isMelodyApprovedOrOwner(address spender, uint256 tokenId) public view returns (bool) {
        address owner = ERC721Upgradeable.ownerOf(tokenId);
        return (spender == owner || ERC721Upgradeable.isApprovedForAll(owner, spender) || ERC721Upgradeable.getApproved(tokenId) == spender);
    }

    function getMelodyNFTCurrentTokenId() public view returns (uint) {
        return melodyCurrentTokenId;
    }

    function getMelodyNFTUserTokenIdList(address user) public view returns (uint[] memory) {
        return userMelodyTokenIdList[user].values();
    }

    function getMelodyNFTTokenURI(
        uint tokenId
    ) public view returns (string memory){
        return tokenURI(tokenId);
    }

    function getMelodyInfo(uint tokenId) public view returns(MelodyInfo memory){
        return melodyInfos[tokenId];
    }

    function getMelodyMinter(uint tokenId) public view returns(address){
        return melodyMinters[tokenId];
    }

}