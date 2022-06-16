/***
[DEPLOYMENT] CHANGE TOKEN ADDRESSES

Delete nft after cashing out -owners -cidtypes -packages -popPackages
Need nft to participate
5/10/15% prorate to 3/6/9 months 
redeposit to keep alive

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
    The status to be emitted 0-in USDT, 1-in 93N, 2-stake, 3-out
    Require all the addresses to get live price from PanCakeSwap
    And to transfer using interface directly
    */
    event Payout(address indexed from,address indexed to,uint amount,uint indexed status);
    struct User{
        address upline;
        address[]downline;
        uint[]packages;
    }
    struct Packages{
        uint wallet;
        uint claimed;
        uint joined;
        uint months;
        uint deposit;
        address owner;
    }
    uint public Split;
    uint private _count;
    address private _owner;
    address private _USDT;
    address private _93N;
    address private constant _PCSV2=0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
    address private constant _TECH=0xdD870fA1b7C4700F2BD7f44238821C26f7392148;
    mapping(uint=>Packages)private _packages;
    mapping(uint=>address)private _tokenApprovals;
    mapping(address=>User)private user;
    mapping(address=>mapping(address=>bool))private _operatorApprovals;
    constructor(address _U,address _T){
        _owner=user[msg.sender].upline=msg.sender;
        (_USDT,_93N)=(_U,_T);
    }
    function supportsInterface(bytes4 a)external pure returns(bool){
        return a==type(IERC721).interfaceId||a==type(IERC721Metadata).interfaceId;
    }
    function ownerOf(uint a)public view override returns(address){
        return _packages[a].owner;
    }
    function owner()external view returns(address){
        return _owner;
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
        _packages[a].deposit>1e23?"bafybeibtgqc26sv74erbgm6grtivjvfglffol4an4nvhorbv3ljgamg4uu/black":
        _packages[a].deposit>1e22?"bafybeiaubm73azo4beh7am63wkua3zj4ijgy6n4gjc7spe3okwuxrt66t4/gold":
        "bafybeigjnlikmsm3mjvhx6ijk26bedd5lrvi3yfjlwgytzzj3h5ao6i57i/red",
        ".json"));
    }
    function transferFrom(address a,address b,uint c)public override{unchecked{
        /*
        Entire user will be duplicated to the new user
        The old user will be deleted
        */
        require(a==_packages[c].owner||getApproved(c)==a||isApprovedForAll(_packages[c].owner,a));
        (_tokenApprovals[c],_packages[c].owner)=(address(0),b);
        user[b].packages.push(c);
        popPackages(a,c);
        emit Approval(_packages[c].owner,b,c);
        emit Transfer(a,b,c);
    }}
    function Deposit(address referral,uint amount,uint months)external{unchecked{
        require(referral!=msg.sender);
        require(user[referral].upline!=address(0));
        /*
        Connect to PanCakeSwap to get the live price
        Issue the number of tokens in equivalent to USDT
        Initiate new user
        */
        /*address[]memory pair=new address[](2); 
        (pair[0],pair[1])=(_TOKEN,_USDT);
        uint[]memory currentPrice=IPCSV2(_PCSV2).getAmountsOut(amount,pair);
        (uint tokens,User storage u)=(amount/currentPrice[0],user[msg.sender]);*/
        _count++;
        (uint tokens,Packages storage p)=(amount,_packages[_count]);
        (p.months=months,p.wallet=tokens,p.joined=p.claimed=block.timestamp,p.deposit=amount,p.owner=msg.sender);
        user[msg.sender].packages.push(_count);
        /*
        Only set upline and downline when user is new
        Add user into enumUser for counting purposes
        */
        if(user[msg.sender].upline==address(0)){
            user[msg.sender].upline=referral==address(0)?_owner:referral;
            user[referral].downline.push(msg.sender);
        }
        emit Transfer(address(0),msg.sender,_count);
        /*
        Uplines & tech to get USDT 5%, 3%, 2% & tech 1%
        Uplines to get tokens 5%, 10%, 15%
        Getting uplines for payout
        */
        //(address d1,address d2,address d3)=getUplines(msg.sender); 
        //_payment(_USDT,msg.sender,msg.sender,address(this),amount,0);
        //_payment4(_USDT,address(this),msg.sender,[d1,d2,d3,_TECH],[amount*1/20,amount*3/100,amount*1/50,amount*1/100],0);
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
            _payment(con,from,usr,to[i],amt[i],status);
        }
    }}
    function Staking()external{unchecked{
        /*
        Go through every contract and pay them and their upline accordingly
        31,536,000 seconds a year=exactly 730 hours per month
        Get last claim and time joined to accurately payout
        */
        for(uint i=0;i<_count;i++){
            uint wallet=_packages[i].wallet;
            if(wallet>0){
                (address d0,uint timeLasped,uint timeJoined)=(_packages[i].owner,
                block.timestamp-_packages[i].claimed,block.timestamp-_packages[i].joined);
                /*
                As long as user still in contract
                Pro-rated payment in case this function is being called more than once a week
                Token payment direct to wallet in term of 15%, 10%, 5%
                Update user last claim if claimed
                */
                if(timeJoined+_packages[i].months*730 hours<=block.timestamp){
                    if(timeLasped>=1 hours){
                        uint amt=timeLasped/730 hours*_packages[i].wallet*(_packages[i].months/3+1)/100;
                        (address d1,address d2,address d3)=getUplines(d0);
                        _payment4(_93N,address(this),d0,[d1,d2,d3,d0],[amt*1/20,amt*1/10,amt*3/20,amt],2);
                        _packages[i].claimed=block.timestamp;
                    }
                /*
                Contract auto expire upon due
                Release to 4-3-3 in month
                Months are divided if split is modified
                */
                }else if(wallet>0){
                    //if(timeJoined>=(user[d0].months+3*Split)*730 hours)wallet=wallet/Split;
                    //else wallet*=wallet*2/5/Split;
                    //user[d0].wallet-=wallet;
                    _payment(_93N,address(this),address(this),d0,wallet,3);
                    //Pay the uplines commission too
                    //_payment4(_93N,address(this),msg.sender,[d1,d2,d3,address(0)],[tokens*1/20,tokens*1/10,tokens*3/20,0],1);
                }
            }
        }
    }}
    function SetSplit(uint num)external{
        /*
        Modifying the split to slow down the withdrawal
        */
        require(msg.sender==_owner);
        Split=num;
    }
    function getUplines(address a)private view returns(address d1,address d2,address d3){
        /*
        Get direct first
        Use previous direct to get next direct and so on
        */
        (d1=user[a].upline,d2=user[d1].upline,d3=user[d2].upline);
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
    function popPackages(address a,uint b)private{unchecked{
        for(uint i=0;i<user[a].packages.length;i++)if(user[a].packages[i]==b){
            user[a].packages[i]=user[a].packages[user[a].packages.length-1];
            user[a].packages.pop();
        }
    }}
}
