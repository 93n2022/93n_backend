pragma solidity>0.8.0;//SPDX-License-Identifier:None

contract TEST{

    struct User{
        address upline;
        address[]downline;  
        uint[]pack;
        mapping(address=>uint)groupSales;
    }

    mapping(address=>User)private user;

    constructor(){
        user[msg.sender].downline.push(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
        user[msg.sender].groupSales[0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2]+=1e21;
    }

function getGroupSales(address a)external view returns(address[]memory d,uint[]memory s){unchecked{
        (d=user[a].downline,s=new uint[](d.length));
        for(uint i;i<d.length;i++)s[i]=user[a].groupSales[d[i]];
    }}

}