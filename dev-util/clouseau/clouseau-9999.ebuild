# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="Clouseau. EFL Profiler Viewer"
HOMEPAGE="hhttps://github.com/dimmus/clousea"
EGIT_REPO_URI="https://github.com/dimmus/${PN}.git"

LICENSE=""
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""

RDEPEND="
	>=dev-libs/efl-1.20.0
"
DEPEND="${RDEPEND}"

DOCS=( README.md )

PATCHES=(
	"${FILESDIR}/cmake_lib_install.patch"
)
