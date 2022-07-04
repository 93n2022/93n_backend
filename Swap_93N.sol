pragma solidity>0.8.0;//SPDX-License-Identifier:None
interface IERC20{function transferFrom(address,address,uint)external;}
contract Swap_93N{
    uint public fee=9999; //Divide by 10000 to return 99.9%
    address private _owner;
    mapping(address=>mapping(address=>uint))public pairs;
    constructor(){
        _owner=msg.sender;
    }
    modifier OnlyOwner(){
        require(_owner==msg.sender);_;
    }
    function AddLiqudity(address[2]memory a,uint[2]memory amt)external OnlyOwner{unchecked{
        for(uint i=0;i<2;i++){
            IERC20(a[i]).transferFrom(msg.sender,address(this),amt[i]);
            pairs[a[i>0?1:0]][a[i>0?0:1]]+=amt[i];
        }
    }}
    function RemoveLiqudity(address[2]memory a,uint[2]memory amt)external OnlyOwner{unchecked{
        for(uint i=0;i<2;i++){
            IERC20(a[i]).transferFrom(address(this),msg.sender,amt[i]);
            pairs[a[i>0?1:0]][a[i>0?0:1]]-=amt[0];
        }
    }} 
    function setFee(uint percent)external OnlyOwner{
        fee=percent;
    }
    function exchange(uint amt,address[2]memory a)external{unchecked{
        uint amt2=getAmountsOut(amt,a);
        require(amt2>0);
        require(amt2<=pairs[a[1]][a[0]]);
        IERC20(a[0]).transferFrom(msg.sender,address(this),amt);
        IERC20(a[1]).transferFrom(address(this),msg.sender,amt2);
        (pairs[a[0]][a[1]]+=amt,pairs[a[1]][a[0]]-=amt2);
    }}
    function getAmountsOut(uint amt,address[2]memory a)public view returns(uint){{
        uint _D=1e18;
        (uint d,uint _L1,uint _L2)=(amt%_D,pairs[a[0]][a[1]],pairs[a[1]][a[0]]);
        require(amt<=_L1);
        (amt-=d,amt/=_D);
        for(uint i=0;i<amt;i++)(_L2-=_L2*_D/_L1,_L1+=_D);
        return(pairs[a[1]][a[0]]-_L2+(d>0?pairs[a[1]][a[0]]*d/pairs[a[0]][a[1]]:0))*fee/1e4;
    }}
    function test()public pure returns(int){
        int a=99;
        return 80+(a*-1); 
    }
}
//1000000000000000000