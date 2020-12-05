{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig
, wayland, wayland-protocols
, gtkmm3, wayfire, alsaLib
, gtk-layer-shell, wf-config
, libpulseaudio, glm
, librsvg
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "wf-shell";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = pname;
    inherit (metadata) rev sha256;
  };

  # This is needed as a static dependency
  # picked from
  # https://github.com/NixOS/nixpkgs/blob/3e7fae8eae52f9260d2e251d3346f4d36c0b3116/pkgs/desktops/gnome-3/core/gnome-control-center/default.nix
  prePatch = (import ./subprojects.nix {
    inherit fetchFromGitHub;
  });

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [
    # gnome3.adwaita-icon-theme
    alsaLib glm gtkmm3
    gtk-layer-shell
    libpulseaudio
    wayland librsvg
    wayland-protocols
    wayfire wf-config
  ];

  enableParallelBuilding = true;

  mesonFlags = [
    "-Dpulse=enabled" "-Dwayland-logout=true"
  ];

  meta = with stdenv.lib; {
    description = "A GTK3-based panel for wayfire";
    homepage = https://wayfire.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ CrazedProgrammer ];
    platforms = platforms.linux;
  };
}
