pragma solidity ^0.8.0;

import {ENSRegistry} from "contracts/registry/ENSRegistry.sol";
import {Root} from "src/root/Root.sol";
import {SimplePublicSuffixList} from "src/dnsregistrar/SimplePublicSuffixList.sol";
import {DNSRegistrar} from "src/dnsregistrar/DNSRegistrar.sol";
import {PublicResolver} from "src/resolvers/PublicResolver.sol";
import "src/dnssec-oracle/DNSSECImpl.sol";
import {ReverseRegistrar} from "src/reverseRegistrar/ReverseRegistrar.sol";

import {RSASHA1Algorithm} from "src/dnssec-oracle/algorithms/RSASHA1Algorithm.sol";
import {RSASHA256Algorithm} from "src/dnssec-oracle/algorithms/RSASHA256Algorithm.sol";
import {SHA1Digest} from "src/dnssec-oracle/digests/SHA1Digest.sol";
import {SHA256Digest} from "src/dnssec-oracle/digests/SHA256Digest.sol";
import {P256SHA256Algorithm} from "src/dnssec-oracle/algorithms/P256SHA256Algorithm.sol";
import {EllipticCurve} from "src/dnssec-oracle/algorithms/EllipticCurve.sol";
import {DummyAlgorithm} from "src/dnssec-oracle/algorithms/DummyAlgorithm.sol";
import {DummyDigest} from "src/dnssec-oracle/digests/DummyDigest.sol";

contract ProtocolBase {
    ENSRegistry public ens;
    Root public root;
    SimplePublicSuffixList public suffixes;
    DNSRegistrar public registrar;
    PublicResolver public resolver;
    DNSSECImpl public dnssec;
    ReverseRegistrar public reverseRegistrar;
    RSASHA1Algorithm public rsasha1Algorithm;
    RSASHA256Algorithm public rsasha256Algorithm;
    SHA1Digest public sha1Digest;
    SHA256Digest public sha256Digest;
    P256SHA256Algorithm public p256sha256Algorithm;
    EllipticCurve public ellipticCurve;
    DummyAlgorithm public dummyAlgorithm;
    DummyDigest public dummyDigest;
}