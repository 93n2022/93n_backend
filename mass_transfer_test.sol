pragma solidity>0.8.0;//SPDX-License-Identifier:None
interface IERC20{
    function transferFrom(address,address,uint)external;
}
contract Mass_Transfer{
    address[4] A=[0x11E10cc175C9d6164405Adddc0438f4983BE1080
    ,0xE9Bd34bf7FA65988cEae405F239D01135c1F6b01
    ,0xc02Aa80d6FbE85B78d7b34039B80315fD0376dDC
    ,0x6Ce617317a75aCa2c9F7129bBe329BCD242c884A
    ];

    function transfer(address C)external{
        IERC20(C).transferFrom(msg.sender,address(this),4e22);
        for(uint i=0;i<4;i++)IERC20(C).transferFrom(address(this),A[i],1e22);
    }
}