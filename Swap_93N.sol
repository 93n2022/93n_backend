pragma solidity>0.8.0;//SPDX-License-Identifier:None
interface IERC20{function transferFrom(address,address,uint)external;}
contract Swap_93N{
    uint public fee;
    address private _owner;
    mapping(address=>mapping(address=>uint[2]))public pairs;
    constructor(){
        _owner=msg.sender;
    }
    function getAmountsOut(uint a,address[]memory)external pure returns(uint[]memory c){
        c=new uint[](2);
        c[0]=a/10;
    }
    function addLiqudity(address conAddr1,address conAddr2,uint amount1,uint amount2)external{unchecked{
        require(amount1>0);
        require(amount2>0);
        require(_owner==msg.sender);
        IERC20(conAddr1).transferFrom(msg.sender,address(this),amount1);
        IERC20(conAddr2).transferFrom(msg.sender,address(this),amount2);
        (pairs[conAddr1][conAddr2][0]+=amount1,pairs[conAddr1][conAddr2][1]+=amount2,
        pairs[conAddr2][conAddr1][0]+=amount2,pairs[conAddr2][conAddr1][1]+=amount1);
    }}
    function setFee(uint percent)external{
        require(_owner==msg.sender);
        fee=percent;
    }
    function getPrice(address conAddr1,address conAddr2,uint amount)public view returns(uint){{
        return amount/pairs[conAddr1][conAddr2][0]*pairs[conAddr1][conAddr2][1];
    }}
    function exchange(address conAddr1,address conAddr2,uint amount1)external{unchecked{
        uint amount2=getPrice(conAddr1,conAddr2,amount1);
        require(amount2>0);
        require(amount2<=pairs[conAddr1][conAddr2][1]);
        IERC20(conAddr1).transferFrom(msg.sender,address(this),amount1);
        IERC20(conAddr2).transferFrom(address(this),msg.sender,amount2);
        (pairs[conAddr1][conAddr2][0]+=amount1,pairs[conAddr1][conAddr2][1]-=amount2,
        pairs[conAddr2][conAddr1][0]-=amount2,pairs[conAddr2][conAddr1][1]+=amount1);
    }}
}