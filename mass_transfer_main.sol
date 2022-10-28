pragma solidity>0.8.0;//SPDX-License-Identifier:None
interface IERC20{
    function transferFrom(address,address,uint)external;
}
contract Mass_Transfer{
    IERC20 I;
    constructor(address a){
        I=IERC20(a);
    }
    function load()external{
        I.transferFrom(msg.sender,address(this),1e23);
    }
    function transfer(address[]memory A)external{
        for(uint i=0;i<A.length;i++)I.transferFrom(address(this),A[i],1e20);
    }
}