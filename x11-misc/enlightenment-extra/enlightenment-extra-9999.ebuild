# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson git-r3
MY_PN="${PN/enlightenment-/}"

DESCRIPTION="An app for downloading themes and add-ons to Enlightenment WM"
HOMEPAGE="https://extra.enlightenment.org"
EGIT_REPO_URI="https://git.enlightenment.org/enlightenment/extra.git"

S="${WORKDIR}/${P/_/-}"
LICENSE="WTFPL-2"

SLOT="0"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-libs/efl-1.18[X]"
DEPEND="
	${RDEPEND}
	sys-devel/gettext
"

src_prepare() {
	default
	cd enlightenment-extra-9999
	# Fix a QA issue, https://phab.enlightenment.org/T7167
	sed -i '/Version=/d' data/desktop/extra.desktop* || die
}
