{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{
    nixpkgs,
    treefmt-nix,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.treefmt-nix.flakeModule
      ]
      systems = ["aarch64-darwin" "x86_64-linux" "aarch64-linux" "x86_64-darwin"];

      perSystem = {
        system,
        pkgs,
        inputs',
        ...
      }: {
        devShells.default = pkgs.mkShell {
          packages = [
            # go
            pkgs.go
            pkgs.godef
            pkgs.gopls
            pkgs.golangci-lint

            # container
            pkgs.docker

            # k8s
            pkgs.kubectl
            pkgs.kind
            pkgs.kubernetes-helm
            pkgs.helmfile
          ];
        };

        treefmt = {
          projectRootFile = "flake.nix"
          programs = {
            nixpkgs-fmt.enable = true;
            gofmt.enable = true;
          };
          setting.formatter = {  };
        };
      };
    };
}
