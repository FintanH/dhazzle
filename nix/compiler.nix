{ pkgs ? import <nixpkgs> {} }:

let
  frameworks = pkgs.darwin.apple_sdk.frameworks;
  overrideClang = pkgs.stdenv.mkDerivation {
    name = "enhanced-clang";
    phases = [ "installPhase" ];
    installPhase = ''
        mkdir -p $out/bin
        cat > $out/bin/gcc << EOL
        #!/bin/sh
        ${pkgs.clang}/bin/clang \
            -Wno-unused-command-line-argument \
            -I${pkgs.libcxx}/include/c++/v1 \
            -L${pkgs.libcxx}/lib \
            -F${frameworks.CoreFoundation}/Library/Frameworks \
            -F${frameworks.CoreServices}/Library/Frameworks \
            -F${frameworks.Security}/Library/Frameworks \
            -F${frameworks.Foundation}/Library/Frameworks \
            -F${frameworks.IOKit}/Library/Frameworks \
            \''$@
        EOL

        chmod +x $out/bin/gcc
        '';
  };
in if pkgs.stdenv.isDarwin then overrideClang else pkgs.gcc

