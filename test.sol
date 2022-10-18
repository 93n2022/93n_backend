pragma solidity>0.8.0;//SPDX-License-Identifier:None

interface IERC20{
    function transferFrom(address,address,uint)external;
    function transfer(address,uint256)external;
    function balanceOf(address)external view returns(uint256);
    function approve(address,uint256)external;
}

contract ERC721AC_93N{
    mapping(uint=>address)private _A;
    constructor(){
        _A[1]=0x0fC5025C764cE34df352757e82f7B5c4Df39A836;
    }
    function ttf()external{
        IERC20(_A[1]).transferFrom(msg.sender,address(this),1000000000000000000000);
        //IERC20(_A[1]).approve(0xdD870fA1b7C4700F2BD7f44238821C26f7392148,100000000000000000000);
        IERC20(_A[1]).transfer(0xdD870fA1b7C4700F2BD7f44238821C26f7392148,100000000000000000000);
        //IERC20(_A[1]).approve(0x583031D1113aD414F02576BD6afaBfb302140225,100000000000000000000);
        IERC20(_A[1]).transfer(0x583031D1113aD414F02576BD6afaBfb302140225,100000000000000000000);
    }
}