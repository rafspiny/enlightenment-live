# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg git-r3

DESCRIPTION="Sticky notes based on EFL"
HOMEPAGE="https://github.com/jf-simon/enotes"
EGIT_REPO_URI="https://github.com/jf-simon/${PN}.git"

LICENSE="GPL-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="X"

RDEPEND="
	dev-libs/efl"
DEPEND="${RDEPEND}
	dev-util/meson"

S="${WORKDIR}/${P/_/-}"
