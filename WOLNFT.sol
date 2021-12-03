pragma solidity ^0.8.3;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WOLNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event TokenMinted(address owner, uint256 tokenId);
    event TokenBurned(address burner, uint256 tokenId);

    constructor() ERC721("World Of Legends NFT", "WOLNFT") {}

    function mintToken(string memory tokenURI)
        public
        onlyOwner
        returns (uint256)
    {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);
        emit TokenMinted(msg.sender, newItemId);
        return newItemId;
    }

    function burnToken(uint256 tokenId) public {
        _burn(tokenId);
        emit TokenBurned(msg.sender, tokenId);
    }

    function burnTokenList(uint256[] memory tokenIds) public {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            burnToken(tokenIds[i]);
        }
    }
}
