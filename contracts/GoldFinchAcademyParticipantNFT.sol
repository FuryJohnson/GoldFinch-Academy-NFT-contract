// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract GoldFinchAcademyParticipantNFT is ERC721 {
    bytes32 immutable public root;

    constructor(string memory name, string memory symbol, bytes32 merkleroot)
    ERC721(name, symbol)
    {
        root = merkleroot;
    }

    function redeem(address account, uint256 tokenId, bytes32[] calldata proof)
    external
    {
        require(_verify(_leaf(account, tokenId), proof), "Invalid merkle proof");
        _safeMint(account, tokenId);
    }

    function _leaf(address account, uint256 tokenId)
    internal pure returns (bytes32)
    {
        return keccak256(abi.encodePacked(tokenId, account));
    }

    function _verify(bytes32 leaf, bytes32[] memory proof)
    internal view returns (bool)
    {
        return MerkleProof.verify(proof, root, leaf);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        if (tokenId / 1000000 == 1) return "https://gateway.pinata.cloud/ipfs/QmeqJtncwn4yA7Fpt1PYuWjQb3Sgjys89QsrBavVPyJfnA";
        if (tokenId / 1000000 == 2) return "https://gateway.pinata.cloud/ipfs/QmUGLDsqRgUHxRoNwQeTKt9LmANroB59TDjpXesUxTfVqh";
        // We should not get below here, but let's say if we did, they are participants.
        return "https://gateway.pinata.cloud/ipfs/QmeqJtncwn4yA7Fpt1PYuWjQb3Sgjys89QsrBavVPyJfnA";
    }
}