// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    Minting Function:
    a. nft to point to an address
    b. keep track of the token ids
    c. keep track of token owners addresses to token ids
    d. keep track of how many tokens an owner address has
    e. create an event that emits a transfer log - contract address, where it is being minted to, the id

*/
contract ERC721 {
    
    // from: Contract address
    // to: user
    // tokenId: token address
    // indexed: careful use, uses more GAS !!!!!!!!!!!!!!!!!!!
    event Transfer(address indexed from, address indexed to, uint indexed tokenId);



    // Mapping from token id to the owner;
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner to number of ownder tokens;
    mapping(address => uint256) private _ownedTokensCount;

    function _exists_check(uint tokenId) internal view returns(bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    // requires that the token does not already exist
    modifier _exists(uint tokenId) {
        require(!_exists_check(tokenId), 'ERC721: Token already minted');
        _;
    }

    function _mint(address to, uint256 tokenId) internal _exists(tokenId) {
        // requires address to be not zero
        require(to != address(0), 'ERC721: mininting to the zero address');
        // adding new address with token id for minting
        _tokenOwner[tokenId] = to;
        // keeping track of each address that is minting
        _ownedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }
}
