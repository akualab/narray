# Package narray

Package narray provides functions to opearate on multidimensional floating-point arrays.

Packages for types float32 and float64 are automatically generated. These options makes it
possible to find the trade offs between precision and computation speed.

The elementwise operations are also generated automatically by scraping the standard math package.

Various functions are optimized using assembly code for amd64 acrhitecture.

To easily swap the narray package in your project, import using an alias as follows:

```
import (
    narray "github.com/akualab/narray/na64"
)
```

## Download

### Type float64 package:
go get -u github.com/akualab/narray/na64

### Type float32 package:
go get -u github.com/akualab/narray/na32

## Documentation
* [Godoc na64](http://godoc.org/github.com/akualab/narray/na64)
* [Godoc na32](http://godoc.org/github.com/akualab/narray/na32)

## Code Generation
Code generation is only done by the narray package developers. End users don't have to generate any code.
```
go run genarray.go
```

## Credits

All the assembly optimization work and more was done by https://github.com/klauspost . THANKS!!
