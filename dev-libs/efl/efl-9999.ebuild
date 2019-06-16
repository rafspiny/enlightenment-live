# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils pax-utils xdg-utils
[ "${PV}" = 9999 ] && inherit git-r3 autotools

DESCRIPTION="Enlightenment Foundation Core Libraries"
HOMEPAGE="https://www.enlightenment.org/"
EGIT_REPO_URI="https://git.enlightenment.org/core/${PN}.git"
#EGIT_REPO_URI="https://github.com/Enlightenment/efl.git"
[ "${PV}" = 9999 ] || SRC_URI="http://download.enlightenment.org/rel/libs/${PN}/${P/_/-}.tar.bz2"

LICENSE="BSD-2 GPL-2 LGPL-2.1 ZLIB"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

# cxx-bindings
# static-libs
IUSE="avahi +bmp connman dds debug doc drm +eet egl eo fbcon +fontconfig fribidi gif gles glib gnutls gstreamer +harfbuzz hyphen +ico ibus jpeg2k libressl libuv luajit neon nls opengl ssl pdf pixman physics +ppm postscript +psd pulseaudio raw scim sdl sound +svg systemd tga tiff tslib unwind v4l valgrind vlc vnc wayland +webp +X xcf xim xine xpresent xpm"

REQUIRED_USE="
	fbcon? ( !tslib )
	gles? (
		|| ( X wayland )
		!sdl
		egl
	)
	ibus? ( glib )
	opengl?		( || ( X sdl wayland ) )
	pulseaudio?	( sound )
	sdl?		( opengl )
	vnc?        ( X fbcon )
	wayland?	( egl !opengl gles )
	xim?		( X )
"

