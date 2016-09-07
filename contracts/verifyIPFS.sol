contract verifyIPFS {
  // prefix 0a then the length of the unixfs message then 080212
  bytes prefix1 = new bytes(1);
  bytes prefix2 = new bytes(3);
  bytes postfix = new bytes(1);
  bytes constant ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

  function verifyIPFS() {
    prefix1[0] = byte(0x0a);
    prefix2[0] = byte(0x08);
    prefix2[1] = byte(0x02);
    prefix2[2] = byte(0x12);
    postfix[0] = byte(0x18);
  }

  function generateHash(string contentString) constant returns (bytes) {
    bytes memory content = bytes(contentString);
    bytes memory len;
    bytes memory len2;
    if (content.length < 122) { //Encode length immediately
      len = to_binary(content.length);
      len2 = to_binary(6 + content.length);
      //return len;
    } else if (content.length < 128) {
      len = to_binary(content.length);
      len2 = concat(to_binary(6 + content.length), toBytes2(byte(0x01)));
    }
    else {
      len2 = concat(to_binary(8 + content.length), toBytes2(byte(0x01)));
      len = concat(to_binary(content.length), toBytes2(byte(0x01)));
      //len = concat(toBytes2(byte(0xff)), concat(toBytes2(byte(0xfd)), (to_binary(content.length / 128))));
    }
    bytes memory standardMultiHash = new bytes(2);
    standardMultiHash[0] = byte(0x12);
    standardMultiHash[1] = byte(0x20);
    //return sha256 hash of the protobuf message;
    //return concat(prefix1, concat(len2, concat(prefix2, concat(len, concat(postfix, len)))));
    return bs58(concat(standardMultiHash, toBytes(sha256(prefix1, len2, prefix2, len, content, postfix, len))));
  }

  function length(string content) constant returns (bytes) {
    return to_binary(bytes(content).length);
  }

  function toBytes(bytes32 input) returns (bytes) {
    bytes memory output = new bytes(32);
    for (uint8 i = 0; i<32; i++) {
      output[i] = input[i];
    }
    return output;
  }

  function toBytes2(byte input) returns (bytes) {
    bytes memory output = new bytes(1);
    output[0] = input;
    return output;
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

  //converts hex string to base 58
  function bs58(bytes source) returns (bytes) {
        if (source.length == 0) return new bytes(0);//;//
        uint8[] memory digits = new uint8[](48); //could be longer, but this works
        digits[0] = 0;
        uint8 digitlength = 1;
        for (var i = 0; i<source.length; ++i) {
            uint carry = uint8(source[i]);
            for (var j = 0; j<digitlength; ++j) {
                carry += uint(digits[j]) * 256;
                digits[j] = uint8(carry % 58);
                carry = carry / 58;
            }
            
            while (carry > 0) {
                digits[digitlength] = uint8(carry % 58);
                digitlength++;
                carry = carry / 58;
            }
        }
        //return digits;
        return toAlphabet(reverse(truncate(digits, digitlength)));
    }
    
    function truncate(uint8[] array, uint8 length) returns (uint8[]) {
        uint8[] memory output = new uint8[](length);
        for (var i = 0; i<length; i++) {
            output[i] = array[i];
        }
        return output;
    }
    
    function reverse(uint8[] input) returns (uint8[]) {
        uint8[] memory output = new uint8[](input.length);
        for (var i = 0; i<input.length; i++) {
            output[i] = input[input.length-1-i];
        }
        return output;
    }
    
    function toAlphabet(uint8[] indices) returns (bytes) {
        bytes memory output = new bytes(indices.length);
        for (var i = 0; i<indices.length; i++) {
            output[i] = ALPHABET[indices[i]];
        }
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
