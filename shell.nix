{
  pkgs ? import (import ./npins).nixpkgs { },
}:
pkgs.mkShellNoCC {
  packages = [ (import ./. { inherit pkgs; }).passthru.pythonEnv ];
}
