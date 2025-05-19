# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="EFL GUI for Neovim"
HOMEPAGE="https://github.com/jeanguyomarch/eovim"
EGIT_REPO_URI="https://github.com/jeanguyomarch/${PN}.git"

S="${WORKDIR}/${P/_/-}"
LICENSE="MIT"
SLOT="0"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-libs/efl-1.18.0
	dev-libs/msgpack
	>=app-editors/neovim-0.2.0
	"
DEPEND="
	${RDEPEND}
"
