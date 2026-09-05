{
  description = "flake for stacer";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
  packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "stacer";
        version = "1.7.0";

        src = ./.;
        #hardeningDisable = [ "fortify" ];

        nativeBuildInputs = with pkgs; [
          cmake
          qt6.qttools
          pkgs.qt6.wrapQtAppsHook
        ];
        buildInputs = [
          pkgs.qt6.qtbase
          pkgs.qt6.qtcharts
        ];
        cmakeBuildType = "Debug";

        meta = {
          description = "Linux System Optimizer and Monitoring";
          mainProgram = "stacer";
          platforms = pkgs.lib.platforms.linux;
        };
      };

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/stacer";
      };
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        cmake
        qt6.qttools
        qt6.qtbase
        qt6.qtcharts
      ];
    };
  };
}
