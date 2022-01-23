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
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    // Mapping from token id to the owner;
    mapping(uint256 => address) private _tokenOwner;

    // Mapping from owner to number of ownder tokens;
    mapping(address => uint256) private _ownedTokensCount;

    // Mapping from token id to approved addresses
    mapping(uint256 => address) private _tokenApprovals;

    function _exists_check(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    // requires that the token does not already exist
    modifier _exists(uint256 tokenId) {
        require(!_exists_check(tokenId), "ERC721: Token already minted");
        _;
    }

    // Invalid token for address or invalid address
    modifier _invalid_address(address _owner) {
        require(
            _owner != address(0),
            "ERC721: Invalid token for address or invalid address"
        );
        _;
    }

    // Can't transfer a token the address does not own
    modifier _token_exists_for_owner(uint256 _tokenId, address _owner) {
        require(
            this.ownerOf(_tokenId) == _owner,
            "ERC721: Can't transfer a token the address does not own."
        );
        _;
    }

    function _mint(address to, uint256 tokenId)
        internal
        virtual
        _exists(tokenId)
    {
        // requires address to be not zero
        require(to != address(0), "ERC721: mininting to the zero address");
        // adding new address with token id for minting
        _tokenOwner[tokenId] = to;
        // keeping track of each address that is minting
        _ownedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal _token_exists_for_owner(_tokenId, _from) _invalid_address(_to) {
        _ownedTokensCount[_from] -= 1;
        _ownedTokensCount[_to] += 1;

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    )
        public
        payable
        _token_exists_for_owner(_tokenId, _from)
        _invalid_address(_to)
    {
        _transferFrom(_from, _to, _tokenId);
    }

    /// @notice Count all NFT's assigned to an owner
    /// @dev NFTs assgined to the zero address are considered invaild
    /// function throws for queries about the zero address
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFT's owned by '_owner', possibly zero

    function balanceOf(address _owner)
        public
        view
        _invalid_address(_owner)
        returns (uint256)
    {
        return _ownedTokensCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId)
        external
        view
        _invalid_address(_tokenOwner[_tokenId])
        returns (address)
    {
        return _tokenOwner[_tokenId];
    }

}
