let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable";
  pkgs = import nixpkgs {
    config = {
      allowUnfree = true;
    };
    overlays = [ ];
  };
in

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    kid3
    # (pkgs.ffmpeg.override {
    #   withFdkAac = true;
    #   withUnfree = true;
    # })
    ffmpeg
    rsgain
    mediainfo
  ];
}
