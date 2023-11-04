# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{5..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 flag-o-matic
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="Python bindings for Enlightenment Foundation Libraries"
HOMEPAGE="https://github.com/DaveMDS/python-efl https://docs.enlightenment.org/python-efl/current/"
EGIT_REPO_URI="https://github.com/DaveMDS/${PN}.git"

LICENSE="|| ( GPL-3 LGPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="doc test"

RESTRICT="!test? ( test )"

RDEPEND=">=dev-libs/efl-1.22.99
	dev-python/dbus-python[${PYTHON_USEDEP}]
	sys-apps/dbus"
DEPEND="${RDEPEND}"
BDEPEND="=dev-python/cython-0.29.36-r0
	virtual/pkgconfig
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		media-gfx/graphviz
	)"

PATCHES=( "${FILESDIR}/python-efl-1.25-clang-crosscompile.patch" )

src_prepare() {
	default

	# Generate our own C files, discard the bundled ones.
	export ENABLE_CYTHON=1

	# Tries to download a file under /tmp
	rm tests/ecore/test_09_file_download.py || die

	# Tries to use that file which failed to download
	rm tests/ecore/test_10_file_monitor.py || die

	# Needs an active internet connection
	rm tests/ecore/test_11_con.py || die

	# Test fails because of deleted files above
	sed -i 's/>= 13/>= 10/g' tests/ecore/test_08_exe.py || die

	# Make tests verbose
	sed -i 's:verbosity=1:verbosity=3:' tests/00_run_all_tests.py || die

	# Disable any optimization on x86, #704260
	if use x86; then
		filter-flags -O?
		append-cflags -O0
	fi
}

python_compile_all() {
	default

	if use doc ; then
		esetup.py build_doc --build-dir "${S}"/build/doc/
	fi
}

python_test() {
	cd tests/ || die
	${EPYTHON} 00_run_all_tests.py --verbose || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( ./build/doc/html/. )
	distutils-r1_python_install_all
}

S="${WORKDIR}/${P/_/-}"
