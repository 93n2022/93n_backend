pragma solidity>0.8.0;//SPDX-License-Identifier:None
interface IERC721{
    event Transfer(address indexed from,address indexed to,uint indexed tokenId);
    event Approval(address indexed owner,address indexed approved,uint indexed tokenId);
    event ApprovalForAll(address indexed owner,address indexed operator,bool approved);
    function balanceOf(address)external view returns(uint);
    function ownerOf(uint)external view returns(address);
    function safeTransferFrom(address,address,uint)external;
    function transferFrom(address,address,uint)external;
    function approve(address,uint)external;
    function getApproved(uint)external view returns(address);
    function setApprovalForAll(address,bool)external;
    function isApprovedForAll(address,address)external view returns(bool);
    function safeTransferFrom(address,address,uint,bytes calldata)external;
}
interface IERC721Metadata{
    function name()external view returns(string calldata);
    function symbol()external view returns(string calldata);
    function tokenURI(uint)external view returns(string calldata);
}
interface IERC20{
    function transferFrom(address,address,uint)external;
    function balanceOf(address)external view returns(uint256);
}
interface ISWAP{
    function getAmountsOut(uint,address,address)external view returns(uint);
}
contract Attach{
    struct User{
        address upline;
        address[]downline;  
        uint[]pack;
    }
    struct Pack{
        uint node;
        uint t93n;
        uint claimed;
        uint minted;
        address owner;
    }
    struct Node{
        uint price;
        uint count;
        uint factor; //1-3: shares, 4-5: staking %
        uint period;
        string uri;
    }
}