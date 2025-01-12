# Thie code demonstrates the syntax highlighting for the Nix Expression Language
let
  test = {
    dtest = 1;
  };
  literals.null = null;
  literals.boolean = true;
  literals.number = 42;
  literals.string1 = "This is a normal string";
  literals.string2 = ''
    Broken escape sequence:  \${literals.number}
    Escaped interpolation:   ''${literals.number}
    Generic escape sequence: $''\{literals.number}
  '';
  literals.paths = [
    /etc/gitconfig
    ~/.gitconfig
    .git/config
  ];
  # Note that unquoted URIs were deperecated by RFC 45
  literals.uri = "https://github.com/NixOS/rfcs/pull/45";
in
{
  inherit (literals)
    number
    string1
    string2
    paths
    uri
    ;
  nixpkgs = import <nixpkgs>;
  baseNames = map baseNameOf literals.paths;
  f =
    {
      multiply ? 1,
      add ? 0,
      ...
    }@args:
    builtins.mapAttrs (name: value: multiply * value + add) args;
}
