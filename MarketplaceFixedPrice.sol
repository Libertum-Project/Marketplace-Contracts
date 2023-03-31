// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Marketplace.sol";
import "./IFeeBeneficiary.sol";

contract MarketplaceFixedPrice is Marketplace {
    struct Listing {
        address owner;
        uint256 price;
    }
    uint public cantInList;

    event Listed(address owner, IERC721 token, uint256 tokenId, uint256 price);
    event Unlisted(address owner, IERC721 token, uint256 tokenId, bool purchased);
    event Purchased(address purchaser, address owner, IERC721 token, uint256 tokenId, uint256 price);
    FeeBeneficiary public feeContract;
    mapping(IERC721 => mapping(uint256 => Listing)) public listings;

    constructor(
        IERC721[] memory _whitelistedTokens,
        IERC20 _currency
    ) Marketplace(_whitelistedTokens, _currency) {}

    function list(
        IERC721 _token,
        uint256 _tokenId,
        uint256 _price
    ) public whenNotPaused onlyWhitelistedTokens(_token) {
        require(_token.ownerOf(_tokenId) == msg.sender, "MARKETPLACE: Caller is not token owner");
        _token.transferFrom(msg.sender, address(this), _tokenId);
        listings[_token][_tokenId] = Listing({owner: msg.sender, price: _price});
        cantInList++;
        emit Listed(msg.sender, _token, _tokenId, _price);
    }

    function listInLotes(
        IERC721 _token,
        uint256[] memory _tokenId,
        uint256[] memory _price
    ) public whenNotPaused onlyWhitelistedTokens(_token) {
        require(   
            _tokenId.length == _price.length,
            "MARKETPLACE: Cantidad de tokens y precios no coinciden"
        );
        for (uint256 i = 0; i < _tokenId.length; i++) {
            list(_token, _tokenId[i], _price[i]);
        }

    }

    function unlist(IERC721 _token, uint256 _tokenId) public onlyWhitelistedTokens(_token) {
        Listing memory listing = listings[_token][_tokenId];
        require(listing.owner == msg.sender, "MARKETPLACE: Caller is not token owner");
        _unlist(_token, _tokenId, false);
        cantInList--;
        _token.transferFrom(address(this), msg.sender, _tokenId);
    }

    function purchase(IERC721 _token, uint256 tokenId) public whenNotPaused {
        Listing memory listing = listings[_token][tokenId];
        require(listing.owner != address(0), "MARKETPLACE: tokenId not for sale");

        uint256 price = listing.price;
        uint256 resultingAmount = feeContract.chargeFeeFixedPrice(currency, price, msg.sender);
        IERC20(currency).transferFrom(msg.sender, listing.owner, resultingAmount);
        _token.transferFrom(address(this), msg.sender, tokenId);
        cantInList--;
        emit Purchased(msg.sender, listing.owner, _token, tokenId, listing.price);
        _unlist(_token, tokenId, false);
    }

    function unListInLotes(IERC721 _token, uint256[] memory _tokenId)public onlyOwner {
        Listing memory listing;
        address prevOwner;
        
        for(uint i; i < _tokenId.length; i++){
            listing = listings[_token][_tokenId[i]];
            prevOwner = listing.owner;
            _unlist(_token, _tokenId[i], false);
            cantInList--;
            _token.transferFrom(address(this), prevOwner, _tokenId[i]);
        }
    }

    function _unlist(
        IERC721 _token,
        uint256 _tokenId,
        bool _purchased
    ) internal {
        delete listings[_token][_tokenId];
        emit Unlisted(msg.sender, _token, _tokenId, _purchased);
    }

    function setFeeAddress(address _newFeecontract) public onlyOwner{
        feeContract = FeeBeneficiary(_newFeecontract);
    }
}
