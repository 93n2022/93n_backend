pragma solidity>0.8.0;//SPDX-License-Identifier:None
interface IERC721{
    event Transfer(address indexed from,address indexed to,uint indexed tokenId);
    event Approval(address indexed owner,address indexed approved,uint indexed tokenId);
    event ApprovalForAll(address indexed owner,address indexed operator,bool approved);
    function balanceOf(address)external view returns(uint);
    function ownerOf(uint)external view returns(address);
    function safeTransferFrom(address,address,uint)external;
    function transferFrom(address,address,uint)external;
    function approve(address,uint)external;
    function getApproved(uint)external view returns(address);
    function setApprovalForAll(address,bool)external;
    function isApprovedForAll(address,address)external view returns(bool);
    function safeTransferFrom(address,address,uint,bytes calldata)external;
}
interface IERC721Metadata{
    function name()external view returns(string memory);
    function symbol()external view returns(string memory);
    function tokenURI(uint)external view returns(string memory);
}
interface IERC20{function transferFrom(address,address,uint)external;}
interface ISWAP{function getAmountsOut(uint,address,address)external view returns(uint);}
contract ERC721AC_93N is IERC721,IERC721Metadata{
    struct User{
        address upline;
        address[]downline;
        uint[]packages;
    }
    struct Pack{
        uint wallet;
        uint deposit;
        uint tokens;
        uint claimed;
        uint joined;
        address owner;
    }
    struct Node{
        uint price;
        uint count;
        uint shares;
        uint day;
        uint staking;
        uint[3]refA;
        uint[3]refB;
        string uri;
    }
    mapping(uint=>address)private _A;
    mapping(address=>User)private user;
    mapping(uint=>Pack)public pack;
    mapping(uint=>Node)public node;
    mapping(uint=>address)private _tokenApprovals;
    mapping(address=>mapping(address=>bool))private _operatorApprovals;
    uint constant P=10000; //Percentage

    constructor(address USDT,address T93N,address Swap, address Tech){
        /*
        Add permanent packages for 0 and 4 to bypass payment checking
        */
        (_A[0]=user[msg.sender].upline=msg.sender,_A[1]=USDT,_A[2]=T93N,_A[3]=Swap,_A[4]=Tech);
        user[_A[0]].packages.push(0);
        user[_A[4]].packages.push(0);
        /*
        Initial node
        1- Red Lion, 2- Green Lion, 3- Blue Lion, 4-Super Unicorn, 5-Asset Eagle
        */
        node[1].refA=node[2].refA=node[3].refA=node[4].refA=node[5].refA=[500,300,200];
        node[1].price=node[2].price=node[3].price=100;
        node[4].refB=node[5].refB=[500,500,1000];
        (node[1].count,node[1].shares,node[1].uri)=(250000,1,"bAXSCgPa1KkU9AABScYju6VxVy8F9NdPfUJxM3NsMWQt");
        (node[2].count,node[2].shares,node[2].uri)=(150000,2,"XC9ZBbRaKSVqx6bqvpBtCRgySWju2hnbT5x9sRZhheZw");
        (node[3].count,node[3].shares,node[3].uri)=(100000,3,"Z1vRU2Yf6BfZCdpTVRPzXUtoxAsxtPVjFk9aK2JxTtP2");
        (node[4].count,node[4].price,node[4].day,node[4].staking,node[4].uri)=
            (30000,1000,180,1,"cUpTRu4AehAoGLGcYCEaCz9hR6bdB8shVmnmk5nNenyy");
        (node[5].count,node[5].price,node[5].day,node[5].staking,node[5].uri)=
            (10000,5000,360,7,"bLKzHK2fCe4T8mdZ3NMk9yY4JwwNgS8gJeCfCEUmpkh7");
    }
    function supportsInterface(bytes4 a)external pure returns(bool){
        return a==type(IERC721).interfaceId||a==type(IERC721Metadata).interfaceId;
    }
    function approve(address a,uint b)external override{
        require(msg.sender==ownerOf(b)||isApprovedForAll(ownerOf(b),msg.sender));
        _tokenApprovals[b]=a;
        emit Approval(ownerOf(b),a,b);
    }
    function getApproved(uint a)public view override returns(address){
        return _tokenApprovals[a];
    }
    function setApprovalForAll(address a,bool b)external override{
        _operatorApprovals[msg.sender][a]=b;
        emit ApprovalForAll(msg.sender,a,b);
    }
    function isApprovedForAll(address a,address b)public view override returns(bool){
        return _operatorApprovals[a][b];
    }
    function ownerOf(uint a)public view override returns(address){
        return pack[a].owner;
    }
    function owner()external view returns(address){
        return _A[0];
    }
    function name()external pure override returns(string memory){
        return"Ninety Three N";
    }
    function symbol()external pure override returns(string memory){
        return"93N";
    }
    function balanceOf(address a)external view override returns(uint){
        return user[a].packages.length;
    }
    function tokenURI(uint a)external view override returns(string memory){
        return string(abi.encodePacked("ipfs://Qm",node[a].uri));
    }
    function safeTransferFrom(address a,address b,uint c)external override{
        transferFrom(a,b,c);
    }
    function safeTransferFrom(address a,address b,uint c,bytes memory)external override{
        transferFrom(a,b,c);
    }
    function transferFrom(address a,address b,uint c)public override{unchecked{
        /*
        Entire user will be duplicated to the new user
        The old user will be deleted
        */
        require(a==pack[c].owner||getApproved(c)==a||isApprovedForAll(pack[c].owner,a));
        (_tokenApprovals[c],pack[c].owner)=(address(0),b);
        user[b].packages.push(c);
        popPackages(a,c);
        emit Approval(pack[c].owner,b,c);
        emit Transfer(a,b,c);
    }}

    function popPackages(address a,uint b)private{unchecked{
        for(uint h=0;h<user[a].packages.length;h++)if(user[a].packages[h]==b){
            user[a].packages[h]=user[a].packages[user[a].packages.length-1];
            user[a].packages.pop();
        }
    }}
    function Purchase(address referral,uint node,uint count)external{unchecked{

    }}
}