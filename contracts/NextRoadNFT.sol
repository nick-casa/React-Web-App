// SPDX-License-Identifier: MIT
/*
--------------------------------------------------------------------

██████╗  █████╗  ██████╗ ██╗   ██╗███████╗██████╗ ███████╗███████╗
██╔══██╗██╔══██╗██╔═══██╗██║   ██║██╔════╝██╔══██╗██╔════╝██╔════╝
██║  ██║███████║██║   ██║██║   ██║█████╗  ██████╔╝███████╗█████╗  
██║  ██║██╔══██║██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗╚════██║██╔══╝  
██████╔╝██║  ██║╚██████╔╝ ╚████╔╝ ███████╗██║  ██║███████║███████╗
╚═════╝ ╚═╝  ╚═╝ ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝

Contract: Next Road NFT 
Created by: Nickolas Casalinuovo
For: DAOverse Managment & Faroe Holdings 
--------------------------------------------------------------------
*/
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.6.0/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.6.0/access/AccessControl.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC20/IERC20.sol";

contract NextRoad is ERC1155, AccessControl, ERC1155Supply {
    bytes32 public constant URI_SETTER_ROLE = keccak256("URI_SETTER_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    
    struct Drop{
        Option[] options;
        uint32 opCount;
        uint32 maxOps;
    }
    struct Option{    
        uint256 price;
        uint32 quantity;
        uint256 metadata;
    }
    
    uint32 private currentDrop;
    Drop[] private collection;
    mapping (uint256 => string) private uris;
    mapping (uint256 => uint256) private tokenToDrop;
    mapping (uint256 => uint256) private tokenToOption;

    // Address of USDC contract
    address token; 
    
    constructor(address _token) ERC1155("") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN_ROLE, msg.sender);
        _grantRole(URI_SETTER_ROLE, msg.sender);
        token = _token;
    }

    function createDrop(uint32 _maxOps) private onlyRole(ADMIN_ROLE){
        //Create new drop
        Drop memory newDrop;
        newDrop.maxOps = _maxOps;
        newDrop.opCount = 0;
        //Add drop to collection
        collection.push(newDrop);
        currentDrop+=1;
    }

    function createOption(uint32 _dropID, uint256 _price, uint32 _quantity, uint256 _metadata) private onlyRole(ADMIN_ROLE){
        require(_dropID >= 0, "Not valid dropID");
        require(_dropID <= currentDrop, "Drop does not exist");
        require(collection[_dropID].opCount < collection[_dropID].maxOps, "Collection cannot take more options");
        // Create new option
        Option memory newOption;
        newOption.price = _price;
        newOption.quantity = _quantity;
        newOption.metadata = _metadata;
        // Add new option to drop
        collection[_dropID].options.push(newOption);
        collection[_dropID].opCount+=1;
    }

    // Custom URI Override
    function uri(uint256 _tokenID) override public pure returns (string memory){
        return(
            string(abi.encodePacked("https://test.ipfs.dweb.link/",Strings.toString(_tokenID),".json"))
        );
    }
    function setDropURI(uint256 _dropID, string memory _uri) public onlyRole(ADMIN_ROLE){
        uris[_dropID] = _uri;
    }

    function setURI(string memory newuri) public onlyRole(URI_SETTER_ROLE) {
        _setURI(newuri);
    }

    function mint(address _account, uint256 _dropId, uint256 _optionId, uint256 _amount) payable public {
        require(IERC20(token).balanceOf(msg.sender) >= collection[_dropId].options[_optionId].price, "Insufficient Funds");
        //require( < collection[_dropID].options[_optionId])
        IERC20(token).transferFrom(msg.sender, address(this), _amount);    
        _mint(_account, _optionId, _amount, "");
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal override(ERC1155, ERC1155Supply){
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC1155, AccessControl) returns (bool){
        return super.supportsInterface(interfaceId);
    }
    
}
