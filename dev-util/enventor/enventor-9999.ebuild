# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

[ "${PV}" = 9999 ] && inherit git-r3 autotools

DESCRIPTION="EFL Dynamic EDC edtiro"
HOMEPAGE="https://git.enlightenment.org/tools/enventor.git/about/"
EGIT_REPO_URI="https://github.com/hermet/enventor"
#EGIT_REPO_URI="https://git.enlightenment.org/tools/${PN}.git"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="doc nls static-libs"

RDEPEND=">=dev-libs/efl-1.18.0"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_/-}"
DOCS=( AUTHORS NEWS README.md )

src_prepare() {
	einfo "Applying patch for README file"
	eapply -p1 "${FILESDIR}/installation.patch"
	eapply_user
	eautoreconf
}

src_configure() {
	eautoreconf
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
