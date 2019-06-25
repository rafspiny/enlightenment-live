# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib cmake-utils eutils l10n
[ "${PV}" = 9999 ] && inherit git-r3 autotools

DESCRIPTION="EFL Profiler Viewer"
#HOMEPAGE="https://www.enlightenment.org/"
HOMEPAGE="https://phab.enlightenment.org/w/projects/efl_profiling_viewer/"
EGIT_REPO_URI="https://git.enlightenment.org/devs/nikawhite/${PN}.git"

LICENSE="BSD-2"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""

RDEPEND="
    >=dev-libs/efl-1.18.0
    sys-libs/libunwind
"
DEPEND="${RDEPEND}"

#S="${WORKDIR}/${P}"
DOCS=( AUTHORS NEWS README )


src_configure() {
	local mycmakeargs=(
	)

	cmake-utils_src_configure
}
