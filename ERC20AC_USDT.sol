//0x0000000000000000000000000000000000000000
//100000000000000000000000
//1000000000000000000
//["0xd9145CCE52D386f254917e481eB44e9943F39138","0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8","0xf8e81D47203A594245E36C48e151709F0C19fBe8","0xdD870fA1b7C4700F2BD7f44238821C26f7392148"]
//["0x53Da87bB44eBFC6479C801a26d9Ec7DaB3ce8f40","0x9df34684a23b4DC7BEe6fAF2BD9642421f1368AE","0xF67dD3206b678a9ae16544e34d9419f12237D908","0x6B62b1Dd546DE2264FC7Dd0ec32A622D2717b0c7"]
//["0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56","0xEAa78380E5a6cc865Ea92ad0407E00265791f63c","0x2d54dD6818E7da36Ce2a6755048A36c5De8D2921","0x2e0aCE0129E66A36cee92c5146C73Ec4874d0109"]

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
        _totalSupply=1e24;
        _balances[msg.sender]=_totalSupply;
        emit Transfer(address(this),msg.sender,_totalSupply);
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
        _totalSupply+=1e24;
        _balances[a]+=1e24;
        emit Transfer(address(this),a,1e24);
    }}
}