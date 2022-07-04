pragma solidity>0.8.0;//SPDX-License-Identifier:None
interface IERC20{function transferFrom(address,address,uint)external;}
contract Swap_93N{
    uint public fee=9999; //Divide by 10000 to return 99.9%
    uint private _decimal=1e18;
    address private _owner;
    mapping(address=>mapping(address=>uint))public pairs;
    constructor(){
        _owner=msg.sender;
    }
    modifier OnlyOwner(){
        require(_owner==msg.sender);_;
    }
    function addLiqudity(address[]memory a,uint[]memory amt)external payable OnlyOwner{unchecked{
        IERC20(a[0]).transferFrom(msg.sender,address(this),amt[0]);
        IERC20(a[1]).transferFrom(msg.sender,address(this),amt[1]);
        (pairs[a[0]][a[1]]+=amt[0],pairs[a[1]][a[0]]+=amt[1]);
    }}
    function RemoveLiqudity(address[]memory a,uint[]memory amt)external payable OnlyOwner{unchecked{
        require(_owner==msg.sender);
        IERC20(a[0]).transferFrom(address(this),msg.sender,amt[0]);
        IERC20(a[1]).transferFrom(address(this),msg.sender,amt[1]);
        (pairs[a[0]][a[1]]-=amt[0],pairs[a[1]][a[0]]-=amt[1]);
    }}
    function setFee(uint percent)external OnlyOwner{
        fee=percent;
    }
    function exchange(uint amt,address[]memory a)external payable{unchecked{
        uint amt2=AmountOut(amt,a);
        require(amt2>0);
        require(amt2<=pairs[a[1]][a[0]]);
        IERC20(a[0]).transferFrom(msg.sender,address(this),amt);
        IERC20(a[1]).transferFrom(address(this),msg.sender,amt2);
        (pairs[a[0]][a[1]]+=amt,pairs[a[1]][a[0]]-=amt2);
    }}
    function AmountOut(uint amt,address[]memory a)public view returns(uint amt2){{
        (uint d,uint _L1,uint _L2)=(amt%_decimal,pairs[a[0]][a[1]],pairs[a[1]][a[0]]);
        (amt-=d,amt/=_decimal);
        for(uint i=0;i<amt;i++)(_L2+=_L2*_decimal/_L1,_L1-=_decimal);
        amt2=(_L2-pairs[a[1]][a[0]])*fee/1e4+d>0?pairs[a[0]][a[1]]*d/pairs[a[1]][a[0]]*fee/1e4:0;
        amt2=(_L2-pairs[a[1]][a[0]]+(d>0?pairs[a[1]][a[0]]*d/pairs[a[0]][a[1]]*fee/1e4:0))*fee/1e4;
    }}
}
//1000000000000000000