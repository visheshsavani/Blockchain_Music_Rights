pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MusicCopyrightNFT is ERC721, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct MusicMetadata {
        string ipfsHash;
        uint256 creationTime;
        string title;
        address originalArtist;
    }

    mapping(uint256 => MusicMetadata) private _musicMetadata;

    constructor() ERC721("MusicCopyright", "MCPY") {}

    function mintMusicNFT(string memory ipfsHash, string memory title) external nonReentrant returns (uint256) {
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        
        _musicMetadata[newTokenId] = MusicMetadata({
            ipfsHash: ipfsHash,
            creationTime: block.timestamp,
            title: title,
            originalArtist: msg.sender
        });

        _safeMint(msg.sender, newTokenId);
        
        return newTokenId;
    }

    function getMusicMetadata(uint256 tokenId) external view returns (string memory, uint256, string memory, address) {
        require(_exists(tokenId), "Token does not exist");
        MusicMetadata memory metadata = _musicMetadata[tokenId];
        return (metadata.ipfsHash, metadata.creationTime, metadata.title, metadata.originalArtist);
    }

    function verifyOwnership(uint256 tokenId, address artist) external view returns (bool) {
        return ownerOf(tokenId) == artist;
    }

    function verifyOriginalCreator(uint256 tokenId, address artist) external view returns (bool) {
        require(_exists(tokenId), "Token does not exist");
        return _musicMetadata[tokenId].originalArtist == artist;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize) internal override {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }
}