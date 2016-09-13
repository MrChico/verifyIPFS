# verifyIPFS

Smart contract library functions for recreating the hash of an ipfs object given its content.

## Usage
Add the data file to IPFS:

```
ipfs add testfile -q
```

Will return:
```
QmRsjnNkEpnDdmYB7wMR7FSy1eGZ12pDuhST3iNLJTzAXF
```

Now try the same thing with the `generateHash`-function:

(truffle console)
```
truffle(default)> fs = require('fs')
truffle(default)> var verify; verifyIPFS.new().then(a => {verify = a})
truffle(default)> var testfile = fs.readFileSync('./testfile').toString()
truffle(default)> verify.generateHash(testfile).then(a => {console.log(web3.toAscii(a))})
```
returns
```
QmRsjnNkEpnDdmYB7wMR7FSy1eGZ12pDuhST3iNLJTzAXF
```

## Functions:

`generateHash` returns the IPFS-hash in byte format of a given string:
```
function generateHash(string contentString) constant returns (bytes)
```

`verifyHash` takes a string and an IPFS-hash, and returns `true` if they match:
```
function verifyHash(string contentString, string hash) constant returns (bool) {
```

`toBase58` converts `bytes` from hex format to base58:
```
function toBase58(bytes source) constant returns (bytes) {
```

## Limitations:

Does not work for IPFS objects that are in several chunks.
Contact me if you find an IPFS object in one chunk that does not work.


## Why this is useful:
This allows you to store large data files on the blockchain by their IPFS hash instead of directly in contract storage. If you at a later point need any part of the data on the blockchain, you can submit it with a transaction, validate it cryptographically using this contract and then do your computations only referring to the contents of the IPFS object in memory!

## License
See [full MIT License](LICENSE) including:
```
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```