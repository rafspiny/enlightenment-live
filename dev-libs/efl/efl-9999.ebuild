# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_REQ_USE="deprecated(+)"
LUA_COMPAT=( lua5-{1,2} luajit )

inherit git-r3 lua-single meson xdg

DESCRIPTION="Enlightenment Foundation Core Libraries"
HOMEPAGE="https://www.enlightenment.org/"
EGIT_REPO_URI="https://git.enlightenment.org/enlightenment/${PN}.git"
#EGIT_REPO_URI="file:///data/projects/efl"

S="${WORKDIR}/${P/_/-}"
LICENSE="BSD-2 GPL-2 LGPL-2.1 ZLIB"

SLOT="0"
[ "${PV}" = 9999 ] || KEYWORDS="amd64 x86"

IUSE="avahi +bmp connman example dds debug doc drm +eet egl eo fbcon +fontconfig fribidi gif +glib gnutls gstreamer +harfbuzz +heif hyphen +ibus +ico jpeg2k json libuv lua luajit nls opengl pdf pixman physics +ppm postscript +psd pulseaudio raw scim sdl sound ssl +svg systemd tga tiff tslib unwind v4l vlc vnc test wayland +webp +X xcf +xim xine xpresent xpm"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	${LUA_REQUIRED_USE}
	fbcon? ( !tslib )
	ibus? ( glib )
	opengl?		( X )
	pulseaudio?	( sound )
	vnc?        ( X fbcon )
	xim?		( X )
"

# Possibly, the media-libs/libjpeg-turbo dependency can be removed
RDEPEND="${LUA_DEPS}
	app-arch/lz4:0=
	net-misc/curl
	media-libs/libpng:0=
	sys-apps/dbus
	>=sys-apps/util-linux-2.20.0
	sys-libs/zlib:=
	media-libs/libjpeg-turbo
	media-libs/libjxl
	virtual/udev
	avahi? ( net-dns/avahi )
	connman? ( net-misc/connman )
	drm? (
		>=dev-libs/libinput-0.8
		media-libs/mesa
		>=x11-libs/libdrm-2.4
		>=x11-libs/libxkbcommon-0.3.0
	)
	egl? ( media-libs/mesa )
	fontconfig? ( media-libs/fontconfig )
	fribidi? ( dev-libs/fribidi )
	gif? ( media-libs/giflib:= )
	glib? ( dev-libs/glib:2 )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-plugins/gst-plugins-meta:1.0
	)
	gnutls? ( net-libs/gnutls )
	!gnutls? (
		ssl? ( dev-libs/openssl:0= )
	)
	harfbuzz? ( media-libs/harfbuzz )
	heif? ( media-libs/libheif )
	hyphen? ( dev-libs/hyphen )
	ibus? ( app-i18n/ibus )
	jpeg2k? ( media-libs/openjpeg )
	libuv? ( dev-libs/libuv )
	luajit? ( dev-lang/luajit:= )
	!luajit? ( dev-lang/lua:* )
	nls? ( sys-devel/gettext )
	opengl? (
		virtual/opengl
	)
	pdf? ( app-text/poppler:=[cxx] )
	physics? ( sci-physics/bullet:= )
	pixman? ( x11-libs/pixman )
	postscript? ( app-text/libspectre:* )
	pulseaudio? ( media-libs/libpulse )
	raw? ( media-libs/libraw:* )
	scim? ( app-i18n/scim )
	sdl? (
		media-libs/libsdl2
	)
	sound? ( media-libs/libsndfile )
	svg? (
		gnome-base/librsvg
		x11-libs/cairo
	)
	systemd? ( sys-apps/systemd )
	tiff? ( media-libs/tiff:0= )
	tslib? ( x11-libs/tslib:= )
	unwind? ( sys-libs/libunwind )
	vlc? ( media-video/vlc )
	vnc? ( net-libs/libvncserver )
	wayland? (
		>=dev-libs/wayland-1.8.0
		>=x11-libs/libxkbcommon-0.3.1
		media-libs/mesa[wayland]
	)
	webp? ( media-libs/libwebp:= )
	X? (
		media-libs/freetype
		x11-libs/libXcursor
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libXtst
		x11-libs/libXScrnSaver
		!opengl? ( media-libs/mesa[opengl(+)] )
	)
	xine? ( media-libs/xine-lib )
	xpm? ( x11-libs/libXpm )
	xpresent? ( x11-libs/libXpresent )
"

DEPEND="${RDEPEND}"

#BDEPEND="
#	virtual/p/followed-cams/kgconfig
#	doc? ( app-doc/doxygen )
#"

