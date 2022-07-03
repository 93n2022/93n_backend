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
    function addLiqudity(address conAddr1,address conAddr2,uint amount1,uint amount2)external payable OnlyOwner{unchecked{
        IERC20(conAddr1).transferFrom(msg.sender,address(this),amount1);
        IERC20(conAddr2).transferFrom(msg.sender,address(this),amount2);
        (pairs[conAddr1][conAddr2]+=amount1,pairs[conAddr2][conAddr1]+=amount2);
    }}
    function RemoveLiqudity(address conAddr1,address conAddr2,uint amount1,uint amount2)external payable OnlyOwner{unchecked{
        require(_owner==msg.sender);
        IERC20(conAddr1).transferFrom(address(this),msg.sender,amount1);
        IERC20(conAddr2).transferFrom(address(this),msg.sender,amount2);
        (pairs[conAddr1][conAddr2]-=amount1,pairs[conAddr2][conAddr1]-=amount2);
    }}
    function setFee(uint percent)external OnlyOwner{
        fee=percent;
    }
    function exchange(uint amount1,address[]memory a)external payable{unchecked{
        uint amount2=AmountOut(amount1,a);
        require(amount2>0);
        require(amount2<=pairs[a[1]][a[0]]);
        IERC20(a[0]).transferFrom(msg.sender,address(this),amount1);
        IERC20(a[1]).transferFrom(address(this),msg.sender,amount2);
        (pairs[a[0]][a[1]]+=amount1,pairs[a[1]][a[0]]-=amount2);
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