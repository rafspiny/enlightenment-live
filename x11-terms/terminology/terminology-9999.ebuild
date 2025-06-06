# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..14} )

inherit meson python-any-r1 git-r3 xdg

DESCRIPTION="Feature rich terminal emulator using the Enlightenment Foundation Libraries"
HOMEPAGE="https://www.enlightenment.org?p=about/terminology"
EGIT_REPO_URI="https://git.enlightenment.org/enlightenment/${PN}.git"
[ "${PV}" = 9999 ] || SRC_URI="http://download.enlightenment.org/rel/apps/${PN}/${P/_/-}.tar.xz"

S="${WORKDIR}/${P/_/-}"
LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="extras nls"

RDEPEND="|| ( dev-libs/efl[X] dev-libs/efl[wayland] )
	app-arch/lz4
	>=dev-libs/efl-1.26.1[eet,fontconfig]"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	virtual/libintl
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	default

	# Fix python shebangs for python-exec[-native-symlinks], #766081
	local shebangs=($(grep -rl "#!/usr/bin/env python3" || die))
	python_fix_shebang -q ${shebangs[*]}
}

src_configure() {
	local emesonargs=(
		$(meson_use nls)
		$(meson_use extras tests)
	)

	meson_src_configure
}

src_install() {
	meson_src_install
}
