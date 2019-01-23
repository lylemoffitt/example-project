{   
    pkgs ? import <nixpkgs> {},
}:
rec {
    hello = pkgs.callPackage ./code/hello { };

    libPrinter = pkgs.callPackage ./code/libPrinter { };

    test = pkgs.callPackage ./test { };


    # myProject = pkgs.stdenv.mkDerivation {
    #     name = "example-project";
    #     version = "dev-0.1";
    #     buildInputs = with pkgs; [
    #         (callPackage ./catch.nix { })
    #     ];
    # };
}