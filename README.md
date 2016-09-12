# enlightenment-live

Enlightenment WM latest stable version and live ebuilds

## Package ebuild admission guidelines

Package ebuilds eligible for this overlay:

  * Live packages for git master and branches
     - enlightenment-9999 (live git master)
     - e.g. enlightenment-0.20.9999 (live git 0.20 branch)
  * Released versions as long as they aren't included in the official
    gentoo repository.
  * Important snapshots.

Additional requirements for each ebuild.

  * It must be buildable at the time of inclusion and reasonable effort
    must be taken to keep it buildable in the long term.

Package ebuilds that are not buildable should be either fixed or removed.
