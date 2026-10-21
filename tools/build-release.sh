#!/usr/bin/env bash
#
# build-release.sh -- build the distributable Linux artifacts for MDPad.
#
#   tools/build-release.sh                        # everything this machine can build
#   tools/build-release.sh --version 1.3.7
#   tools/build-release.sh --formats deb,appimage
#   tools/build-release.sh --no-build --formats deb
#
# What lands in dist/ (all amd64):
#
#   mdpad-<ver>-linux-x86_64.tar.gz        portable folder; every other format starts from it
#   mdpad_<ver>_amd64.deb                  Debian/Ubuntu (dpkg-deb, or ar+tar when it is absent)
#   mdpad-bin-<ver>-1-x86_64.pkg.tar.zst   Arch package, when makepkg is installed
#   arch/PKGBUILD, arch/.SRCINFO           AUR files (binary package, source = the release tarball)
#   mdpad-<ver>-x86_64.AppImage            AppImage type 2 (AppImageKit runtime + mksquashfs)
#   mdpad-<ver>.flatpak                    single-file bundle, when flatpak-builder is installed
#   flatpak/io.github.vhanla.MDPad.yml     Flathub-ready manifest (source = the release tarball)
#   SHA256SUMS                             checksums of the artifacts above
#
# The release is built with the GTK3 widgetset by default: a native binary then
# needs nothing but libgtk-3, which every desktop distribution and the GNOME
# Flatpak runtime already ship, so no Lazarus-specific library has to travel
# with it. --ws qt6 is supported for local testing (the AppImage then bundles
# libQt6Pas, and the deb gains Qt6 dependencies; Flatpak is skipped).
#
# Version: --version, then $VERSION, then the VERSION file. It must match
# MdVersion in mdversioninfo.pas, which is what the About box and --version print
# (the script refuses to build when they disagree).
#
# Environment overrides:
#   LAZBUILD, PCP       Lazarus lazbuild and its --pcp directory
#   WS                  widgetset (gtk3)
#   STRIP               strip the staged binary (default: auto)
#   MAINTAINER          deb Maintainer field (default: the GitHub noreply address)
#   FLATPAK_RUNTIME     org.gnome.Platform (default), FLATPAK_RUNTIME_VERSION (48)
#   APPIMAGE_RUNTIME    URL of the AppImageKit runtime-x86_64

set -euo pipefail

PROJDIR=$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." && pwd)
cd "$PROJDIR"

# ---------------------------------------------------------------------------
# Output helpers
# ---------------------------------------------------------------------------
say()  { printf '== %s\n' "$*"; }
note() { printf '   %s\n' "$*"; }
warn() { printf '!! %s\n' "$*" >&2; }
die()  { printf 'error: %s\n' "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

usage() {
  sed -n '3,40p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  exit 0
}

# ---------------------------------------------------------------------------
# Options
# ---------------------------------------------------------------------------
VERSION_ARG=""
WS="${WS:-gtk3}"
FORMATS_ARG="all"
DO_BUILD=1
KEEP=0

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)        usage ;;
    --version)        [ $# -ge 2 ] || die "--version needs a value"
                      VERSION_ARG=$2; shift 2 ;;
    --version=*)      VERSION_ARG=${1#*=}; shift ;;
    --ws)             [ $# -ge 2 ] || die "--ws needs a value"
                      WS=$2; shift 2 ;;
    --ws=*)           WS=${1#*=}; shift ;;
    --formats)        [ $# -ge 2 ] || die "--formats needs a value"
                      FORMATS_ARG=$2; shift 2 ;;
    --formats=*)      FORMATS_ARG=${1#*=}; shift ;;
    --no-build)       DO_BUILD=0; shift ;;
    --keep)           KEEP=1; shift ;;
    *)                die "unknown option: $1 (try --help)" ;;
  esac
done

case "$WS" in
  gtk3|qt6) ;;
  *) die "unsupported --ws '$WS' (gtk3 or qt6)" ;;