src_prepare() {
	eapply_user
	xdg_environment_reset
}

src_configure() {
	if use ssl && use gnutls ; then
		einfo "You enabled both USE=ssl and USE=gnutls, but only one can be used;"
		einfo "ssl has been selected for you."
	fi

	local emesonargs=(
		$(meson_use lua_single_target_luajit elua)

		$(meson_use lua elua)
		$(meson_use sound audio)
		$(meson_use pulseaudio pulseaudio)
		$(meson_use systemd systemd)
		$(meson_use glib glib)
		$(meson_use nls nls)

		$(meson_use avahi avahi)
		$(meson_use fbcon fb)
		$(meson_use sdl sdl)
		$(meson_use gstreamer gstreamer)
		$(meson_use v4l v4l2)
		$(meson_use vnc vnc-server)

		$(meson_use physics physics)
		-Dnetwork-backend=$(usex connman connman none)
		-Dcrypto=$(usex ssl openssl $(usex gnutls gnutls none))

		$(meson_use test build-tests)
		$(meson_use example build-examples)
		$(meson_use debug debug-threads)
		$(meson_use debug eina-magic-debug)

		$(meson_use X x11)
		$(meson_use pixman pixman)
		$(meson_use wayland wl)
		$(meson_use drm drm)
		#$(use_enable drm elput)
		#use drm && use wayland && emesonargs+=( --enable-gl-drm )

		$(meson_use tslib tslib)
		# $(use_enable !fbcon tslib)
		#$(meson_use buffer buffer)

		$(meson_use eo install-eo-files)
		$(meson_use harfbuzz harfbuzz)
		$(meson_use hyphen hyphen)
		$(meson_use fontconfig fontconfig)
		$(meson_use fribidi fribidi)

		-Deeze=true
		-Dlibmount=true
	)
	local bindingsList="cxx,"
	use lua_single_target_luajit && bindingsList+="lua,"
	[[ ! -z "$bindingsList" ]] && bindingsList=${bindingsList::-1}
	emesonargs+=( -D bindings="${bindingsList}" )

	local luaChoice="lua"
	if use lua_single_target_luajit; then
		luaChoice="luajit"
	fi
	emesonargs+=( -D lua-interpreter="${luaChoice}")

	# Options dependant on others
	if use X; then
		emesonargs+=(
			-Dxinput2=true
			-Dxinput22=true
			$(meson_use xpresent xpresent)
			#$(meson_use xgesture xgesture)
		)
	fi

	# Options with a choice

	# Checking imf
	combind_imf=""
	for token in xim ibus scim ; do
		if use !$token ; then
			combined_imf="${combined_imf}${combined_imf:+,}$token"
		fi
	done
	# Checking evas loaders
	combined_evas_loaders="avif"
	for token in bmp dds eet gif heif ico json pdf psd raw svg tga tiff xcf xpm webp; do
		if use !$token ; then
			combined_evas_loaders="${combined_evas_loaders}${combined_evas_loaders:+,}$token"
		fi
	done

	# Checking for other evas loaders
	if use !jpeg2k ; then
		combined_evas_loaders="${combined_evas_loaders}${combined_evas_loaders:+,}jp2k"
	fi
	if use !gstreamer ; then
		combined_evas_loaders="${combined_evas_loaders}${combined_evas_loaders:+,}gst"
	fi
	if use !ppm ; then
		combined_evas_loaders="${combined_evas_loaders}${combined_evas_loaders:+,}pmaps"
	fi
	if use !postscript; then
		combined_evas_loaders="${combined_evas_loaders}${combined_evas_loaders:+,}ps"
	fi

	emesonargs+=(
		-Decore-imf-loaders-disabler="$combined_imf"
		-Devas-loaders-disabler="$combined_evas_loaders"
	)

	if use wayland; then
		einfo "Using es-egl as a backendi because you selected wayland."
		emesonargs+=( -D opengl=es-egl )
	elif ! use wayland && use opengl; then
		einfo "Using full as a backend."
		emesonargs+=( -D opengl=full )
	elif ! use wayland && use X && ! use opengl; then
		einfo "Using es-egl as a backend."
		emesonargs+=( -D opengl=es-egl )
	else
		ewarn "Disabling gl for all backends."
		emesonargs+=( -D opengl=none )
	fi

	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_test() {
	MAKEOPTS+=" -j1"
	meson_src_test
}

src_install() {
	MAKEOPTS+=" -j1"

	meson_src_install
	find "${ED}" -name '*.la' -delete || die
}
