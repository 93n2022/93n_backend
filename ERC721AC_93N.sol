/***
[DEPLOYMENT] CHANGE TOKEN ADDRESSES
web3 - open up 1st level first, then info only open up accordingly
***/
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
interface IERC20{function transferFrom(address,address,uint)external;function testMint()external;}
interface IPCSV2{function getAmountsOut(uint,address[]memory)external returns(uint[]memory);}
contract ERC721AC_93N is IERC721,IERC721Metadata{
    /*
    Emit status: 0-in USDT, 1-in 93N, 2-stake, 3-out
    mapping _A: 0-owner, 1-usdt, 2-93n, 3-pcsv3, 4-tech
    Require all the addresses to get live price from PanCakeSwap
    */
    event Payout(address indexed from,address indexed to,uint amount,uint indexed status);
    struct User{
        address upline;
        address[]downline;
        uint[]packages;
    }
    struct Packages{
        uint wallet;
        uint deposit;
        uint rate;
        uint claimed;
        uint joined;
        uint months;
        address owner;
    }
    uint public Split;
    uint private _count;
    mapping(uint=>Packages)public Pack;
    mapping(uint=>address)private _A;
    mapping(uint=>address)private _tokenApprovals;
    mapping(address=>User)private user;
    mapping(address=>mapping(address=>bool))private _operatorApprovals;
    constructor(address _U,address _T){
        (_A[0]=user[msg.sender].upline=msg.sender,_A[1]=_U,_A[2]=_T,
        _A[3]=0xD99D1c33F9fC3444f8101754aBC46c52416550D1,_A[4]=0xdD870fA1b7C4700F2BD7f44238821C26f7392148);
        /*
        Add permanent packages for 0 and 4 to bypass payment checking
        */
        user[_A[0]].packages.push(0);
        user[_A[4]].packages.push(0);
    }
    function supportsInterface(bytes4 a)external pure returns(bool){
        return a==type(IERC721).interfaceId||a==type(IERC721Metadata).interfaceId;
    }
    function ownerOf(uint a)public view override returns(address){
        return Pack[a].owner;
    }
    function owner()external view returns(address){
        return _A[0];
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
    function safeTransferFrom(address a,address b,uint c)external override{
        transferFrom(a,b,c);
    }
    function safeTransferFrom(address a,address b,uint c,bytes memory)external override{
        transferFrom(a,b,c);
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
        return string(abi.encodePacked("ipfs://",
        Pack[a].deposit>1e23?"bafybeibtgqc26sv74erbgm6grtivjvfglffol4an4nvhorbv3ljgamg4uu/black":
        Pack[a].deposit>1e22?"bafybeiaubm73azo4beh7am63wkua3zj4ijgy6n4gjc7spe3okwuxrt66t4/gold":
        "bafybeigjnlikmsm3mjvhx6ijk26bedd5lrvi3yfjlwgytzzj3h5ao6i57i/red",
        ".json"));
    }
    function transferFrom(address a,address b,uint c)public override{unchecked{
        /*
        Entire user will be duplicated to the new user
        The old user will be deleted
        */
        require(a==Pack[c].owner||getApproved(c)==a||isApprovedForAll(Pack[c].owner,a));
        (_tokenApprovals[c],Pack[c].owner)=(address(0),b);
        user[b].packages.push(c);
        popPackages(a,c);
        emit Approval(Pack[c].owner,b,c);
        emit Transfer(a,b,c);
    }}

    function popPackages(address a,uint b)private{unchecked{
        for(uint h=0;h<user[a].packages.length;h++)if(user[a].packages[h]==b){
            user[a].packages[h]=user[a].packages[user[a].packages.length-1];
            user[a].packages.pop();
        }
    }}
    function _payment(address con,address from,address usr,address to,uint amt,uint status)private{
        /*
        Custom connection to the various token address
        Emit events for history
        */
        IERC20(con).transferFrom(from,to,amt);
        emit Payout(usr,to,amt,status);
    }
    function _payment4(address con,address from,address usr,address[4]memory to,uint[4]memory amt,uint status)private{unchecked{
        /*
        Payout loop of 4 iterations
        Exit fuction (for payment of USDT) if no address found
        */
        for(uint i=0;i<4;i++){
            if(to[i]==address(0))return;
            if(user[to[i]].packages.length>0)_payment(con,from,usr,to[i],amt[i],status);
        }
    }}

    function Deposit(address referral,uint amount,uint months)external{unchecked{
        require(referral!=msg.sender);
        require(user[referral].upline!=address(0));
        require(months==3||months==6||months==9);
        require(amount>=1e21);
        /*
        Connect to PanCakeSwap to get the live price
        Issue the number of tokens in equivalent to USDT
        Initiate new user
        
        address[]memory pair=new address[](2); 
        (pair[0],pair[1])=(_TOKEN,_A[1]);
        uint[]memory currentPrice=IPCSV2(_A[3]).getAmountsOut(amount,pair);
        (uint tokens,User storage u)=(amount/currentPrice[0],user[msg.sender]);*/
        _count++;
        (uint tokens,Packages storage p)=(amount,Pack[_count]);
        (p.months=months,p.wallet=tokens,p.deposit=amount,p.owner=msg.sender,p.joined=p.claimed=block.timestamp);
        //TO BE CHANGED - e.g. num_of_tokens / amount
        p.rate=1;
        user[msg.sender].packages.push(_count);
        emit Transfer(address(0),msg.sender,_count);
        /*
        Only set upline and downline when user is new
        */
        if(user[msg.sender].upline==address(0)){
            user[msg.sender].upline=referral==address(0)?_A[0]:referral;
            user[referral].downline.push(msg.sender);
        }
        /*
        Uplines & tech to get USDT 5%, 3%, 2% & tech 1%
        USDT to be prorated according to months
        Getting uplines for payout
        
        TEMP DISABLED FOR TESTING
        (address d1,address d2,address d3)=getUplines(msg.sender); 
        _payment(_A[1],msg.sender,msg.sender,address(this),amount,0);
        amount*=(months/9);
        _payment4(_A[1],address(this),msg.sender,[d1,d2,d3,_A[4]],[amount*1/20,amount*3/100,amount*1/50,amount*1/100],0);
        /**/
    }}
    function Staking()external{unchecked{
        /*
        Go through every contract and pay them and their upline accordingly
        2628e3 seconds a month
        */
        for(uint i=0;i<_count;i++){
            Packages memory p=Pack[i];
            if(p.wallet>0){
                (address d0,uint expiry,uint amt,uint prm)=(p.owner,p.joined+p.months*2628e3,0,1);
                address d1=user[d0].upline;
                address d2=user[d1].upline;
                address d3=user[d2].upline;
                /*
                Token payment direct to wallet in term of 15%, 10%, 5%
                Update user's last claim if claimed
                */
                if(expiry<p.claimed){
                    amt=((block.timestamp<expiry?block.timestamp:expiry)-p.claimed)/2628e5*p.wallet*(p.months/3+1);
                    Pack[i].claimed=block.timestamp;
                }else{
                    /*
                    Contract auto expire upon due, getting amount from deposit x rate
                    Release 34%,34%,32% and split if necessary
                    Delete the contract upon last payment
                    */
                    (amt,prm)=(p.deposit*p.rate*17/50/Split,p.months/9);
                    if(amt<p.wallet){
                        amt=p.wallet;
                        delete Pack[i];
                        popPackages(p.owner,i);
                        emit Transfer(p.owner,address(0),i);
                    }else Pack[i].wallet-=amt;
                }
                _payment4(_A[2],address(this),d0,[d0,d1,d2,d3],[amt,amt*1/20*prm,amt*1/10*prm,amt*3/20*prm],3);
            }
        }
    }}
    function SetSplit(uint num)external{
        /*
        Modifying the split to slow down the withdrawal
        */
        require(msg.sender==_A[0]);
        Split=num;
    }
    
    function getDownlines(address a)external view returns(address[]memory b,address[]memory c,address[]memory d){unchecked{
        uint d2Length;
        uint d3Length;
        b=user[a].downline;
        /*
        Loop through all level 2 and level 3 downlines
        Create new array counts
        Set length and reset variables for later use
        */
        for(uint i=0;i<b.length;i++){
            address[]memory c1=user[b[i]].downline;
            d2Length+=c1.length;
            for(uint j=0;j<c1.length;j++)d3Length+=user[c1[j]].downline.length;
        }
        (c=new address[](d2Length),d=new address[](d3Length),d2Length=d3Length=0);
        /*
        Fill the count with actual address
        */
        for(uint i=0;i<b.length;i++){
            address[]memory c1=user[b[i]].downline;
            for(uint j=0;j<c1.length;j++){
                (c[d2Length]=c1[j],d2Length++);
                for(uint k=0;k<user[c1[j]].downline.length;k++)(d[d3Length]=user[c1[j]].downline[k],d3Length++);
            }
        }
    }}
    function getUserPackages(address a)external view returns(uint[]memory){
        return user[a].packages;
    }
    
}
