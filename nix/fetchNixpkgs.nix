{ rev                             # The Git revision of nixpkgs to fetch
, sha256                          # The SHA256 of the downloaded data

, unpackedSha256                  # With Nix 2.0, it's strongly
                                  # preferred to use
                                  # builtins.fetchTarball, which
                                  # requires the hash of the unpacked
                                  # contents.

, system ? builtins.currentSystem # This is overridable if necessary
}:

with {
  ifThenElse = { bool, thenValue, elseValue }: (
    if bool then thenValue else elseValue);
};

ifThenElse {
  bool = (0 <= builtins.compareVersions builtins.nixVersion "1.12");

  # In Nix 1.12, we can just give a `sha256` to `builtins.fetchTarball`.
  thenValue = (
    builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
      sha256 = unpackedSha256;
    });

  # This hack should at least work for Nix 1.11
  elseValue = (
    (rec {
      tarball = import <nix/fetchurl.nix> {
        url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
        inherit sha256;
      };

      builtin-paths = import <nix/config.nix>;
      
      script = builtins.toFile "nixpkgs-unpacker" ''
        "$coreutils/mkdir" "$out"
        cd "$out"
        "$gzip" --decompress < "$tarball" | "$tar" -x --strip-components=1
      '';

      nixpkgs = builtins.derivation {
        name = "nixpkgs-${builtins.substring 0 6 rev}";

        builder = builtins.storePath builtin-paths.shell;

        args = [ script ];

        inherit tarball system;

        tar       = builtins.storePath builtin-paths.tar;
        gzip      = builtins.storePath builtin-paths.gzip;
        coreutils = builtins.storePath builtin-paths.coreutils;
      };
    }).nixpkgs);
}
