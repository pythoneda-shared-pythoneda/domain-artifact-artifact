# flake.nix
#
# This file packages pythoneda-shared-artifact/domain as a Nix flake.
#
# Copyright (C) 2023-today rydnr's pythoneda-shared-artifact-def/domain
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
{
  description = "Artifact space of pythoneda-shared/domain";
  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixos.url = "github:NixOS/nixpkgs/23.11";
    pythoneda-shared-artifact-artifact-events = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-banner.follows = "pythoneda-shared-banner";
      inputs.pythoneda-shared-domain.follows = "pythoneda-shared-domain";
      url = "github:pythoneda-shared-artifact-def/artifact-events/0.0.21";
    };
    pythoneda-shared-artifact-artifact-shared = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-banner.follows = "pythoneda-shared-banner";
      inputs.pythoneda-shared-domain.follows = "pythoneda-shared-domain";
      url = "github:pythoneda-shared-artifact-def/artifact-shared/0.0.20";
    };
    pythoneda-shared-artifact-events = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-banner.follows = "pythoneda-shared-banner";
      inputs.pythoneda-shared-domain.follows = "pythoneda-shared-domain";
      url = "github:pythoneda-shared-artifact-def/events/0.0.26";
    };
    pythoneda-shared-artifact-shared = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-banner.follows = "pythoneda-shared-banner";
      inputs.pythoneda-shared-domain.follows = "pythoneda-shared-domain";
      url = "github:pythoneda-shared-artifact-def/shared/0.0.32";
    };
    pythoneda-shared-git-shared = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-banner.follows = "pythoneda-shared-banner";
      inputs.pythoneda-shared-domain.follows = "pythoneda-shared-domain";
      url = "github:pythoneda-shared-git-def/shared/0.0.25";
    };
    pythoneda-shared-nix-flake-shared = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-git-shared.follows =
        "pythoneda-shared-git-shared";
      inputs.pythoneda-shared-banner.follows = "pythoneda-shared-banner";
      inputs.pythoneda-shared-domain.follows = "pythoneda-shared-domain";
      url = "github:pythoneda-shared-nix-flake-def/shared/0.0.27";
    };
    pythoneda-shared-banner = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      url = "github:pythoneda-shared-def/banner/0.0.41";
    };
    pythoneda-shared-domain = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixos.follows = "nixos";
      inputs.pythoneda-shared-banner.follows = "pythoneda-shared-banner";
      url = "github:pythoneda-shared-def/domain/0.0.22";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        org = "pythoneda-shared-pythoneda-artifact";
        repo = "domain";
        version = "0.0.21";
        sha256 = "0ac7qc8nf249va9g05w496nhsnih63dnrgf42baq8fxi1saj0ixl";
        pname = "${org}-${repo}";
        pythonpackage = "pythoneda.artifact";
        pkgs = import nixos { inherit system; };
        description = "Artifact scope of pythoneda-shared/domain";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/${org}/${repo}";
        maintainers = with pkgs.lib.maintainers;
          [ "rydnr <github@acm-sl.org>" ];
        archRole = "B";
        space = "A";
        layer = "D";
        nixosVersion = builtins.readFile "${nixos}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixos-${nixosVersion}";
        shared = import "${pythoneda-shared-banner}/nix/shared.nix";
        pythoneda-shared-pythoneda-artifact-for = { python
          , pythoneda-shared-artifact-events
          , pythoneda-shared-artifact-artifact-events
          , pythoneda-shared-artifact-artifact-shared
          , pythoneda-shared-artifact-shared, pythoneda-shared-git-shared
          , pythoneda-shared-nix-flake-shared, pythoneda-shared-domain }:
          let
            pnameWithUnderscores =
              builtins.replaceStrings [ "-" ] [ "_" ] pname;
            pythonVersionParts = builtins.splitVersion python.version;
            pythonMajorVersion = builtins.head pythonVersionParts;
            pythonMajorMinorVersion =
              "${pythonMajorVersion}.${builtins.elemAt pythonVersionParts 1}";
            wheelName =
              "${pnameWithUnderscores}-${version}-py${pythonMajorVersion}-none-any.whl";
          in python.pkgs.buildPythonPackage rec {
            inherit pname version;
            projectDir = ./.;
            pyprojectTemplateFile = ./pyprojecttoml.template;
            pyprojectTemplate = pkgs.substituteAll {
              authors = builtins.concatStringsSep ","
                (map (item: ''"${item}"'') maintainers);
              desc = description;
              inherit homepage pname pythonMajorMinorVersion pythonpackage
                version;
              package = builtins.replaceStrings [ "." ] [ "/" ] pythonpackage;
              pythonedaSharedArtifactArtifactEvents =
                pythoneda-shared-artifact-artifact-events.version;
              pythonedaSharedArtifactArtifactShared =
                pythoneda-shared-artifact-artifact-shared.version;
              pythonedaSharedArtifactEvents =
                pythoneda-shared-artifact-events.version;
              pythonedaSharedArtifactShared =
                pythoneda-shared-artifact-shared.version;
              pythonedaSharedGitShared = pythoneda-shared-git-shared.version;
              pythonedaSharedNixFlakeShared =
                pythoneda-shared-nix-flake-shared.version;
              pythonedaSharedDomain = pythoneda-shared-domain.version;
              src = pyprojectTemplateFile;
            };
            src = pkgs.fetchFromGitHub {
              owner = org;
              rev = version;
              inherit repo sha256;
            };

            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ pip poetry-core ];
            propagatedBuildInputs = with python.pkgs; [
              pythoneda-shared-artifact-artifact-events
              pythoneda-shared-artifact-artifact-shared
              pythoneda-shared-artifact-events
              pythoneda-shared-artifact-shared
              pythoneda-shared-git-shared
              pythoneda-shared-nix-flake-shared
              pythoneda-shared-domain
            ];

            # pythonImportsCheck = [ pythonpackage ];

            unpackPhase = ''
              cp -r ${src} .
              sourceRoot=$(ls | grep -v env-vars)
              chmod +w $sourceRoot
              cp ${pyprojectTemplate} $sourceRoot/pyproject.toml
            '';

            postInstall = ''
              pushd /build/$sourceRoot
              for f in $(find . -name '__init__.py'); do
                mkdir -p $out/lib/python${pythonMajorMinorVersion}/site-packages/domain/scripts
                if [[ ! -e $out/lib/python${pythonMajorMinorVersion}/site-packages/$f ]]; then
                  cp $f $out/lib/python${pythonMajorMinorVersion}/site-packages/$f
                fi
              done
              popd
              mkdir $out/dist
              cp dist/${wheelName} $out/dist
            '';

            meta = with pkgs.lib; {
              inherit description homepage license maintainers;
            };
          };
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = pythoneda-shared-pythoneda-artifact-default;
          pythoneda-shared-pythoneda-artifact-default =
            pythoneda-shared-pythoneda-artifact-python311;
          pythoneda-shared-pythoneda-artifact-python38 = shared.devShell-for {
            banner = "${
                pythoneda-shared-banner.packages.${system}.pythoneda-shared-banner-python38
              }/bin/banner.sh";
            extra-namespaces = "";
            nixpkgs-release = nixpkgsRelease;
            package = packages.pythoneda-shared-pythoneda-artifact-python38;
            python = pkgs.python38;
            pythoneda-shared-banner =
              pythoneda-shared-banner.packages.${system}.pythoneda-shared-banner-python38;
            pythoneda-shared-domain =
              pythoneda-shared-domain.packages.${system}.pythoneda-shared-domain-python38;
            inherit archRole layer org pkgs repo space;
          };
          pythoneda-shared-pythoneda-artifact-python39 = shared.devShell-for {
            banner = "${
                pythoneda-shared-banner.packages.${system}.pythoneda-shared-banner-python39
              }/bin/banner.sh";
            extra-namespaces = "";
            nixpkgs-release = nixpkgsRelease;
            package = packages.pythoneda-shared-pythoneda-artifact-python39;
            python = pkgs.python39;
            pythoneda-shared-banner =
              pythoneda-shared-banner.packages.${system}.pythoneda-shared-banner-python39;
            pythoneda-shared-domain =
              pythoneda-shared-domain.packages.${system}.pythoneda-shared-domain-python39;
            inherit archRole layer org pkgs repo space;
          };
          pythoneda-shared-pythoneda-artifact-python310 = shared.devShell-for {
            banner = "${
                pythoneda-shared-banner.packages.${system}.pythoneda-shared-banner-python310
              }/bin/banner.sh";
            extra-namespaces = "";
            nixpkgs-release = nixpkgsRelease;
            package = packages.pythoneda-shared-pythoneda-artifact-python310;
            python = pkgs.python310;
            pythoneda-shared-banner =
              pythoneda-shared-banner.packages.${system}.pythoneda-shared-banner-python310;
            pythoneda-shared-domain =
              pythoneda-shared-domain.packages.${system}.pythoneda-shared-domain-python310;
            inherit archRole layer org pkgs repo space;
          };
          pythoneda-shared-pythoneda-artifact-python311 = shared.devShell-for {
            banner = "${
                pythoneda-shared-banner.packages.${system}.pythoneda-shared-banner-python311
              }/bin/banner.sh";
            extra-namespaces = "";
            nixpkgs-release = nixpkgsRelease;
            package = packages.pythoneda-shared-pythoneda-artifact-python311;
            python = pkgs.python311;
            pythoneda-shared-banner =
              pythoneda-shared-banner.packages.${system}.pythoneda-shared-banner-python311;
            pythoneda-shared-domain =
              pythoneda-shared-domain.packages.${system}.pythoneda-shared-domain-python311;
            inherit archRole layer org pkgs repo space;
          };
        };
        packages = rec {
          default = pythoneda-shared-pythoneda-artifact-default;
          pythoneda-shared-pythoneda-artifact-default =
            pythoneda-shared-pythoneda-artifact-python311;
          pythoneda-shared-pythoneda-artifact-python38 =
            pythoneda-shared-pythoneda-artifact-for {
              python = pkgs.python38;
              pythoneda-shared-artifact-artifact-events =
                pythoneda-shared-artifact-artifact-events.packages.${system}.pythoneda-shared-artifact-artifact-events-python38;
              pythoneda-shared-artifact-artifact-shared =
                pythoneda-shared-artifact-artifact-shared.packages.${system}.pythoneda-shared-artifact-artifact-shared-python38;
              pythoneda-shared-artifact-events =
                pythoneda-shared-artifact-events.packages.${system}.pythoneda-shared-artifact-events-python38;
              pythoneda-shared-artifact-shared =
                pythoneda-shared-artifact-shared.packages.${system}.pythoneda-shared-artifact-shared-python38;
              pythoneda-shared-git-shared =
                pythoneda-shared-git-shared.packages.${system}.pythoneda-shared-git-shared-python38;
              pythoneda-shared-nix-flake-shared =
                pythoneda-shared-nix-flake-shared.packages.${system}.pythoneda-shared-nix-flake-shared-python38;
              pythoneda-shared-domain =
                pythoneda-shared-domain.packages.${system}.pythoneda-shared-domain-python38;
            };
          pythoneda-shared-pythoneda-artifact-python39 =
            pythoneda-shared-pythoneda-artifact-for {
              python = pkgs.python39;
              pythoneda-shared-artifact-artifact-events =
                pythoneda-shared-artifact-artifact-events.packages.${system}.pythoneda-shared-artifact-artifact-events-python39;
              pythoneda-shared-artifact-artifact-shared =
                pythoneda-shared-artifact-artifact-shared.packages.${system}.pythoneda-shared-artifact-artifact-shared-python39;
              pythoneda-shared-artifact-events =
                pythoneda-shared-artifact-events.packages.${system}.pythoneda-shared-artifact-events-python39;
              pythoneda-shared-artifact-shared =
                pythoneda-shared-artifact-shared.packages.${system}.pythoneda-shared-artifact-shared-python39;
              pythoneda-shared-git-shared =
                pythoneda-shared-git-shared.packages.${system}.pythoneda-shared-git-shared-python39;
              pythoneda-shared-nix-flake-shared =
                pythoneda-shared-nix-flake-shared.packages.${system}.pythoneda-shared-nix-flake-shared-python39;
              pythoneda-shared-domain =
                pythoneda-shared-domain.packages.${system}.pythoneda-shared-domain-python39;
            };
          pythoneda-shared-pythoneda-artifact-python310 =
            pythoneda-shared-pythoneda-artifact-for {
              python = pkgs.python310;
              pythoneda-shared-artifact-artifact-events =
                pythoneda-shared-artifact-artifact-events.packages.${system}.pythoneda-shared-artifact-artifact-events-python310;
              pythoneda-shared-artifact-artifact-shared =
                pythoneda-shared-artifact-artifact-shared.packages.${system}.pythoneda-shared-artifact-artifact-shared-python310;
              pythoneda-shared-artifact-events =
                pythoneda-shared-artifact-events.packages.${system}.pythoneda-shared-artifact-events-python310;
              pythoneda-shared-artifact-shared =
                pythoneda-shared-artifact-shared.packages.${system}.pythoneda-shared-artifact-shared-python310;
              pythoneda-shared-git-shared =
                pythoneda-shared-git-shared.packages.${system}.pythoneda-shared-git-shared-python310;
              pythoneda-shared-nix-flake-shared =
                pythoneda-shared-nix-flake-shared.packages.${system}.pythoneda-shared-nix-flake-shared-python310;
              pythoneda-shared-domain =
                pythoneda-shared-domain.packages.${system}.pythoneda-shared-domain-python310;
            };
          pythoneda-shared-pythoneda-artifact-python311 =
            pythoneda-shared-pythoneda-artifact-for {
              python = pkgs.python311;
              pythoneda-shared-artifact-artifact-events =
                pythoneda-shared-artifact-artifact-events.packages.${system}.pythoneda-shared-artifact-artifact-events-python311;
              pythoneda-shared-artifact-artifact-shared =
                pythoneda-shared-artifact-artifact-shared.packages.${system}.pythoneda-shared-artifact-artifact-shared-python311;
              pythoneda-shared-artifact-events =
                pythoneda-shared-artifact-events.packages.${system}.pythoneda-shared-artifact-events-python311;
              pythoneda-shared-artifact-shared =
                pythoneda-shared-artifact-shared.packages.${system}.pythoneda-shared-artifact-shared-python311;
              pythoneda-shared-git-shared =
                pythoneda-shared-git-shared.packages.${system}.pythoneda-shared-git-shared-python311;
              pythoneda-shared-nix-flake-shared =
                pythoneda-shared-nix-flake-shared.packages.${system}.pythoneda-shared-nix-flake-shared-python311;
              pythoneda-shared-domain =
                pythoneda-shared-domain.packages.${system}.pythoneda-shared-domain-python311;
            };
        };
      });
}
