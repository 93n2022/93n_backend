pragma solidity>0.8.0;//SPDX-License-Identifier:None
contract ERC20AC_USDT{
    event Transfer(address indexed from,address indexed to,uint value);
    event Approval(address indexed owner,address indexed spender,uint value);
    mapping(address=>uint)internal _balances;
    mapping(address=>mapping(address=>uint))internal _allowances;
    address internal _owner;
    uint internal _totalSupply;
    constructor(){
        _owner=msg.sender;
    }
    function name()external view virtual returns(string memory){
        return"USDT Mock";
    }
    function symbol()external view virtual returns(string memory){
        return"USDT";
    }
    function decimals()external pure returns(uint){
        return 18;
    }
    function totalSupply()external view returns(uint){
        return _totalSupply;
    }
    function balanceOf(address a)external view returns(uint){
        return _balances[a];
    }
    function transfer(address a,uint b)external returns(bool){
        transferFrom(msg.sender,a,b);
        return true;
    }
    function allowance(address a,address b)external view returns(uint){
        return _allowances[a][b];
    }
    function approve(address a,uint b)external returns(bool){
        _allowances[msg.sender][a]=b;
        emit Approval(msg.sender,a,b);
        return true;
    }
    function transferFrom(address a,address b,uint c)public virtual returns(bool){unchecked{
        require(_balances[a]>=c);
        require(a==msg.sender||_allowances[a][b]>=c);
        if(_allowances[a][b]>=c)_allowances[a][b]-=c;
        (_balances[a]-=c,_balances[b]+=c);
        emit Transfer(a,b,c);
        return true;
    }}
    function MINT(address a)external{unchecked{
        _totalSupply+=1e27;
        _balances[a]+=1e27;
        emit Transfer(address(this),a,1e27);
    }}
}