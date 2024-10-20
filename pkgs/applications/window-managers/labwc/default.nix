{ lib
, stdenv
, fetchFromGitHub
, cairo
, glib
, libdrm
, libinput
, libxcb
, libxkbcommon
, libxml2
, meson
, ninja
, pango
, pkg-config
, scdoc
, wayland
, wayland-protocols
, wlroots
, xwayland
}:

stdenv.mkDerivation rec {
  pname = "labwc";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = pname;
    rev = version;
    hash = "sha256-O9jVDR7UROt5u8inUsZjbzB3dQTosiLYqXkeOyGrbaM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    cairo
    glib
    libdrm
    libinput
    libxcb
    libxkbcommon
    libxml2
    pango
    wayland
    wayland-protocols
    wlroots
    xwayland
  ];

  mesonFlags = [ "-Dxwayland=enabled" ];

  meta = with lib; {
    homepage = "https://github.com/labwc/labwc";
    description = "A Wayland stacking compositor, similar to Openbox";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
