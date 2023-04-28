const { rootKeys, hexEncodeSignedSet } = require('../utils/dnsutils.js')
const dnsAnchors = require('../test-utils/anchors.js')
const ethers = require('ethers')
const utils = require('../dnsregistrar/Helpers/Utils')
const crypto = require('crypto')
const shasum = crypto.createHash('sha1')

const validityPeriod = 2419200
const expiration = Date.now() / 1000 - 15 * 60 + validityPeriod
const inception = Date.now() / 1000 - 15 * 60
const testRrset = (name, account) => ({
    name,
    sig: {
      name: 'test',
      type: 'RRSIG',
      ttl: 0,
      class: 'IN',
      flush: false,
      data: {
        typeCovered: 'TXT',
        algorithm: 253,
        labels: name.split('.').length + 1,
        originalTTL: 3600,
        expiration,
        inception,
        keyTag: 1278,
        signersName: '.',
        signature: new Buffer([]),
      },
    },
    rrs: [
      {
        name: `_ens.${name}`,
        type: 'TXT',
        class: 'IN',
        ttl: 3600,
        data: Buffer.from(`a=${account}`, 'ascii'),
      },
    ],
  })

function proof() {
    let _proof =[
        hexEncodeSignedSet(rootKeys(expiration, inception)),
        hexEncodeSignedSet(testRrset('foo.test', process.argv[3])),
    ]
    _proof = ethers.utils.defaultAbiCoder.encode(["bytes[][]"], [_proof])
    console.log(_proof)
    return _proof
}

function anchors() {
    // let dev = hre.network.name == 'hardhat' || hre.network.name == 'local'
    // From http://data.iana.org/root-anchors/root-anchors.xml
    let _anchors = dnsAnchors.realEntries
    let dev = true
    if (dev) {
      _anchors.push(dnsAnchors.dummyEntry)
    }
    _anchors = ethers.utils.defaultAbiCoder.encode(["bytes"], [dnsAnchors.encode(_anchors)])

    console.log(_anchors)
   return _anchors
}

function hexEncodeName(name = process.argv[3]) {
  console.log(ethers.utils.defaultAbiCoder.encode(["bytes"], [utils.hexEncodeName(name)]))
}

function sha1(name= process.argv[3]) {
  shasum.update(name)
  console.log(ethers.utils.defaultAbiCoder.encode(["bytes20"], [shasum.digest('hex')]))
}

module.exports = {
    // proof: proof(),
    // anchors: anchors()
};
const functionName = process.argv[2];

// 根据参数值调用相应的函数
if (functionName === 'proof') {
    proof()
} else if (functionName === 'anchors') {
    anchors()
} else if (functionName === 'hexEncodeName') {
    hexEncodeName()
} else if (functionName === 'sha1') {
    sha1()
}