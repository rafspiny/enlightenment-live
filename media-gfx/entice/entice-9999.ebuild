# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 meson xdg

DESCRIPTION="Entice photo browser"
HOMEPAGE="https://git.enlightenment.org/vtorri/entice"
EGIT_REPO_URI="https://github.com/vtorri/${PN}.git"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="nls"
RDEPEND=">=dev-libs/efl-1.18.0"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/_/-}"
