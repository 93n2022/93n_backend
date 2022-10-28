pragma solidity>0.8.0;//SPDX-License-Identifier:None
interface IERC20{
    function transferFrom(address,address,uint)external;
}
contract Mass_Transfer{
    IERC20 I;
    constructor(address a){
        I=IERC20(a);
    }
    function transfer(address[]memory A)external{
        I.transferFrom(msg.sender,address(this),1e22);
        for(uint i=0;i<100;i++)I.transferFrom(address(this),A[i],1e20);
    }
}