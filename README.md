# Dhazzle

Dhazzle is a way of building and running the [dhall](https://github.com/dhall-lang/dhall-haskell)
interpreter using [bazel](https://bazel.build/) as the build tool.

The version of `dhall` is `1.17.0` but can be updated by editing
`third_party/haskell/BUILD.dhall`.

## Build

The command to build the `dhall` binary is:

```bash
$ bazel build @haskell_dhall//:dhall
```

This will place a binary at `bazel-bin/external/haskell_dhall/dhall`.

## Running the Interpreter

To run the command you can either run it from the previously mentioned directory, or
export it to your `$PATH`.

Example:

```bash
$ bazel-bin/external/haskell_dhall/dhall <<< "/home/user/dhall-bhat/Identity/Type"
```
