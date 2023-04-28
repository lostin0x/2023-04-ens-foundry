// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Data {

    struct RRSet {
        string name;
        string rrtype;
        string class;
        uint256 ttl;
        RRData data;
    }

    struct RRData {
        uint256 flags;
        uint256 algorithm;
        bytes key;
    }

    struct RRSIG {
        string name;
        string rrtype;
        uint256 ttl;
        string class;
        bool flush;
        RRSIGData data;
    }

    struct RRSIGData {
        string typeCovered;
        uint256 algorithm;
        uint256 labels;
        uint256 originalTTL;
        uint256 expiration;
        uint256 inception;
        uint256 keyTag;
        string signersName;
        bytes signature;
    }

    function rootKeys(uint256 expiration, uint256 inception) public pure returns (string memory, RRSIG memory, RRSet[] memory) {
        string memory name = ".";
        RRSIG memory sig;
        sig.name = ".";
        sig.rrtype = "RRSIG";
        sig.ttl = 0;
        sig.class = "IN";
        sig.flush = false;
        sig.data.typeCovered = "DNSKEY";
        sig.data.algorithm = 253;
        sig.data.labels = 0;
        sig.data.originalTTL = 3600;
        sig.data.expiration = expiration;
        sig.data.inception = inception;
        sig.data.keyTag = 1278;
        sig.data.signersName = ".";
        sig.data.signature = new bytes(0);

        RRSet[] memory rrs = new RRSet[](3);
        rrs[0].name = ".";
        rrs[0].rrtype = "DNSKEY";
        rrs[0].class = "IN";
        rrs[0].ttl = 3600;
        rrs[0].data.flags = 0;
        rrs[0].data.algorithm = 253;
        rrs[0].data.key = hex"0000";

        rrs[1].name = ".";
        rrs[1].rrtype = "DNSKEY";
        rrs[1].class = "IN";
        rrs[1].ttl = 3600;
        rrs[1].data.flags = 0;
        rrs[1].data.algorithm = 253;
        rrs[1].data.key = hex"1112";

        rrs[2].name = ".";
        rrs[2].rrtype = "DNSKEY";
        rrs[2].class = "IN";
        rrs[2].ttl = 3600;
        rrs[2].data.flags = 0x0101;
        rrs[2].data.algorithm = 253;
        rrs[2].data.key = hex"0000";

        return (name, sig, rrs);
    }

    function testRrset(string memory name, string memory account, uint256 expiration, uint256 inception) public pure returns (RRSet memory rrset, RRSIG memory sig) {
        
        rrset.name = string(abi.encodePacked("_ens.", name));
        rrset.rrtype = "TXT";
        rrset.class = "IN";
        rrset.ttl = 3600;
        rrset.data.key = bytes(string(abi.encodePacked("a=", account)));

        
        sig.name = "test";
        sig.rrtype = "RRSIG";
        sig.ttl = 0;
        sig.class = "IN";
        sig.flush = false;
        sig.data.typeCovered = "TXT";
        sig.data.algorithm = 253;
        sig.data.labels = 2;//name.split('.').length + 1,
        sig.data.originalTTL = 3600;
        sig.data.expiration = expiration;
        sig.data.inception = inception;
        sig.data.keyTag = 1278;
        sig.data.signersName = ".";
        sig.data.signature = new bytes(0);
    }


}