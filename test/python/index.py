import hashlib
from eth_abi import encode
import argparse

def main(args): 
    if (args.type == 'sha1'): 
        sha1(args.data)
    elif (args.type == 'any'): 
        any()

def sha1(data):
    data = bytes.fromhex(data[2:])

    # 创建 SHA-1 哈希对象
    sha1 = hashlib.sha1()

    # 更新哈希对象的状态
    sha1.update(data)

    hash_value = sha1.digest()

    enc = encode(['bytes20'], [hash_value])
    ## append 0x for FFI parsing 
    print("0x" + enc.hex())

def any():
    # 输入字符串
    input_str = "0x01" 

    # 去掉 "0x" 前缀并将十六进制字符串转换为 bytes 格式
    input_bytes = bytes.fromhex(input_str[2:])

    print('输入字符串:', input_str)
    print('Bytes格式:', input_bytes)


def parse_args(): 
    parser = argparse.ArgumentParser()
    parser.add_argument("type", choices=["sha1", "any"])
    parser.add_argument("--data", type=str)
    return parser.parse_args()

if __name__ == '__main__':
    args = parse_args() 
    main(args)