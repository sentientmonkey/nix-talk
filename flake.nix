{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            fswatch
            imagemagick
            just
            nodejs
            pandoc
            texliveFull
          ];
          shellHook = ''
            npm install
            export PATH=$PATH:$(pwd)/node_modules/.bin
          '';
        };
      }
    );
}