esac

VERSION=${VERSION_ARG:-${VERSION:-}}
if [ -z "$VERSION" ]; then
  [ -f VERSION ] || die "no VERSION file and no --version given"
  VERSION=$(tr -d '[:space:]' < VERSION)
fi
[[ $VERSION =~ ^[0-9]+(\.[0-9]+)+([._-][0-9A-Za-z]+)*$ ]] \
  || die "version '$VERSION' does not look like a release version"
# The About box builds itself from MdVersion (mdversioninfo.pas) and --version
# prints it, so a release whose VERSION disagrees would ship a lying binary.
SRC_VERSION=$(sed -n "s/^[[:space:]]*MdVersion[[:space:]]*=[[:space:]]*'\([^']*\)'.*/\1/p" mdversioninfo.pas | head -1)
[ -n "$SRC_VERSION" ] || die "MdVersion not found in mdversioninfo.pas"
[ "$SRC_VERSION" = "$VERSION" ] \
  || die "VERSION is $VERSION but MdVersion in mdversioninfo.pas is $SRC_VERSION"
DATE=${RELEASE_DATE:-$(date +%F)}
# Reproducible artifacts: the tarball is referenced by the PKGBUILD and the
# Flatpak manifest, so its hash must not change between two builds of the same
# commit. Everything is dated from the commit (or $SOURCE_DATE_EPOCH).
EPOCH=${SOURCE_DATE_EPOCH:-$(git log -1 --format=%ct 2>/dev/null || true)}
[ -n "$EPOCH" ] || EPOCH=$(date +%s)
export SOURCE_DATE_EPOCH=$EPOCH

if [ "$FORMATS_ARG" = all ]; then
  FORMATS="tar deb arch appimage flatpak"
else
  IFS=', ' read -r -a FORMATS <<< "$FORMATS_ARG"
  for f in "${FORMATS[@]}"; do
    case "$f" in
      tar|deb|arch|appimage|flatpak) ;;
      *) die "unknown format '$f' (tar, deb, arch, appimage, flatpak, all)" ;;
    esac
  done
fi
want() {
  local f
  for f in ${FORMATS[@]}; do
    [ "$f" = "$1" ] && return 0
  done
  return 1
}

[ "$(uname -m)" = x86_64 ] || die "only x86_64 releases are set up (uname -m says $(uname -m))"

DIST=$PROJDIR/dist
WORK=$DIST/.work
CACHE=$DIST/.cache
ARTIFACTS=()

say "MDPad $VERSION -- Linux x86_64 release, widgetset $WS"
note "formats: ${FORMATS[*]}"

# ---------------------------------------------------------------------------
# 1. Build
# ---------------------------------------------------------------------------
# The Release mode links into the project root (its Target has no output
# directory); the Default/Debug modes land in lib/<cpu>-<os>/. Prefer the
# release binary, because a stale Debug build must not end up in a package.
BIN=$PROJDIR/MarkDownPad
[ -x "$BIN" ] || BIN=$PROJDIR/lib/x86_64-linux/MarkDownPad

# Which widgetset a binary was linked against: the Qt6 one needs libQt6Pas.
binary_ws() {
  if readelf -d "$1" 2>/dev/null | grep -q 'libQt6Pas'; then echo qt6; else echo gtk3; fi
}

