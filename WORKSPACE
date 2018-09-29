workspace(name = "dhazzle")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("//bzl:repo_utils.bzl", "github_http_archive")
load("//bzl:cc_configure_custom.bzl", "cc_configure_custom")

github_http_archive(
    name = "io_tweag_rules_nixpkgs",
    project = "rules_nixpkgs",
    sha = "896c2d96a70a408c545cc491974068c36f507009",
    user = "tweag",
)

load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_git_repository", "nixpkgs_package")

nixpkgs_git_repository(
    name = "nixpkgs",
    revision = "ee80654b5267b07ba10d62d143f211e0be81549e",
)

github_http_archive(
    name = "io_tweag_rules_haskell",
    project = "rules_haskell",
    sha = "edcd7c107d49ba69c96fe625161c42d4e5610d30",
    user = "tweag",
)

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

github_http_archive(
    name = "ai_formation_hazel",
    project = "hazel",
    sha = "925293994f88799ba550fd5cf3995104d1f2972c",
    user = "FormationAI",
)

load("@io_tweag_rules_haskell//haskell:repositories.bzl", "haskell_repositories")

haskell_repositories()

nixpkgs_package(
    name = "c2hs",
    attribute_path = "haskell.packages.ghc822.c2hs",
    repository = "@nixpkgs",
)

nixpkgs_package(
    name = "ghc",
    attribute_path = "haskell.packages.ghc822.ghc",
    build_file = "//:BUILD.ghc",
    repository = "@nixpkgs",
)

nixpkgs_package(
    name = "patchelf",
    attribute_path = "patchelf",
    build_file_content = """
package(default_visibility= ["//visibility:public"])

sh_binary(
  name = "patchelf",
  srcs = ["bin/patchelf"],
)
""",
    repository = "@nixpkgs",
)

nixpkgs_package(
    name = "zlib",
    build_file_content = """
package(default_visibility = ["//visibility:public"])
load("@dhazzle//bzl:repo_utils.bzl", "patched_solib")
patched_solib(name="patched_z", lib_name="z")
""",
    repository = "@nixpkgs",
)

nixpkgs_package(
    name = "zlib.dev",
    build_file_content = """
package(default_visibility = ["//visibility:public"])

filegroup (
  name = "headers",
  srcs = glob(["include/*.h"]),
)
""",
    repository = "@nixpkgs",
)

nixpkgs_package(
    name = "gcc-unwrapped.lib",
    build_file_content = """
package(default_visibility = ["//visibility:public"])
load("@dhazzle//bzl:repo_utils.bzl", "patched_solib")
patched_solib(name="patched_cpp", lib_name="stdc++")
""",
    repository = "@nixpkgs",
)

register_toolchains(
    "@ghc//:ghc",
)

nixpkgs_package(
    name = "compiler",
    nix_file = "//:nix/compiler.nix",
    repository = "@nixpkgs",
)

nixpkgs_package(
    name = "binutils",
    attribute_path = "binutils",
    repository = "@nixpkgs",
)

cc_configure_custom(
    name = "local_config_cc",
    gcc = "@compiler//:bin/gcc",
    ld = "@binutils//:bin/ld",
)

load(
    "@ai_formation_hazel//:hazel.bzl",
    "hazel_custom_package_github",
    "hazel_custom_package_hackage",
    "hazel_repositories",
)
load("//bzl:packages.bzl", "core_packages", "packages")
load("//bzl:extra_packages.bzl", "extra_packages")

hazel_repositories(
    core_packages = core_packages,
    extra_libs = {
        "z": "@zlib//:patched_z",
        "stdc++": "@gcc-unwrapped.lib//:patched_cpp",
        "c++": "@gcc-unwrapped.lib//:patched_cpp",
    },
    extra_libs_hdrs = {
        "z": "@zlib.dev//:headers",
    },
    extra_libs_strip_include_prefix = {
        "z": "/external/zlib.dev/include",
    },
    packages = packages + extra_packages,
)

# Custom packages

hazel_custom_package_hackage(
    package_name = "cborg",
    version = "0.2.0.0",
)

hazel_custom_package_hackage(
    package_name = "dhall",
    version = "1.17.0",
)

hazel_custom_package_hackage(
    package_name = "serialise",
    version = "0.2.0.0",
)

# Some of the files that Stack generates (e.g., downloads of extra-deps)
# confuse Bazel commands like `bazel build ...` because they're named BUILD
# (or "build", on macOS which is case-insensitive).
# Work around the issue by making the whole .stack-work directory a local
# repository:
# https://github.com/bazelbuild/bazel/issues/2460#issuecomment-297035644
# One disadvantage: this will be wiped out by "stack clean --full".  If you
# run into that problem, run:
#    git checkout -- .stack-work/WORKSPACE
local_repository(
    name = "ignore_stack_work",
    path = ".stack-work",
)
