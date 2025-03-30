// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CertNFT {
    string public name = "DigitalCertificate";
    string public symbol = "DCERT";
    uint256 private _tokenIdCounter;

    struct Certificate {
        address issuer;
        address recipient;
        string metadataURI;
    }

    mapping(uint256 => Certificate) public certificates;
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;

    event CertificateMinted(address indexed issuer, address indexed recipient, uint256 tokenId, string metadataURI);
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    modifier onlyOwner(uint256 tokenId) {
        require(msg.sender == _owners[tokenId], "Not the owner");
        _;
    }

    function mintCertificate(address recipient, string memory metadataURI) public {
        uint256 tokenId = _tokenIdCounter++;
        _owners[tokenId] = recipient;
        _balances[recipient]++;
        certificates[tokenId] = Certificate(msg.sender, recipient, metadataURI);

        emit CertificateMinted(msg.sender, recipient, tokenId, metadataURI);
        emit Transfer(address(0), recipient, tokenId);
    }

    function transferCertificate(address to, uint256 tokenId) public onlyOwner(tokenId) {
        require(to != address(0), "Invalid recipient");

        _balances[msg.sender]--;
        _balances[to]++;
        _owners[tokenId] = to;

        emit Transfer(msg.sender, to, tokenId);
    }

    function approve(address to, uint256 tokenId) public onlyOwner(tokenId) {
        _tokenApprovals[tokenId] = to;
        emit Approval(msg.sender, to, tokenId);
    }

    function getCertificate(uint256 tokenId) public view returns (Certificate memory) {
        require(_owners[tokenId] != address(0), "Certificate does not exist");
        return certificates[tokenId];
    }

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "Zero address");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        require(_owners[tokenId] != address(0), "Token does not exist");
        return _owners[tokenId];
    }
}
