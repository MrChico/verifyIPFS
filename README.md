# verifyIPFS

Produces hashes based on content, so that one can verify that content belongs to a certain IPFS object.

Now correctly verifies content up to ~245 bytes. Working on figuring out the details of the protofbuf encoding to be able to support longer files

Usage:
Compare

```
truffle(default)> t.generateHash('999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999123456781111111111111111111111111111111ssssssssssssssssssssssssssssaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa76111111111asd\n').then(s => {console.log(web3.toAscii(s))})
Promise { <pending> }
truffle(default)> QmWVwZLYuMaa964opfQNkKrPhXrdauQ1V8B95xsgEjzGPC
```

with

```
echo '999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999123456781111111111111111111111111111111ssssssssssssssssssssssssssssaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa76111111111asd' | ipfs add -q
QmWVwZLYuMaa964opfQNkKrPhXrdauQ1V8B95xsgEjzGPC
```

notice the newline `\n` needs to be added, since echo returns the content and a newline