if [ "$DO_BUILD" = 1 ]; then
  LAZ=${LAZBUILD:-}
  [ -n "$LAZ" ] || LAZ=$(command -v lazbuild || true)
  [ -n "$LAZ" ] || [ ! -x "$HOME/fpcupdeluxe/lazarus/lazbuild" ] || LAZ=$HOME/fpcupdeluxe/lazarus/lazbuild
  [ -n "$LAZ" ] || die "lazbuild not found (set LAZBUILD=/path/to/lazbuild)"
  PCPARG=()
  if [ -z "${PCP:-}" ] && [ -f "$HOME/fpcupdeluxe/config_lazarus/environmentoptions.xml" ]; then
    PCP=$HOME/fpcupdeluxe/config_lazarus
  fi
  [ -z "${PCP:-}" ] || PCPARG=(--pcp="$PCP")

  say "Building Release ($WS)"
  "$LAZ" "${PCPARG[@]}" --ws="$WS" --build-mode=Release MarkDownPad.lpi
  [ -x "$BIN" ] || die "no binary at $BIN after the build"
  if [ "$(binary_ws "$BIN")" != "$WS" ]; then
    # lazbuild keeps an incremental build when only the widgetset changed;
    # a release must not mix the two, so force it once.
    say "Rebuilding from scratch for $WS"
    "$LAZ" "${PCPARG[@]}" --ws="$WS" --build-mode=Release -B MarkDownPad.lpi
  fi
fi
[ -x "$BIN" ] || die "no binary at $BIN (build it first, or drop --no-build)"
[ "$(binary_ws "$BIN")" = "$WS" ]     || die "$BIN is a $(binary_ws "$BIN") build, not $WS (rebuild without --no-build)"

LIBLXL=$PROJDIR/lib.lxl
[ -f "$LIBLXL" ] || LIBLXL=$PROJDIR/lib/x86_64-linux/lib.lxl
[ -f "$LIBLXL" ] || die "lib.lxl is missing: run tools/copy-lexlib.sh (ATSynEdit's lexlib) first"

rm -rf "$WORK"
mkdir -p "$WORK" "$DIST" "$CACHE"

# ---------------------------------------------------------------------------
# 2. Stage the common payload
# ---------------------------------------------------------------------------
DESKTOP=io.github.vhanla.MDPad.desktop
META=io.github.vhanla.MDPad.metainfo.xml
METASRC=$PROJDIR/packaging/io.github.vhanla.MDPad.metainfo.xml.in
METAOUT=$WORK/$META
sed -e "s/@VERSION@/$VERSION/g" -e "s/@DATE@/$DATE/g" "$METASRC" > "$METAOUT"

PAYLOAD=$WORK/payload
mkdir -p "$PAYLOAD"

stage_payload() { # $1 = directory that gets the files the app reads next to itself
  install -m 755 "$BIN" "$1/mdpad"
  if [ "${STRIP:-auto}" != "no" ] && have strip; then
    strip --strip-unneeded "$1/mdpad" 2>/dev/null || true
  fi
  install -m 644 "$LIBLXL" "$1/lib.lxl"
  install -m 644 "$PROJDIR/Theme.json" "$PROJDIR/style.css" "$1/"
  # The About box and the first start look for this exact spelling.
  install -m 644 "$PROJDIR/README.md" "$1/Readme.md"
  install -m 644 "$PROJDIR/LICENSE" "$1/LICENSE"
  # Copyright notices and license texts of the bundled libraries. The About
  # dialog opens this file when it is next to the binary.
  install -m 644 "$PROJDIR/THIRDPARTY.md" "$1/THIRDPARTY.md"
  install -m 644 "$METAOUT" "$1/$META"
  install -m 644 "$PROJDIR/packaging/$DESKTOP" "$1/$DESKTOP"
  cp -a "$PROJDIR/packaging/icons" "$1/icons"
  # A qt6 build needs libQt6Pas, which no distribution packages as a dependency
  # of an ordinary app: keep it beside the binary and let the wrappers put the
  # directory first in LD_LIBRARY_PATH.
  if [ "$WS" = qt6 ]; then
    local pas
    pas=$(ldd "$BIN" | awk '/libQt6Pas/ {print $3; exit}')
    if [ -n "$pas" ] && [ -f "$pas" ]; then
      install -m 644 "$(readlink -f "$pas")" "$1/libQt6Pas.so.6"
    else
      warn "qt6 build but libQt6Pas.so.6 was not found; the package will need it from the system"
    fi
  fi
}
stage_payload "$PAYLOAD"

