# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="System and process monitor written with EFL"
HOMEPAGE="https://www.enlightenment.org/"
EGIT_REPO_URI="https://git.enlightenment.org/apps/${PN}.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/efl"
RDEPEND="|| ( dev-libs/efl[X] dev-libs/efl[wayland] )"
BDEPEND=""

src_install() {
	emake PREFIX="${D}"/usr install
	einstalldocs
}
