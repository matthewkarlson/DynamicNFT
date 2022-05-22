//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
//deployed to 0x74DC82Ff09AD4E8623f8D62cBA438d55B4Da6F08
contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct attributes {
        uint256 topSpeed;
        uint256 acceleration;
        uint256 handling;

    }
    mapping(uint256 => attributes) private tokenAttributes;
    constructor() ERC721("ChainRacers", "CRCRS"){

    }

    function generateCharacter(uint256 tokenId) public view returns(string memory){

    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="black" />',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Racer",'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Top Speed: ",tokenAttributes[tokenId].topSpeed.toString(),"kph",'</text>',
        '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Acceleration: ",tokenAttributes[tokenId].acceleration.toString(),'</text>',
        '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Handling: ",tokenAttributes[tokenId].handling.toString(),'</text>',
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )    
    );
}



    function getTokenURI(uint256 tokenId) public view returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
}

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenAttributes[newItemId].topSpeed = random(300);
        tokenAttributes[newItemId].acceleration = random(11);
        tokenAttributes[newItemId].handling = random(11);
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function random(uint number) public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % number;
    }
    function upgradeSpeed(uint256 tokenId) public{
        require(_exists(tokenId),"Please use an existing token");
        require(ownerOf(tokenId) == msg.sender,"You must own the token to upgrade it");
        require(tokenAttributes[tokenId].handling<350,"You're at max speed!");
        uint256 currentSpeed= tokenAttributes[tokenId].topSpeed;
        tokenAttributes[tokenId].topSpeed= currentSpeed +1;
        _setTokenURI(tokenId, getTokenURI(tokenId));

    }

    function upgradeAcceleration(uint256 tokenId) public{
        require(_exists(tokenId),"Please use an existing token");
        require(ownerOf(tokenId) == msg.sender,"You must own the token to upgrade it");
        require(tokenAttributes[tokenId].acceleration<10,"You're at max acceleration!");
        uint256 currentAcceleration= tokenAttributes[tokenId].acceleration;
        tokenAttributes[tokenId].acceleration= currentAcceleration +1;
        _setTokenURI(tokenId, getTokenURI(tokenId));

    }

    function upgradeHandling(uint256 tokenId) public{
        require(_exists(tokenId),"Please use an existing token");
        require(ownerOf(tokenId) == msg.sender,"You must own the token to upgrade it");
        require(tokenAttributes[tokenId].handling<10,"You're at max handling!");
        uint256 currentHandling= tokenAttributes[tokenId].handling;
        tokenAttributes[tokenId].handling= currentHandling +1;
        _setTokenURI(tokenId, getTokenURI(tokenId));

    }

}