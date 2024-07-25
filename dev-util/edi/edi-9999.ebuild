# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 meson llvm-r1

DESCRIPTION="An IDE using EFL"
HOMEPAGE="https://git.enlightenment.org/enlightenment/edi.git"
EGIT_REPO_URI="https://git.enlightenment.org/enlightenment/edi.git"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE=""

RDEPEND="
	>=dev-libs/efl-1.18.0
	>=sys-devel/llvm-11:=
"
DEPEND="${RDEPEND}
dev-util/bear
dev-libs/check
"

S="${WORKDIR}/${P/_/-}"
DOCS=( AUTHORS NEWS README.md )

# only if you need to define one explicitly
pkg_setup() {
	llvm_pkg_setup
}

src_configure() {
	local llvm_prefix="$(get_llvm_prefix)"
	local llvm_include="${llvm_prefix}/include/"
	local llvm_lib="${llvm_prefix}/lib64/"

	einfo "${llvm_include}"
	local emesonargs=(
		-D libclang-libdir=${llvm_lib}
		-D libclang-headerdir=${llvm_include}
	)
	meson_src_configure
}
