pragma solidity>0.8.0;//SPDX-License-Identifier:None
contract Formula{
    function test(uint amount)external pure returns(uint,uint,uint){
        require(amount>=1e18);
        uint d=1e18;
        uint L1=1e5*d;
        uint L2=1e6*d;
        amount/=d;
        for(uint i=0;i<amount;i++){
            L2=(L2*d/L1);
            L1-=d;
        }
        return(L1,L2,L2/*-(1e6*d)*/);
    }
}
//11000000000000000000