RDEPEND="
	app-arch/lz4:0=
	net-misc/curl
	media-libs/libpng:0=
	sys-apps/dbus
	>=sys-apps/util-linux-2.20.0
	sys-libs/zlib:=
	virtual/jpeg:0=
	virtual/udev
	avahi? ( net-dns/avahi )
	connman? ( net-misc/connman )
	drm? (
		>=dev-libs/libinput-0.8
		media-libs/mesa[gbm]
		>=x11-libs/libdrm-2.4
		>=x11-libs/libxkbcommon-0.3.0
	)
	egl? ( media-libs/mesa[egl] )
	fontconfig? ( media-libs/fontconfig )
	fribidi? ( dev-libs/fribidi )
	gif? ( media-libs/giflib:= )
	glib? ( dev-libs/glib:2 )
	gles? ( media-libs/mesa[gles2] )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	gnutls? ( net-libs/gnutls )
	!gnutls? (
		ssl? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl )
		)
	)
	harfbuzz? ( media-libs/harfbuzz )
	hyphen? ( dev-libs/hyphen )
	ibus? ( app-i18n/ibus )
	jpeg2k? ( media-libs/openjpeg:0= )
	libuv? ( dev-libs/libuv )
	luajit? ( dev-lang/luajit:= )
	!luajit? ( dev-lang/lua:* )
	nls? ( sys-devel/gettext )
	pdf? ( app-text/poppler:=[cxx] )
	physics? ( sci-physics/bullet:= )
	pixman? ( x11-libs/pixman )
	postscript? ( app-text/libspectre:* )
	pulseaudio? ( media-sound/pulseaudio )
	raw? ( media-libs/libraw:* )
	scim? ( app-i18n/scim )
	sdl? (
		media-libs/libsdl2
		virtual/opengl
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
	valgrind? ( dev-util/valgrind )
	vlc? ( media-video/vlc )
	vnc? ( net-libs/libvncserver )
	wayland? (
		>=dev-libs/wayland-1.8.0
		>=x11-libs/libxkbcommon-0.3.1
		media-libs/mesa[gles2,wayland]
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
		opengl? (
			x11-libs/libX11
			x11-libs/libXrender
			virtual/opengl
		)
		gles? (
			x11-libs/libX11
			x11-libs/libXrender
			virtual/opengl
			xpresent? ( x11-libs/libXpresent )
		)
	)
	xine? ( media-libs/xine-lib )
	xpm? ( x11-libs/libXpm )

	!dev-libs/ecore
	!dev-libs/edbus
	!dev-libs/eet
	!dev-libs/eeze
	!dev-libs/efreet
	!dev-libs/eina
	!dev-libs/eio
	!dev-libs/embryo
	!dev-libs/eobj
	!dev-libs/ephysics
	!media-libs/edje
	!media-libs/emotion
	!media-libs/ethumb
	!media-libs/evas
	!media-libs/elementary
	!media-plugins/emotion_generic_players
	!media-plugins/evas_generic_loaders
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

S="${WORKDIR}/${P/_/-}"

src_prepare() {
	[ ${PV} = 9999 ] && eautoreconf

	# Upstream still doesnt offer a configure flag. #611108
	if ! use unwind ; then
	        sed -i -e 's:libunwind libunwind-generic:xxxxxxxxxxxxxxxx:' \
	        configure || die "Sedding configure file with unwind fix failed."
	fi
	eapply_user
	xdg_environment_reset
}

src_configure() {
	if use ssl && use gnutls ; then
		einfo "You enabled both USE=ssl and USE=gnutls, but only one can be used;"
		einfo "gnutls has been selected for you."
	fi
	if use opengl && use gles ; then
		einfo "You enabled both USE=opengl and USE=gles, but only one can be used;"
		einfo "opengl has been selected for you."
	fi

	local config=(
		# image loaders
		--enable-image-loader-generic
		--enable-image-loader-jpeg # required by ethumb
		--enable-image-loader-png
		$(use_enable bmp image-loader-bmp)
		$(use_enable bmp image-loader-wbmp)
		$(use_enable eet image-loader-eet)
		$(use_enable gif image-loader-gif)
		$(use_enable ico image-loader-ico)
		$(use_enable jpeg2k image-loader-jp2k)
		$(use_enable svg librsvg)
		$(use_enable tga image-loader-tga)

		--enable-cserve
		--enable-elput
		--enable-multisense
		--enable-libmount
		--enable-libeeze
		--enable-threads
		--enable-xinput22
		--enable-liblz4

		--disable-doc
		--disable-gesture
		--disable-gstreamer
		#--disable-image-loader-tgv
		--disable-tizen
		--disable-wayland-ivi-shell

		#--disable-multisense
		#--disable-xinput2
		#--enable-xinput2 # enable it

		$(use_enable eo install-eo-files)
		$(use_enable doc)
		$(use_enable luajit lua-old)
		$(use_enable pixman)
		$(use_enable pixman pixman-font)
		$(use_enable pixman pixman-rect)
		$(use_enable pixman pixman-line)
		$(use_enable pixman pixman-poly)
		$(use_enable pixman pixman-image)
		$(use_enable pixman pixman-image-scale-sample)
		$(use_enable ppm image-loader-pmaps)
		$(use_enable postscript spectre)
		$(use_enable psd image-loader-psd)
		$(use_enable pulseaudio)
		$(use_enable raw libraw)
		$(use_enable scim)
		$(use_enable sdl)
		$(use_enable sound audio)
		$(use_enable systemd)
		$(use_enable tiff image-loader-tiff)
		$(use_enable !fbcon tslib)

		$(use_enable avahi)
		$(use_enable dds image-loader-dds)
		$(use_enable drm)
		$(use_enable drm elput)
		$(use_enable egl)
		$(use_enable fbcon fb)
		$(use_enable fontconfig)
		$(use_enable fribidi)
		$(use_enable gstreamer gstreamer1)
		$(use_enable harfbuzz)
		$(use_enable hyphen)
		$(use_enable ibus)
		$(use_enable libuv)
		$(use_enable !luajit lua-old)
		$(use_enable neon)
		$(use_enable nls)
		$(use_enable pdf poppler)
		$(use_enable physics)
		$(use_enable postscript spectre)
		$(use_enable ppm image-loader-pmaps)
		$(use_enable psd image-loader-psd)
		$(use_enable pulseaudio)
		$(use_enable scim)
		$(use_enable sdl)
		$(use_enable svg librsvg)
		$(use_enable systemd)
		$(use_enable tga image-loader-tga)
		$(use_enable tiff image-loader-tiff)
		$(use_enable tslib)
		$(use_enable v4l v4l2)
		$(use_enable valgrind)
		# $(use_enable vlc libvlc)
		$(use_enable vnc vnc-server)
		$(use_enable wayland)
		$(use_enable webp image-loader-webp)
		$(use_enable xcf)
		$(use_enable xim)
		$(use_enable xine)
		$(use_enable xpm image-loader-xpm)

		--with-crypto=$(usex gnutls gnutls $(usex ssl openssl none))
		--with-glib=$(usex glib)
		--with-js=none
		--with-net-control=$(usex connman connman none)
		--with-opengl=$(usex opengl full $(usex gles es none))
		--with-profile=$(usex debug debug release)
		#--with-tests=$(usex test regular none)
		--with-x11=$(usex X xlib none)

		$(use_with X x)

		--enable-i-really-know-what-i-am-doing-and-that-this-will-probably-break-things-and-i-will-fix-them-myself-and-send-patches-abb
	)

	use fbcon && use egl && config+=( --enable-eglfs )
	use drm && use wayland && config+=( --enable-gl-drm )
	use X && use xpresent && config+=( --enable-xpresent )

	if use opengl ; then
	        config+=( --with-opengl=full )
	        use gles &&  \
			    einfo "You enabled both USE=opengl and USE=gles, using opengl"
	elif use egl ; then
	        config+=( --with-opengl=es )
	elif use drm && use wayland ; then
	        config+=( --with-opengl=es )
	else
	        config+=( --with-opengl=none )
	        use $sdl && \
	            ewarn "You enabled both USE=sdl and USE=gles which isn't currently supported."
			ewarn "Disabling gl for all backends."
	fi

	# Checking for with version of vlc is enabled and therefore use the right configure option
	if use vlc ; then
		einfo "You enabled USE=vlc. Checking vlc version..."
		if has_version ">media-video/vlc-3.0" ; then
			einfo "> 3.0 found. Enabling libvlc."
			config+=($(use_enable vlc libvlc))
		else
			einfo "< 3.0 found. Enabling generic-vlc."
			config+=($(use_with vlc generic-vlc))
		fi
	fi

	econf "${config[@]}"
}

src_compile() {
	if host-is-pax && use luajit ; then
	            # We need to build the lua code first so we can pax-mark it. #547076
	            local target='_e_built_sources_target_gogogo_'
	            printf '%s: $(BUILT_SOURCES)\n' "${target}" >> src/Makefile || die
	            emake -C src "${target}"
	            emake -C src bin/elua/elua
	            pax-mark m src/bin/elua/.libs/elua
	    fi

	V=1 emake || die "Compiling EFL failed."
}

src_test() {
	MAKEOPTS+=" -j1"
	default
}

src_install() {
	MAKEOPTS+=" -j1"
	einstalldocs
	V=1 emake install DESTDIR="${D}" || die "Installing EFL files failed."
	prune_libtool_files
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
}
