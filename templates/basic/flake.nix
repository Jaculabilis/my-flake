{
  inputs = {
    my-flake.url = "github:Jaculabilis/my-flake";
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, my-flake, nixpkgs }:
  let
    systems = [ "aarch64-linux" "x86_64-linux" ];
    each = system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      #packages.${system}.default = ...;

      #devShells.${system}.default = ...;
    };
  in my-flake.outputs-for each systems;
}
