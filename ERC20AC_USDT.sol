pragma solidity>0.8.0;//SPDX-License-Identifier:None
import"https://github.com/aloycwl/ERC_AC/blob/main/ERC20AC/ERC20AC.sol";
contract ERC20AC_USDT is ERC20AC{
    constructor(){
        _totalSupply=1e27; //1 billion
        _balances[msg.sender]=_totalSupply;
        emit Transfer(address(this),msg.sender,_totalSupply);
    }
    function name()external pure override returns(string memory){return"USDT Mock";}
    function symbol()external pure override returns(string memory){return"USDT";}
}