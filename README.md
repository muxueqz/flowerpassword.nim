# flowerpassword.nim
Flower Password implementation for Nim.

# Build
```bash
nim c -d:release --opt:size --gc:none ./flowerpassword.nim
```

# Run
```bash
./flowerpassword --key=key --password=password
```

# seekpassword.nim
SeekPassword implementation for Nim.

# Build
```bash
nim c -d:release --opt:size --gc:none ./seekpassword.nim
```

# Run
```bash
./seekpassword --key=key --password=password
```

# Use in the Browser
see [./examples/]
```bash
nim js -d:release -o:./app.js  ./js_example.nim
```
