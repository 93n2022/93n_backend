pragma solidity>0.8.0;//SPDX-License-Identifier:None
interface IERC20{
    function transferFrom(address,address,uint)external;
    function transfer(address,uint)external;
}
contract Mass_Transfer{

    address private C=0xd9145CCE52D386f254917e481eB44e9943F39138;
    
    function load()external{
        IERC20(C).transferFrom(msg.sender,address(this),1e23);
    }

    function T()external{unchecked{
        address[27]memory ga1=[
            0xEb31948947c46fa1B33A29122d038c575Db19F6e,
            0x05d8B19D4825409B335613E88aa1db194006eC4C,
            0x8Ee31245C4226D6afbA084360DA52bF1692Fd9f1,
            0xdde199991aD1A917BE29b92618Dbb1DaA464372e,
            0x9A1B360DDb1Dc65b9cB790138953Ca0d26d9d24B,
            0x4c0F108261cCe4527cd4C9c960d1796bf8E82987,
            0x06fDc59B36e1238499572d7421898674db2F4352,
            0x335373B9b0527C22b881d1c1904Cbf1870f4F4f1,
            0x55B56c0F3BC11b7f27638c3Ce7a191834871Fd48,
            0x6B51a3BC35A505029b4f3B2DbCC8c739D9907352,
            0x4ce5a79104120B0a6B2e9c257d98B30084336ad3,
            0x889474E058dd25E42b4C8e0C4e39c59625485c61,
            0xd915185860C732c991bE071948e24a1d01F062f6,
            0xEC7d9Ca82189cd1772176b5ec79D02c12AA927a0,
            0xFF3588411E280DF2a2CdB256BC0108DcEE551FC5,
            0x45237267E5550047de6dDF3FE78296a55E0903dc,
            0x00f5366680f9F7C4c0c26EEe7482beDd5e721d18,
            0xa09034B509d37d690E6b8952C2E6830565Ae9C3e,
            0xb1C141B6266Fb7cE459943d857FA61a00e5714Bc,
            0x32075b079fa3018C0e3De7cA2492B2F8870f4E30,
            0x72a37765BB93388B2c2f4559236f593a658ae055,
            0x5485B04bc141f8cd7b3FdE2c812545EfF4026E82,
            0x541c655fe515E4f23cEBA008aefE77f76C14704b,
            0xB3c0e740e554dD9d2d0F2Dd76Db85E637C064417,
            0x16ba7f8cF33Fa8049c37A3A46ed39Fc4B452F841,
            0x3576372Ac7631AE5eB395BAb04004aa9eD5eED47,
            0xAD548543F7Ca61b61179E7D9e78613900E10a74b];
        for(uint8 i=0;i<ga1.length;i++)IERC20(C).transfer(ga1[i],277777e16);
    }}

    function ttf(address[]memory A,address C)external{unchecked{
        for(uint8 i=0;i<100;i++)IERC20(C).transfer(A[i],1e20);
    }}
} 