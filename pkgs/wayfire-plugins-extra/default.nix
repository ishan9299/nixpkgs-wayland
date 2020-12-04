{ stdenv, meson, ninja
, fetchFromGitHub, wayfire
, wlroots, wayland, wayland-protocols
, cairo, glibmm, iio-sensor-proxy
}:

let
  metadata = import ./metadata.nix;
in
stdenv.mkDerivation rec {
  pname = "wf-config";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = pname;
    inherit (metadata) rev sha256;
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  # added glibmm and iio-sensor-proxy because it's there in the AUR PKGBUILD also
  # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=wayfire-plugins-extra-git
  buildInputs = [ wayland wayland-protocols wayfire wlroots cairo glibmm iio-sensor-proxy ];


  meta = with stdenv.lib; {
    description = "Additional plugins for Wayfire";
    homepage = https://wayfire.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ CrazedProgrammer ];
    platforms = platforms.linux;
  };
}
