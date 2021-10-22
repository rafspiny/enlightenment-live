# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

[ "${PV}" = 9999 ] && inherit git-r3 autotools

DESCRIPTION="Edje Theme Editor - a theme graphical editor"
#HOMEPAGE="https://www.enlightenment.org/"
HOMEPAGE="https://git.enlightenment.org/tools/eflete.git/about/"
EGIT_REPO_URI="https://git.enlightenment.org/tools/${PN}.git"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="doc nls static-libs"

RDEPEND=">=dev-libs/efl-1.18.0"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_/-}"
DOCS=( AUTHORS NEWS README )

src_prepare() {
	#eapply -p0 "${FILESDIR}/enventor_eo_prefix_fix.patch"
	eapply_user
	[ ${PV} = 9999 ] && eautoreconf
}

src_configure() {
	local config=(
		$(use_enable nls)
		$(use_enable static-libs static)
	)

	econf "${config[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