APPNAME=mdpad   # the installed command; the payload binary is renamed to it
TARNAME=mdpad-$VERSION
TARBALL=$DIST/mdpad-$VERSION-linux-x86_64.tar.gz

# ---------------------------------------------------------------------------
# 3. Portable tarball (also the payload of the Arch and Flatpak packages)
# ---------------------------------------------------------------------------
say "Tarball"
rm -rf "$WORK/$TARNAME"
mkdir -p "$WORK/$TARNAME"
cp -a "$PAYLOAD/." "$WORK/$TARNAME/"
# Portable copy: run ./mdpad from the folder; settings.ini is created next to
# it because the folder is writable (see SettingsFileName in the sources).
tar -C "$WORK" --sort=name --mtime="@$EPOCH" --owner=0 --group=0 \
    --numeric-owner -cf - "$TARNAME" | gzip -9 -n > "$TARBALL"
TARSUM=$(sha256sum "$TARBALL" | awk '{print $1}')
note "$(basename "$TARBALL")  $(du -h "$TARBALL" | cut -f1)"
ARTIFACTS+=("$TARBALL")

# ---------------------------------------------------------------------------
# 4. Debian/Ubuntu .deb
# ---------------------------------------------------------------------------
build_deb() {
  say "Debian package"
  local root=$WORK/deb
  local doc=$root/usr/share/doc/$APPNAME
  rm -rf "$root"
  install -d "$root/DEBIAN" "$root/usr/lib/mdpad" "$root/usr/bin" \
    "$root/usr/share/applications" "$root/usr/share/metainfo" \
    "$root/usr/share/icons/hicolor" "$doc"

  # The app finds lib.lxl, Theme.json, style.css and Readme.md next to the
  # binary, which is why it does not live in /usr/bin. /usr/bin/mdpad is a
  # one-line wrapper: argv[0] is then the real binary's path.
  cp -a "$PAYLOAD/." "$root/usr/lib/mdpad/"
  rm -rf "$root/usr/lib/mdpad/icons" \
         "$root/usr/lib/mdpad/$DESKTOP" \
         "$root/usr/lib/mdpad/$META"
  cat > "$root/usr/bin/mdpad" <<'EOF'
#!/bin/sh
# MDPad keeps its data files next to the binary, so the real program lives in
# /usr/lib/mdpad and this wrapper starts it from there.
LD_LIBRARY_PATH=/usr/lib/mdpad${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}
export LD_LIBRARY_PATH
exec /usr/lib/mdpad/mdpad "$@"
EOF
  chmod 755 "$root/usr/bin/mdpad"

  install -m 644 "$PROJDIR/packaging/$DESKTOP" "$root/usr/share/applications/$DESKTOP"
  install -m 644 "$METAOUT" "$root/usr/share/metainfo/$META"
  cp -a "$PROJDIR/packaging/icons/hicolor/." "$root/usr/share/icons/hicolor/"

  install -m 644 "$PROJDIR/LICENSE" "$doc/copyright"
  install -m 644 "$PROJDIR/THIRDPARTY.md" "$doc/THIRDPARTY.md"
  install -m 644 "$PROJDIR/README.md" "$doc/README.md"

  local size
  size=$(du -sk "$root/usr" | cut -f1)
  local deps="libc6, libgtk-3-0 | libgtk-3-0t64"
  if [ "$WS" = qt6 ]; then
    deps="libc6, libqt6core6 | libqt6core6t64, libqt6gui6 | libqt6gui6t64, libqt6widgets6 | libqt6widgets6t64"
  fi
  cat > "$root/DEBIAN/control" <<EOF
Package: $APPNAME
Version: $VERSION
Section: editors
Priority: optional
Architecture: amd64
Maintainer: ${MAINTAINER:-vhanla <vhanla@users.noreply.github.com>}
Installed-Size: $size
Depends: $deps
Recommends: libssl3 | libssl1.1, ca-certificates
Homepage: https://github.com/vhanla/MDPad
Description: simple, fast Markdown editor and viewer
 MDPad is a native Markdown editor and viewer. It opens files instantly,
 edits with syntax highlighting and inline formatting commands, and renders
 the document next to the text as you type.
 .
 The preview can be the cross-platform HTML viewer or Markdown4D's canvas
 renderer, which needs no browser at all; documents are converted by a native
 CommonMark/GFM engine. Features include a table of contents, two-way scroll
 sync, light and dark themes, a formatting bar, link/image/table dialogs,
 Smart Enter for lists, word completion, recent files and HTML export.
EOF
  cat > "$root/DEBIAN/postinst" <<'EOF'
#!/bin/sh
set -e
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database -q /usr/share/applications || true
fi
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor || true
fi
exit 0
EOF
  cat > "$root/DEBIAN/postrm" <<'EOF'
#!/bin/sh
set -e
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database -q /usr/share/applications || true
fi
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor || true
fi
exit 0
EOF
  chmod 755 "$root/DEBIAN/postinst" "$root/DEBIAN/postrm"
  # Debian lists the paths relative to the package root, without "./".
  ( cd "$root" && find . -type f ! -path './DEBIAN/*' -print0 \
      | sort -z | xargs -0 md5sum | sed 's|  \./|  |' ) > "$root/DEBIAN/md5sums"

  local out=$DIST/mdpad_${VERSION}_amd64.deb
  rm -f "$out"
  if have dpkg-deb; then
    dpkg-deb --root-owner-group -Zxz --build "$root" "$out" >/dev/null
  else
    # A .deb is an ar archive of three members, in this order. Build them
    # outside the payload tree: a tarball written inside it would be archived
    # into itself ("file changed as we read it").
    local meta=$WORK/debmeta
    rm -rf "$meta"; mkdir -p "$meta"
    tar -C "$root/DEBIAN" --sort=name --mtime="@$EPOCH" --owner=0 --group=0 \
      --numeric-owner -cJf "$meta/control.tar.xz" .
    tar -C "$root" --sort=name --mtime="@$EPOCH" --owner=0 --group=0 \
      --numeric-owner --exclude=./DEBIAN -cJf "$meta/data.tar.xz" .
    printf '2.0\n' > "$meta/debian-binary"
    ( cd "$meta" && ar rcsD "$out" debian-binary control.tar.xz data.tar.xz )
    rm -rf "$meta"
  fi
  note "$(basename "$out")  $(du -h "$out" | cut -f1)"
  ARTIFACTS+=("$out")
}

