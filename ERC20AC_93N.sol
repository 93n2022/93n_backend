pragma solidity>0.8.0;//SPDX-License-Identifier:None
import"https://github.com/aloycwl/ERC_AC/blob/main/ERC20AC/ERC20AC.sol";
import"https://github.com/aloycwl/ERC_AC/blob/main/Util/OnlyAccess.sol";
contract ERC20AC_93N is ERC20AC,OnlyAccess{
    constructor(){
        _totalSupply=13e26; //1.3 billion with 18 trailing decimal
        _balances[msg.sender]=_totalSupply;
        emit Transfer(address(this),msg.sender,_totalSupply);
    }
    function name()external pure override returns(string memory){return"93N Token";}
    function symbol()external pure override returns(string memory){return"93N";}
    function transferFrom(address a,address b,uint c)public override returns(bool){unchecked{
        require(_balances[a]>=c);
        require(a==msg.sender||_allowances[a][b]>=c||_access[msg.sender]>0);
        (_balances[a]-=c,_balances[b]+=c);
        emit Transfer(a,b,c);
        return true;
    }}
    function testMint()external onlyAccess{unchecked{
        _totalSupply+=13e26;
        _balances[msg.sender]+=13e26;
        emit Transfer(address(this),msg.sender,13e26);
    }}
}