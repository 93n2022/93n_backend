pragma solidity>0.8.0;//SPDX-License-Identifier:None
contract Formula{
    uint d=1e18;
    uint LP1=5e5*d;
    uint LP2=1e6*d;
    function test(uint amount)external view returns(uint,uint,uint){
        require(amount>=1e18);
        (uint L1,uint L2)=(LP1,LP2);
        amount/=d;
        for(uint i=0;i<amount;i++)(L2+=L2*d/L1,L1-=d);
        return(L1,L2,L2-LP2);
    }
    function test2()external pure returns(uint){
        return 372820010101000220220%1000000000000000000;
    }
}
//3000000000000000000