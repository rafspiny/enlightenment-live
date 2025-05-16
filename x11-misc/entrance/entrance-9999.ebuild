# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson
[ "${PV}" = 9999 ] && inherit git-r3

DESCRIPTION="Entrance - An EFL based display manager."
HOMEPAGE="https://github.com/wltjr/entrance"
EGIT_REPO_URI="https://github.com/Obsidian-StudiosInc/${PN}.git"
[ "${PV}" = 9999 ] || SRC_URI="https://github.com/Obsidian-StudiosInc/${PN}/archive/v${P}.tar.gz"

LICENSE="GPL-3"
[ "${PV}" = 9999 ] || KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="debug nls pam systemd"

RDEPEND="
	dev-libs/efl[X]
	nls? ( sys-devel/gettext )
	pam? ( sys-libs/pam )
	systemd? ( sys-apps/systemd )
"

BDEPEND="${RDEPEND}
	dev-build/meson"

src_configure() {
	prefix=/usr/share
	local emesonargs=(
	    --prefix "${prefix}"
	    --bindir "${prefix}/bin"
	    --sbindir "${prefix}/sbin"
	    --datadir "${prefix}/share"
	    --sysconfdir "/etc"
		-Ddebug=$(usex debug true false)
		-Dnls=$(usex nls true false)
		-Dpam=$(usex pam true false)
		-Dlogind=$(usex systemd true false)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if use systemd; then
	    systemctl daemon-reload
	fi
}

pkg_postinst() {
	if use systemd; then
	    einfo "Systemd detected."
	    einfo "Before proceeding you may have to disable the current ldm. Suppose you have lightdm installed:"
	    einfo "> systemctl disable lightdm.service"
	    einfo ""
	    einfo "Please, run the following command to enable entrance:"
	    einfo "> systemctl enable entrance.service"
	else
	    einfo "Enable entrance by customising your rc.conf file"
	fi
}
