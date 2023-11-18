// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";

import "../interfaces/IVocalNFT.sol";

import "../libraries/EnumerableSet.sol";

contract VocalNFT is ERC721URIStorageUpgradeable, IVocalNFT {

    using EnumerableSet for EnumerableSet.UintSet;

    uint public vocalTotalSupply;
    uint public vocalCurrentTokenId;
    address public vocalMinter;

    mapping(address => EnumerableSet.UintSet) userVocalTokenIdList;
    mapping(uint => address ) public vocalMinters;
    mapping(uint => VocalInfo) public vocalInfos;

    function intializeVocalNFT(address _minter) public initializer {
        __ERC721_init("Vocal-NFT", "Vocal");
        vocalTotalSupply = 0;
        vocalCurrentTokenId = 0;
        require(_minter != address(0), "WithdrawalNFT: minter is the zero address");
        vocalMinter = _minter;
    }

    function vocalNFTMint(address to, string memory _tokenURI) public returns(uint){
        if (bytes(_tokenURI).length == 0) {
            revert VocalNFT__InvalidTokenUri();
        }
        vocalTotalSupply += 1;
        vocalCurrentTokenId += 1;
        _mint(to, vocalCurrentTokenId);
        _setTokenURI(vocalCurrentTokenId, _tokenURI);
        vocalMinters[vocalCurrentTokenId] = to;
        userVocalTokenIdList[to].add(vocalCurrentTokenId);
        vocalInfos[vocalCurrentTokenId] = VocalInfo(to, _tokenURI, block.number);
        emit VocalNFTMint(vocalCurrentTokenId, to, _tokenURI, block.number);
        return vocalCurrentTokenId;
    }

    function vocalNFTBurn(address from, uint tokenId) public {
        if(!isVocalApprovedOrOwner(from, tokenId)){
            revert VocalNFT__CanOnlyBeBurnedIfOwnedByMinter();
        }
        _burn(tokenId);

        address owner = vocalMinters[tokenId];

        delete vocalMinters[tokenId];
        userVocalTokenIdList[owner].remove(tokenId);
        delete vocalInfos[tokenId];
        vocalTotalSupply -= 1;
        emit VocalNFTBurn(from, tokenId);
    }

    function _setVocalTokenURI(
        uint256 tokenId,
        string memory _tokenURI
    ) internal {
        ERC721URIStorageUpgradeable._setTokenURI(tokenId, _tokenURI);
    }

    function isVocalApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address owner = ERC721Upgradeable.ownerOf(tokenId);
        return (spender == owner || ERC721Upgradeable.isApprovedForAll(owner, spender) || ERC721Upgradeable.getApproved(tokenId) == spender);
    }

    function getVocalNFTCurrentTokenId() public view returns (uint) {
        return vocalCurrentTokenId;
    }

    function getVocalNFTUserTokenIdList(address user) public view returns (uint[] memory){
        return userVocalTokenIdList[user].values();
    }

    function getVocalNFTTokenURI(
        uint tokenId
    ) public view returns (string memory){
        return tokenURI(tokenId);
    }

    function getVocalInfo(uint tokenId) public view returns(VocalInfo memory){
        return vocalInfos[tokenId];
    }
    
    function getVocalMinter(uint tokenId) public view returns(address){
        return vocalMinters[tokenId];
    }



}


