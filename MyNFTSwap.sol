// SPDX-License-Identifier: MIT  
pragma solidity ^0.8.0;  
  
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";  
import "@openzeppelin/contracts/access/Ownable.sol";  
import "@openzeppelin/contracts/utils/math/SafeMath.sol";  
  
contract NFTSwap is ERC721, Ownable {  
    using SafeMath for uint256;  
  
    struct Order {  
        uint256 price;  
        address owner;  
        bool isActive;  
    }  
  
    mapping(uint256 => Order) private orders;  
    uint256 public constant LISTING_FEE = 0;  
  
    event NFTListed(uint256 tokenId, uint256 price);  
    event NFTPurchased(uint256 tokenId, address buyer, uint256 price);  
    event OrderRevoked(uint256 tokenId);  
    event PriceUpdated(uint256 tokenId, uint256 newPrice);  
  
    constructor() ERC721("NFTSwap", "NFS") {}  
  
    function listNFT(uint256 tokenId, uint256 price) external {  
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not the owner or approved");  
        require(orders[tokenId].isActive == false, "NFT already listed");  
  
        orders[tokenId] = Order({  
            price: price,  
            owner: msg.sender,  
            isActive: true  
        });  
  
        emit NFTListed(tokenId, price);  
    }  
  
    function purchaseNFT(uint256 tokenId) external payable {  
        Order storage order = orders[tokenId];  
        require(order.isActive, "NFT is not listed");  
        require(msg.value == order.price, "Incorrect price");  
  
        _safeTransfer(order.owner, msg.sender, tokenId, "");  
  
        order.isActive = false;  
        order.price = 0;  
        order.owner = address(0);  
  
        emit NFTPurchased(tokenId, msg.sender, order.price);  
    }  
  
    function revokeListing(uint256 tokenId) external {  
        Order storage order = orders[tokenId];  
        require(order.isActive, "NFT is not listed");  
        require(order.owner == msg.sender, "Not the owner");  
  
        order.isActive = false;  
        order.price = 0;  
        order.owner = address(0);  
  
        emit OrderRevoked(tokenId);  
    }  
  
    function updatePrice(uint256 tokenId, uint256 newPrice) external {  
        Order storage order = orders[tokenId];  
        require(order.isActive, "NFT is not listed");  
        require(order.owner == msg.sender, "Not the owner");  
  
        order.price = newPrice;  
  
        emit PriceUpdated(tokenId, newPrice);  
    }  
  
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {  
        address owner = ownerOf(tokenId);  
        return (owner == spender || getApproved(tokenId) == spender);  
    }  
}
