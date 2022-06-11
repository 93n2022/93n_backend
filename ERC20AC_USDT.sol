pragma solidity>0.8.0;//SPDX-License-Identifier:None
import"https://github.com/aloycwl/ERC_AC/blob/main/ERC20AC/ERC20AC.sol";
contract ERC20AC_USDT is ERC20AC{
    constructor(address a){
        _totalSupply=1e27; //1 billion
        _balances[a]=_totalSupply;
        emit Transfer(address(this),a,_totalSupply);
    }
    function name()external pure override returns(string memory){return"USDT Mock";}
    function symbol()external pure override returns(string memory){return"USDT";}
}