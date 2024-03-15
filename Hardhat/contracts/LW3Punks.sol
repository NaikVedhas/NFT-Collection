// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract LW3Punk is ERC721Enumerable, Ownable {
    using Strings for uint256; // This is used to convert uints to Strings

    string _baseTokenURI;

    uint public price = 0.01 ether;

    bool public paused; //This is used to pause the contract if any emergency

    uint public maxTokenIds = 10;

    uint public tokenIds; //No of NFTS minted

    modifier onlyWhenNotPaused() {
        require(!paused, "Contract is currently paused");
        _; //This _ means that "continue with the execution of the function just ignore me "
    }

    //ERC721 required Name and Symbol of our NFT collection

    constructor(string memory baseURI) ERC721("LWRPunks", "LW3P") {
        _baseTokenURI = baseURI; //We are giving
    }

    function mint() public payable onlyWhenNotPaused {
        require(tokenIds <= maxTokenIds, "Sorry, Only 10 NFTs were available");
        require(msg.value != price, "Please pay correct amount of ether");
        tokenIds++; //Pehle ++ kiya because 10 hai total and mera tokenIds ab 1 se start hoga rather than 0
        _safeMint(msg.sender, tokenIds); //safeMint mints and Nft to msg.sender with the tokenId
    }

    //There is a function called _baseURI in ERC721 which returned empty string .Now we are overiding that function with ours
    //Parent contract mein jis function ke samne virtual likha hoga only they can be overriddena and here in child contract we have to write virtual override to overide that parent contract function

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    // So this function is returning metadata of a particular tokenId. Here also we are overiding the function of ERC721


    function tokenURI(uint tokenId) public view virtual override returns (string memory) {

    require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token"); //This exists is an function from openzepplein it chceks whether tokenId exists in contract or not

    string memory baseURI = _baseURI();
    return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";

    }


    //So in this function actually we got the cid of whole folder now and we have to get the individual cid so we are first checking that length of uri is 0 or not and then once we got we are attaching /tokenIds and .json to it so that this becomes ths cid of that individual file. As we know the cid of individual file is cid of folder/name of that file/extension of file(which is json here) .Like this we are getting the exact file of that token id.And if uiris zero then just return an empty string
    //bytes means we are converting the string to byte for checking its length
    //abi.encodePacked(...): This is a function provided by Solidity's Application Binary Interface (ABI) encoder. It takes multiple arguments of different types and packs them tightly into a single byte array (bytes). It's commonly used for efficiently concatenating multiple values.
    //We concatenated baseURI, tokenId.toString(),.json all and then converts it to a string 



    function setPaused(bool val) public onlyOwner {    //This function is used to pause/unpaused the contract
        paused = val;
    }

    function withdraw() public  onlyOwner {
    
    address _owner = owner();
    uint256 amount = address(this).balance;
        (bool sent, ) =  _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");

    }

    //Yeh do fucntion not realted to NFT .ggogle karo to see what they are
    receive() external payable {}

    fallback() external payable {}


}
