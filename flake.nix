{
  description = "arm-linux-embedded-binutils-2.24";

  inputs = {
      nixpkgs = {
          url = github:nixos/nixpkgs?ref=nixos-23.05;
      };
  };

  outputs = { 
    self, 
    nixpkgs ,
  }: let
     system = "x86_64-linux" ;
     pkgs = import nixpkgs { inherit system; };
  in {
     packages.${system} = {
         binutils-arm-embedded = pkgs.callPackage ./. {};
         default = self.packages.${system}.binutils-arm-embedded;
     };
  };
}
