// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WorldOfLegendsNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    string uri = "https://ipfs.moralis.io:2053/ipfs/QmTsTubCSqGAvisdSxh4LazEsbhaq2pkaCpFf6mk3PWgJv/starterpack";
    event TokenMinted(address owner, uint256 tokenId);

    constructor() ERC721("World Of Legends NFT", "WOLNFT") {}
    
    function _baseURI() internal pure override returns (string memory) {
        return "https://ipfs.moralis.io:2053/ipfs/QmTsTubCSqGAvisdSxh4LazEsbhaq2pkaCpFf6mk3PWgJv/starterpack";
    }

    function mintToken(string memory tokenURI) external onlyOwner returns (uint256)
    {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        emit TokenMinted(msg.sender, newItemId);
        return newItemId;
    }

    function defaultURI() external view returns (string memory){
        return uri;
    }

    function totalSupply() external view returns (uint256) {
        return _tokenIds.current();
    }
}