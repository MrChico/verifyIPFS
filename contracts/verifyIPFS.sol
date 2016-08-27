library IPFSVerify {
    bytes constant prefix = hex"0a0a080212";
    bytes constant postfix = hex"18";
    bytes constant ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

    function verifyHash(string contentString, bytes ipfsHash) returns (bool) {
        bytes memory content = bytes(contentString);
        bytes memory len = to_binary(content.length);
        bytes32 hash = sha256(prefix, len, content, postfix, len);
        return equal(concat(hex"1220", hexToBase58(uint256(hash))), ipfsHash);
    }
    
    function equal(bytes memory one, bytes memory two) returns (bool) {
        if (!(one.length == two.length)) {
            return false;
        }
        for (var i = 0; i<one.length; i++) {
            if (!(one[i] == two[i])) {
                return false;
            }
        }
        return true;
    }
    
    function hexToBase58(uint256 input) returns (bytes) {
        if (input < 58) {
            return byteToBytes(ALPHABET[input]);
        }
        return concat(hexToBase58(input/58), byteToBytes(ALPHABET[input % 58]));
    }
    
    function byteToBytes(byte b) returns (bytes) {
        bytes memory output = new bytes(1);
        output[0] = b;
        return output;
    }
    
    function concat(bytes byteArray, bytes byteArray2) returns (bytes) {
        bytes memory returnArray = new bytes(byteArray.length + byteArray2.length);
        for (uint16 i = 0; i < byteArray.length; i++) {
            returnArray[i] = byteArray[i];
        }
        for (i; i < (byteArray.length + byteArray2.length); i++) {
            returnArray[i] = byteArray2[i - byteArray.length];
        }
        return returnArray;
    }
    
    function to_binary(uint256 x) returns (bytes) {
        if (x == 0) {
            return new bytes(0);
        }
        else {
            byte s = byte(x % 256);
            bytes memory r = new bytes(1);
            r[0] = s;
            return concat(to_binary(x / 256), r);
        }
    }
    
}
