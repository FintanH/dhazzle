load(
    "@io_tweag_rules_haskell//haskell:haskell.bzl",
    "haskell_library",
    "haskell_binary",
)
load("@ai_formation_hazel//:hazel.bzl", "hazel_library")
load("@ai_formation_hazel//:third_party/cabal2bazel/bzl/cabal_paths.bzl", "cabal_paths")

haskell_binary(
    name = "dhall",
    srcs = ["dhall/Main.hs"],
    src_strip_prefix = "dhall",
    deps = [
        ":dhall-lib",
        hazel_library("base"),
    ],
    compiler_flags = ["-w"],
)

haskell_library(
    name = "dhall-lib",
    srcs = glob([
        "src/**/*.hs",
        "src/**/*.hs-boot",
    ]),
    src_strip_prefix = "src",
    deps = [
        ":paths",
        hazel_library("Diff"),
        hazel_library("ansi-terminal"),
        hazel_library("base"),
        hazel_library("bytestring"),
        hazel_library("case-insensitive"),
        hazel_library("cborg"),
        hazel_library("containers"),
        hazel_library("contravariant"),
        hazel_library("cryptonite"),
        hazel_library("directory"),
        hazel_library("exceptions"),
        hazel_library("filepath"),
        hazel_library("hashable"),
        hazel_library("haskeline"),
        hazel_library("http-client"),
        hazel_library("http-client-tls"),
        hazel_library("insert-ordered-containers"),
        hazel_library("lens-family-core"),
        hazel_library("megaparsec"),
        hazel_library("memory"),
        hazel_library("mtl"),
        hazel_library("optparse-applicative"),
        hazel_library("parsers"),
        hazel_library("prettyprinter"),
        hazel_library("prettyprinter-ansi-terminal"),
        hazel_library("repline"),
        hazel_library("scientific"),
        hazel_library("serialise"),
        hazel_library("template-haskell"),
        hazel_library("text"),
        hazel_library("transformers"),
        hazel_library("unordered-containers"),
        hazel_library("vector"),
    ],
    hidden_modules = [
        "Dhall.Import.Types",
        "Dhall.Parser.Combinators",
        "Dhall.Parser.Expression",
        "Dhall.Parser.Token",
        "Dhall.Pretty.Internal",
    ],
    visibility = ["//visibility:public"],
    compiler_flags = ["-w"],
)

cabal_paths(
    name = "paths",
    package = "dhall",
    version = [1, 17, 0],
)

