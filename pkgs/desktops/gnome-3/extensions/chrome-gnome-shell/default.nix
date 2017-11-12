{stdenv, lib, python, dbus, fetchFromGitHub, cmake, coreutils, jq
, gobjectIntrospection, python27Packages, makeWrapper, gnome3
, wrapGAppsHook, p7zip }:

stdenv.mkDerivation rec {
  name="chrome-gnome-shell-${version}";
  version = "9";

  src = fetchFromGitHub {
    owner = "GNOME";
    repo = "chrome-gnome-shell";
    rev = "v${version}";
    sha256 = "1q4y53s2gnwrq5rx1gfwyh8jsc56y3wbxgbk4mjbnghyi3szc0hr";
  };

  buildInputs = [ gnome3.gnome_shell makeWrapper jq dbus gobjectIntrospection
    python27Packages.python python27Packages.requests python27Packages.pygobject3 wrapGAppsHook];

  preConfigure = ''
    mkdir build usr etc
    cd build
    ${cmake}/bin/cmake -DCMAKE_INSTALL_PREFIX=$out -DBUILD_EXTENSION=OFF ../
    substituteInPlace cmake_install.cmake --replace "/etc" "$out/etc"
  '';

  postInstall = ''
    rm $out/etc/opt/chrome/policies/managed/chrome-gnome-shell.json
    rm $out/etc/chromium/policies/managed/chrome-gnome-shell.json
    wrapProgram $out/bin/chrome-gnome-shell \
      --prefix PATH : '"${dbus}/bin"' \
      --prefix PATH : '"${gnome3.gnome_shell}/bin"' \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';
}