# ---------------------------------------------------------------------------
# 5. Arch / AUR (binary package: the release tarball, unpacked)
# ---------------------------------------------------------------------------
write_pkgbuild() { # $1 = destination, $2 = source line (URL or bare file name)
  cat > "$1" <<EOF
# Maintainer: ${MAINTAINER:-vhanla <vhanla@users.noreply.github.com>}
pkgname=mdpad-bin
pkgver=$VERSION
pkgrel=1
pkgdesc="Simple, fast Markdown editor and viewer (native GTK3 build)"
arch=('x86_64')
url="https://github.com/vhanla/MDPad"
license=('MIT')
depends=('gtk3')
optdepends=('openssl: HTTPS update check' 'ca-certificates: HTTPS update check')
provides=('mdpad')
conflicts=('mdpad')
options=('!strip' '!debug')
source=('$2')
sha256sums=('$TARSUM')

package() {
  install -d "\$pkgdir/usr/lib/mdpad" "\$pkgdir/usr/bin" \\
    "\$pkgdir/usr/share/applications" "\$pkgdir/usr/share/metainfo" \\
    "\$pkgdir/usr/share/icons" "\$pkgdir/usr/share/licenses/\$pkgname"

  cp -a "\$srcdir/$TARNAME/." "\$pkgdir/usr/lib/mdpad/"
  rm -rf "\$pkgdir/usr/lib/mdpad/icons" \\
         "\$pkgdir/usr/lib/mdpad/$DESKTOP" \\
         "\$pkgdir/usr/lib/mdpad/$META"

  printf '#!/bin/sh\\nexec /usr/lib/mdpad/mdpad "\$@"\\n' > "\$pkgdir/usr/bin/mdpad"
  chmod 755 "\$pkgdir/usr/bin/mdpad"

  install -m644 "\$srcdir/$TARNAME/$DESKTOP" \\
    "\$pkgdir/usr/share/applications/$DESKTOP"
  install -m644 "\$srcdir/$TARNAME/$META" \\
    "\$pkgdir/usr/share/metainfo/$META"
  cp -a "\$srcdir/$TARNAME/icons/hicolor" "\$pkgdir/usr/share/icons/"
  install -m644 "\$srcdir/$TARNAME/LICENSE" \\
    "\$pkgdir/usr/share/licenses/\$pkgname/LICENSE"
  install -m644 "\$srcdir/$TARNAME/THIRDPARTY.md" \\
    "\$pkgdir/usr/share/licenses/\$pkgname/THIRDPARTY.md"
}
EOF
}

