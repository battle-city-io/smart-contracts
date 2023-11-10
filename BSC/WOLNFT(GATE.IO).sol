pragma solidity ^0.8.17;

contract WOLNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event TokenMinted(address owner, uint256 tokenId);
    event TokenBurned(address burner, uint256 tokenId);

    constructor() ERC721("World Of Legends NFT", "WOLNFT") {}

    function mintToken(string memory tokenURI)
    external
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

    function totalSupply() external view returns (uint256) {
        return _tokenIds.current();
    }

    function burnToken(uint256 tokenId) external onlyOwner {
        _burn(tokenId);
        emit TokenBurned(msg.sender, tokenId);
    }

    function burnTokenList(uint256[] memory tokenIds) external onlyOwner {
        for (uint256 i = 0; i < tokenIds.length; i++) {
            _burn(tokenIds[i]);
            emit TokenBurned(msg.sender, tokenIds[i]);
        }
    }
}