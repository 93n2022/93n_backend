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
    function setFee(uint percent)external OnlyOwner{
        fee=percent;
    }
    function AddLiqudity(address[2]memory addr,uint[2]memory amt)external OnlyOwner{unchecked{
        for(uint i=0;i<2;i++){
            IERC20(addr[i]).transferFrom(msg.sender,address(this),amt[i]);
            pairs[addr[i>0?1:0]][addr[i>0?0:1]]+=amt[i];
        }
    }}
    function RemoveLiqudity(address[2]memory addr,uint[2]memory amt)external OnlyOwner{unchecked{
        for(uint i=0;i<2;i++){
            IERC20(addr[i]).transferFrom(address(this),msg.sender,amt[i]);
            pairs[addr[i>0?1:0]][addr[i>0?0:1]]-=amt[0];
        }
    }} 
    function exchange(uint amt,address[2]memory addr)external{unchecked{
        uint amt2=getAmountsOut(amt,addr);
        require(amt2>0);
        require(amt2<=pairs[addr[1]][addr[0]]);
        IERC20(addr[0]).transferFrom(msg.sender,address(this),amt);
        IERC20(addr[1]).transferFrom(address(this),msg.sender,amt2);
        (pairs[addr[0]][addr[1]]+=amt,pairs[addr[1]][addr[0]]-=amt2);
    }}
    function getAmountsOut(uint amt,address[2]memory addr)public view returns(uint){{
        uint _D=1e18;
        (uint d,uint _L1,uint _L2)=(amt%_D,pairs[addr[0]][addr[1]],pairs[addr[1]][addr[0]]);
        require(amt<=_L1);
        (amt-=d,amt/=_D);
        for(uint i=0;i<amt;i++)(_L2-=_L2*_D/_L1,_L1+=_D);
        return(pairs[addr[1]][addr[0]]-_L2+(d>0?pairs[addr[1]][addr[0]]*d/pairs[addr[0]][addr[1]]:0))*fee/1e4;
    }}
}
//1000000000000000000