build_arch() {
  say "Arch package / AUR files"
  if [ "$WS" = qt6 ]; then note "the AUR package declares gtk3; a qt6 build is not what it expects"; fi
  local aur=$DIST/arch
  local url="https://github.com/vhanla/MDPad/releases/download/v$VERSION/$(basename "$TARBALL")"
  rm -rf "$aur"
  mkdir -p "$aur"
  write_pkgbuild "$aur/PKGBUILD" "$url"
  if have makepkg; then
    ( cd "$aur" && makepkg --printsrcinfo > .SRCINFO )
  else
    note "makepkg not found: PKGBUILD written, .SRCINFO not generated"
  fi

  if have makepkg; then
    local b=$WORK/arch
    rm -rf "$b"; mkdir -p "$b"
    cp "$aur/PKGBUILD" "$b/"
    cp "$TARBALL" "$b/"
    if ( cd "$b" && PKGDEST=$DIST makepkg -f --nodeps --nocheck --noprogressbar >"$WORK/makepkg.log" 2>&1 ); then
      local pkg
      pkg=$(ls -1 "$DIST"/mdpad-bin-"$VERSION"-1-x86_64.pkg.tar.* 2>/dev/null | head -1 || true)
      if [ -n "$pkg" ]; then
        note "$(basename "$pkg")  $(du -h "$pkg" | cut -f1)"
        ARTIFACTS+=("$pkg")
      fi
    else
      warn "makepkg failed; see $WORK/makepkg.log"
    fi
  else
    note "makepkg not found: skipping the .pkg.tar.zst (the PKGBUILD above builds it on Arch)"
  fi
}

