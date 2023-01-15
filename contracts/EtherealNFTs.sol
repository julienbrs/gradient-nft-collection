// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721.sol";

error EtherealNFTs__NeedMoreEthToMint();
error EtherealNFTs__WithdrawFailed();

contract EtherealNFTs is ERC721, Ownable {
    /* NFT Variables */
    uint256 internal immutable i_mintFee;
    uint256 internal s_tokenCounter;
    bool private s_isInitialized;
    string[] internal s_tokenURIs;

    mapping(uint256 => string) public tokenURIs;

    /* Events */

    constructor(
        string[30] memory gradienttokenURIs,
        uint256 mintFee
    ) ERC721("Ethereal Gradient", "EGR") {
        i_mintFee = mintFee;
        s_tokenURIs = gradienttokenURIs;
    }

    function requestNFT() public payable {
        if (msg.value < i_mintFee) {
            revert EtherealNFTs__NeedMoreEthToMint();
        }
        s_tokenCounter++;
        bytes32 seed = keccak256(abi.encodePacked(block.number));
        uint256 idURI = seed % s_tokenURIs.length;

        setTokenURI(s_tokenCounter, s_tokenURIs[idURI]);
        _safeMint(msg.sender, s_tokenCounter);
        emit NftMinted(msg.sender, s_tokenCounter);
    }

    function setTokenURI(uint256 _tokenId, string memory _uri) public onlyOwner {
        require(_tokenId > 0, "Invalid token ID");
        tokenURIs[_tokenId] = _uri;
    }

    function withdraw() public onlyOwner {
        uint256 totalAmount = address(this).balance;
        (bool success, ) = payable(msg.sender).call{value: amount};
        if (!success) {
            revert EtherealNFTs__WithdrawFailed();
        }
    }

    function getMintFee() public view returns (uint256) {
        return i_mintFee;
    }

    function tokenURI(uint256 _tokenId) public view returns (string memory) {
        return tokenURIs[_tokenId];
    }

    function getTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }
}
