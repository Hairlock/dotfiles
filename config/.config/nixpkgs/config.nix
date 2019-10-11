with import <nixpkgs> {};

let
  hie = (import (fetchFromGitHub {
                   owner="domenkozar";
                   repo="hie-nix";
                   rev="e3113da";
                   sha256="05rkzjvzywsg66iafm84xgjlkf27yfbagrdcb8sc9fd59hrzyiqk";
                 }) {}).hie84;
in
{
  allowUnfree = true;
  allowBroken = true;
  packageOverrides = pkgs: rec {

    vscode = pkgs.vscode.overrideDerivation (old: {
      postFixup = ''
        wrapProgram $out/bin/code --prefix PATH : ${lib.makeBinPath [hie]}
      '';
    });

  };
}
