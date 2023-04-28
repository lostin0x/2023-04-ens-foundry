pragma solidity ^0.8.0;

import "./ProtocolBase.sol";
import "./Accounts.h.sol";
import "./Data.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "src/dnssec-oracle/SHA1.sol";

/// @notice proxy isn't used here
contract ProtocolDeploymentTest is AccountsHelper, ProtocolBase {
  Data data;
  function setUp() public {
    string[] memory names = new string[](5);
    names[0] = "deployer";
    names[1] = "admin";
    names[2] = "alice";
    names[3] = "feeTo";
    names[4] = "buyer";
    createUsers(names);

    data = new Data();

    vm.startPrank(users["deployer"].addr);
    ens = new ENSRegistry();
    reverseRegistrar = new ReverseRegistrar(ens);
    root = new Root(ens);

    bytes memory anchors = rqAnchors();
    console2.logBytes(anchors);
    dnssec = new DNSSECImpl(anchors);

    rsasha256Algorithm = new RSASHA256Algorithm();
    rsasha1Algorithm = new RSASHA1Algorithm();
    sha1Digest = new SHA1Digest();
    sha256Digest = new SHA256Digest();
    // ellipticCurve = new EllipticCurve();
    p256sha256Algorithm = new P256SHA256Algorithm();
    dummyAlgorithm = new DummyAlgorithm();
    dummyDigest = new DummyDigest();

    suffixes = new SimplePublicSuffixList();
    registrar = new DNSRegistrar(
        address(0),
        address(0),
        dnssec,
        suffixes,
        ens
    );

    if (chainId == 0){
      dnssec.setAlgorithm(253, dummyAlgorithm);
      dnssec.setAlgorithm(254, dummyAlgorithm);
      dnssec.setDigest(253, dummyDigest);
    }
    dnssec.setAlgorithm(5, rsasha1Algorithm);
    dnssec.setAlgorithm(7, rsasha1Algorithm);
    dnssec.setAlgorithm(8, rsasha256Algorithm);
    dnssec.setAlgorithm(13, p256sha256Algorithm);
    dnssec.setDigest(1, sha1Digest);
    dnssec.setDigest(2, sha256Digest);

    // resolver = new PublicResolver(ens);
    ens.setSubnodeOwner(bytes32(0), keccak256("reverse"), users["admin"].addr);
    ens.setOwner(bytes32(0), address(root));

    bytes[] memory nodeNames = new bytes[](2);
    nodeNames[0] = hexEncodeName("test");
    nodeNames[1] = hexEncodeName("co.nz");
    suffixes.addPublicSuffixes(nodeNames);

    root.setController(address(registrar), true);
    vm.stopPrank();

    vm.startPrank(users["admin"].addr);
    bytes32 subnode = keccak256(abi.encodePacked(bytes32(0), keccak256("reverse")));
    ens.setSubnodeOwner(
        subnode,
        keccak256("addr"),
        address(reverseRegistrar)
    );
    vm.stopPrank();
    
  }

  function testAny() public {
    
    bytes[][] memory proof = rqProof();
    uint256 length = proof.length;
    DNSSEC.RRSetWithSignature[] memory input = new DNSSEC.RRSetWithSignature[](length);
    for (uint256 i = 0; i < length; i++) {
      input[i] = DNSSEC.RRSetWithSignature({
        rrset: proof[i][0],
        sig: proof[i][1]
      });
    }
    vm.warp(1682170563 + 2419200);

    registrar.proveAndClaim(
      hexEncodeName("foo.test"),
      input
    );
    bytes32 parentNode = keccak256(abi.encodePacked(bytes32(0), keccak256("test")));
    bytes32 subnode = keccak256(abi.encodePacked(parentNode, keccak256("foo")));
    
    ens.setOwner(subnode, users["alice"].addr);
    assertEq(ens.owner(subnode), users["alice"].addr);
    vm.warp(1682170563 + 2419201);
    registrar.proveAndClaim(
      hexEncodeName("foo.test"),
      input
    );
    assertEq(ens.owner(subnode), address(this));
  }

  function testSha1(bytes memory name) public {
    uint256 length = name.length;
    bool isTrue = false;
    for (uint256 i = 0; i < length; i++) {
      if(name[i] != bytes1(0)){
        isTrue = true;
        break;
      }
    }
    vm.assume(isTrue);
    bytes20 hash = sha1Py(Strings.toHexString(uint256(bytes32(name))));
    assertEq(hash, SHA1.sha1(abi.encodePacked(bytes32(name))));
  }

  function rqProof() private returns (bytes[][] memory) {
      string[] memory inputs = new string[](4);
      inputs[0] = "node";
      inputs[1] = "./test/data/index.js";
      inputs[2] = "proof";
      inputs[3] = Strings.toHexString(address(this));
      return abi.decode(vm.ffi(inputs), (bytes[][]));
  }

  function rqAnchors() private returns (bytes memory) {
      string[] memory inputs = new string[](3);
      inputs[0] = "node";
      inputs[1] = "./test/data/index.js";
      inputs[2] = "anchors";
      return abi.decode(vm.ffi(inputs), (bytes));
  }

  function hexEncodeName(string memory name) private returns (bytes memory) {
      string[] memory inputs = new string[](4);
      inputs[0] = "node";
      inputs[1] = "./test/data/index.js";
      inputs[2] = "hexEncodeName";
      inputs[3] = name;
      return abi.decode(vm.ffi(inputs), (bytes));
  }

  function sha1(string memory name) private returns (bytes20) {
      string[] memory inputs = new string[](4);
      inputs[0] = "node";
      inputs[1] = "./test/data/index.js";
      inputs[2] = "sha1";
      inputs[3] = name;
      return abi.decode(vm.ffi(inputs), (bytes20));
  }

  function sha1Py(string memory name) private returns (bytes20) {
      string[] memory inputs = new string[](5);
      inputs[0] = "python3";
      inputs[1] = "./test/python/index.py";
      inputs[2] = "sha1";
      inputs[3] = "--data";
      inputs[4] = name;
      return abi.decode(vm.ffi(inputs), (bytes20));
  }
}


