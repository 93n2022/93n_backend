pragma solidity>0.8.0;//SPDX-License-Identifier:None
contract Swap_93N{
    address private _owner;
    constructor(){
        _owner=msg.sender;
    }
    function getAmountsOut(uint a,address[]memory)external pure returns(uint[]memory c){
        c=new uint[](2);
        c[0]=a/10;
    }
    
}