# ---------------------------------------------------------------------------
# 6. AppImage
# ---------------------------------------------------------------------------
build_appimage() {
  say "AppImage"
  local dir=$WORK/AppDir
  rm -rf "$dir"
  install -d "$dir/usr/lib/mdpad" "$dir/usr/share/applications" \
    "$dir/usr/share/metainfo" "$dir/usr/share/icons"

  cp -a "$PAYLOAD/." "$dir/usr/lib/mdpad/"
  rm -rf "$dir/usr/lib/mdpad/icons" \
         "$dir/usr/lib/mdpad/$DESKTOP" \
         "$dir/usr/lib/mdpad/$META"
  cp -a "$PROJDIR/packaging/icons/hicolor" "$dir/usr/share/icons/hicolor"
  install -m 644 "$PROJDIR/packaging/$DESKTOP" "$dir/$DESKTOP"
  install -m 644 "$PROJDIR/packaging/$DESKTOP" "$dir/usr/share/applications/$DESKTOP"
  install -m 644 "$METAOUT" "$dir/usr/share/metainfo/$META"
  install -m 644 "$PROJDIR/packaging/icons/hicolor/256x256/apps/mdpad.png" "$dir/mdpad.png"

  # AppRun runs the payload directly, so argv[0] names the directory that holds
  # lib.lxl and friends.
  cat > "$dir/AppRun" <<'EOF'
#!/bin/sh
HERE=$(dirname "$(readlink -f "$0")")
LD_LIBRARY_PATH="$HERE/usr/lib/mdpad${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
export LD_LIBRARY_PATH
exec "$HERE/usr/lib/mdpad/mdpad" "$@"
EOF
  chmod 755 "$dir/AppRun"

  if ! have mksquashfs; then
    note "mksquashfs not found (squashfs-tools): AppDir left at $dir"
    return 0
  fi

  local runtime=$CACHE/runtime-x86_64
  if [ ! -s "$runtime" ]; then
    local url=${APPIMAGE_RUNTIME:-https://github.com/AppImage/AppImageKit/releases/download/continuous/runtime-x86_64}
    note "downloading the AppImage runtime"
    if have curl; then
      curl -fL --retry 3 -o "$runtime" "$url" || { warn "could not download $url"; return 0; }
    elif have wget; then
      wget -q -O "$runtime" "$url" || { warn "could not download $url"; return 0; }
    else
      note "curl/wget not found: cannot fetch the AppImage runtime"
      return 0
    fi
    chmod 755 "$runtime"
  fi
  if have file && ! file "$runtime" | grep -q 'ELF'; then
    warn "the AppImage runtime in $runtime is not an ELF binary; removing it"
    rm -f "$runtime"
    return 0
  fi

  local squash=$WORK/appimage.squashfs
  rm -f "$squash"
  # The AppImage type-2 runtime supports xz and zlib only (not zstd).
  mksquashfs "$dir" "$squash" -root-owned -noappend -comp xz -no-progress >/dev/null
  local out=$DIST/mdpad-$VERSION-x86_64.AppImage
  cat "$runtime" "$squash" > "$out"
  chmod 755 "$out"
  note "$(basename "$out")  $(du -h "$out" | cut -f1)"
  ARTIFACTS+=("$out")
}

# ---------------------------------------------------------------------------
# 7. Flatpak
# ---------------------------------------------------------------------------
flatpak_manifest() { # $1 = destination, $2 = source block (url+sha256 or path)
  local runtime=${FLATPAK_RUNTIME:-org.gnome.Platform}
  local rver=${FLATPAK_RUNTIME_VERSION:-48}
  cat > "$1" <<EOF
# MDPad as a Flatpak. Build and bundle with:
#   flatpak install flathub $runtime//$rver
#   flatpak-builder --force-clean --user --repo=repo --install-deps-from=flathub build $1
#   flatpak build-bundle repo mdpad-$VERSION.flatpak io.github.vhanla.MDPad
app-id: io.github.vhanla.MDPad
runtime: $runtime
runtime-version: '$rver'
sdk: ${runtime%.Platform}.Sdk
command: mdpad
finish-args:
  - --share=ipc
  - --socket=fallback-x11
  - --socket=wayland
  - --device=dri
  # The canvas preview may fetch remote images (View > Load remote images).
  - --share=network
  # Documents are opened through the file chooser, outside the sandbox too.
  - --filesystem=home
modules:
  - name: mdpad
    buildsystem: simple
    build-commands:
      - install -d /app/lib/mdpad /app/bin /app/share/applications /app/share/metainfo /app/share/icons
      - cp -a $TARNAME/. /app/lib/mdpad/
      - rm -rf /app/lib/mdpad/icons /app/lib/mdpad/$DESKTOP /app/lib/mdpad/$META
      - install -m755 mdpad-wrapper /app/bin/mdpad
      - install -m644 $TARNAME/$DESKTOP /app/share/applications/
      - install -m644 $TARNAME/$META /app/share/metainfo/
      - cp -a $TARNAME/icons/hicolor /app/share/icons/
    sources:
$2
      - type: script
        dest-filename: mdpad-wrapper
        commands:
          - 'exec /app/lib/mdpad/mdpad "\$@"'
EOF
}

build_flatpak() {
  say "Flatpak"
  if [ "$WS" = qt6 ]; then
    note "the GNOME runtime carries GTK3, not Qt6: skipping (build the release with --ws gtk3)"
    return 0
  fi
  local dir=$DIST/flatpak
  local url="https://github.com/vhanla/MDPad/releases/download/v$VERSION/$(basename "$TARBALL")"
  rm -rf "$dir"
  mkdir -p "$dir"
  flatpak_manifest "$dir/io.github.vhanla.MDPad.yml" \
"      - type: archive
        url: $url
        sha256: $TARSUM"
  cat > "$dir/README.md" <<EOF
# Flatpak

\`io.github.vhanla.MDPad.yml\` builds from the release tarball
(\`$(basename "$TARBALL")\`, sha256 \`$TARSUM\`), so it is ready to publish as
is (Flathub or any flatpak-builder setup).

Locally, once the release is published:

    flatpak install flathub org.gnome.Platform//${FLATPAK_RUNTIME_VERSION:-48} org.gnome.Sdk//${FLATPAK_RUNTIME_VERSION:-48}
    flatpak-builder --force-clean --user --repo=repo --install-deps-from=flathub build io.github.vhanla.MDPad.yml
    flatpak build-bundle repo mdpad-$VERSION.flatpak io.github.vhanla.MDPad
    flatpak install --user mdpad-$VERSION.flatpak
EOF

  if ! have flatpak-builder; then
    note "flatpak-builder not found: manifest written, no .flatpak bundle built"
    return 0
  fi

  # Local build of the same manifest, from the tarball we just made (the
  # release URL does not exist yet when this runs before publishing).
  local local_manifest=$WORK/flatpak-local.yml
  cp "$TARBALL" "$dir/"
  flatpak_manifest "$local_manifest" "
      - type: archive
        path: ../$(basename "$TARBALL")
        sha256: $TARSUM"
  local out=$DIST/mdpad-$VERSION.flatpak
  if ( cd "$WORK" && flatpak-builder --force-clean --user --repo="$WORK/flatpak-repo" \
        --install-deps-from=flathub "$WORK/flatpak-build" "$local_manifest" >"$WORK/flatpak.log" 2>&1 \
       && flatpak build-bundle "$WORK/flatpak-repo" "$out" io.github.vhanla.MDPad >>"$WORK/flatpak.log" 2>&1 ); then
    note "$(basename "$out")  $(du -h "$out" | cut -f1)"
    ARTIFACTS+=("$out")
  else
    warn "flatpak-builder failed; see $WORK/flatpak.log"
  fi
  rm -f "$dir/$(basename "$TARBALL")"
}

# ---------------------------------------------------------------------------
# 8. Dispatch, checksums, summary
# ---------------------------------------------------------------------------
want deb      && build_deb
want arch     && build_arch
want appimage && build_appimage
want flatpak  && build_flatpak

if [ ${#ARTIFACTS[@]} -gt 0 ]; then
  ( cd "$DIST" && sha256sum $(for a in "${ARTIFACTS[@]}"; do basename "$a"; done) > SHA256SUMS )
fi

say "Done"
for a in "${ARTIFACTS[@]}"; do
  printf '   %-42s %s\n' "$(basename "$a")" "$(du -h "$a" | cut -f1)"
done
if want arch && [ -d "$DIST/arch" ]; then
  note "AUR files:     dist/arch/PKGBUILD, dist/arch/.SRCINFO"
fi
if want flatpak && [ -d "$DIST/flatpak" ]; then
  note "Flatpak files: dist/flatpak/io.github.vhanla.MDPad.yml"
fi
[ -f "$DIST/SHA256SUMS" ] && note "Checksums:     dist/SHA256SUMS"

if [ "$KEEP" = 1 ]; then
  note "work dir kept: $WORK"
else
  rm -rf "$WORK"
fi
