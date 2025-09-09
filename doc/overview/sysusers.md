# System users and groups

## Introduction

This document is about how UNIX user accounts and groups are managed in Endless OS.

User accounts and groups are a core part of the UNIX security model.  Each user
account has a name, and an integer ID. Each group similarly has a name and ID.

An Endless OS system has several kinds of user account:

 * The `root` user account -- always present, used for administration.
 * System user accounts -- created for system services, not for logging in directly.
 * Regular user accounts -- created during OS setup for end-users to login.

Groups can be divided similarly into "system" and "user" groups.

Groups can also be divided into "primary" and "secondary" groups. A primary
group corresponds to a specific user account and has only one member. A
secondary group can have multiple members and usually controls access to a
shared resource, such as `audio` or `sudo`. Secondary groups are mutable.

### Referring to system user accounts and groups

The system user accounts have "standard" names within the system.  For example,
the colord service in Endless OS might expect a `colord` system user to exist on
every system.

At runtime, there is a system-wide database of user accounts and groups
accessible via a standard method, the Name Switch Service (NSS),
which is documented in the GNU GLIBC documentation under
["System Databases and Name Service Switch"](https://www.gnu.org/software/libc/manual/html_node/Name-Service-Switch.html).

The database can be implemented in a variety of different ways. The simplest
way is by storing all the data in files `/etc/passwd` and `/etc/group`. More
complicated storage methods are configurable using the NSS config file
`/etc/nsswitch.conf`.

The systemd project defines a new [user/group API](https://systemd.io/USER_GROUP_API/)
to access the system-wide database of user accounts and groups. This can be accessed
through the directory `/run/systemd/userdb/` which contains one or more Varlink endpoints
implementing the `io.systemd.UserDatabase` interface.

The new systemd API integrates with NSS via a
[nss-systemd plugin](https://www.freedesktop.org/software/systemd/man/latest/nss-systemd.html).
In theory, modern systems could drop the files `/etc/passwd` and `/etc/group`,
but they would first need to ensure that no important code in the system ever
tried to read directly from those files.

The systemd project also defines ways that services can extend the system-wide
database to include more accounts and grousp, by exposing compatible endpoints
in `/run/systemd/userdb`.

### Static vs dynamic IDs for system users

System user IDs can be allocated statically, by assigning a fixed number at
system integration time. This means every deployment has the same ID for
the given user.

They can also be allocated dynamically, for example at package install time
or on first-boot. This means that different deployments might have different
IDs for a given user.

Mixing static IDs and dynamic IDs is dangerous, because if you define a new
static UID in a system update, it could conflict with an existing dynamically
created UID in a given deployment.

## Implementation

EOS7 is based on GNOME OS, but aims for backwards compatibility with all previous
versions of EOS that were based on Debian, so we will look at how system users
are handled in each of those systems.

### EOS6

EOS6 uses static IDs for all system users. Read on for how this works.

#### Integration time

EOS6 is based on Debian 12 (Bookworm). Like Debian, it uses a package named
[base-passwd](https://tracker.debian.org/pkg/base-passwd) to define system user
accounts.

The Endless version of this package is at: <https://github.com/endlessm/base-passwd>.
It contains two files that define specific system user accounts and groups with
names and static IDs:

  * [passwd.master](https://github.com/endlessm/base-passwd/blob/master/passwd.master)
  * [group.master](https://github.com/endlessm/base-passwd/blob/master/group.master)

These extend the Debian 12 equivalents
([group.master](https://sources.debian.org/src/base-passwd/3.6.7/passwd.master),
[passwd.master](https://sources.debian.org/src/base-passwd/3.6.7/group.master)) with
users and groups for some systemd services and some Endless OS-specific services.

The base-passwd package build rules install the `.master` files into
`/usr/share/base-passwd` in the filesystem, and additionally install them to
`/etc/passwd` and `/etc/group`.

Packages that install system services can define system users. This is done in a
"postinst" hook. For example, the geoclue-2.0 package has a
[`geoclue-2.0.postinst` file](https://sources.debian.org/src/geoclue-2.0/2.7.2-2/debian/geoclue-2.0.postinst)
that creates a user, which will have a dynamically allocated ID, written in the
moment to `/etc/passwd` in the filesystem. It also updates filesystem ownership
information using the newly allocated ID.

EOS6 modifies Debian 12 to work with OSTree, following the guidelines in
OSTree's documentation at
["Adapting existing mainstream distributions > System users and groups"](https://ostreedev.github.io/ostree/adapting-existing/#system-users-and-groups).

In eos-ostree-builder, the ostree stage runs a script named `split_passwd_files`
which does the following:

  * Gets the list of static system user IDs from `/usr/share/base-passwd/passwd.master`
  * Gets the list of all IDs from `/etc/passwd`, including dynamically allocated IDs
  * Writes `root` and any dynamically allocated users to `/etc/passwd`
  * Writes all the statically allocated users to `/lib/passwd`
  * Does the same for groups, making sure that all mutable (secondary) groups also
    go into `/etc/passwd`.

#### Runtime

The file `/lib/passwd` is immutable at runtime, and can only be changed by
deploying updates.

The file `/etc/passwd` can be modified by end-users, and by deploying updates.
OSTree will try to apply changes in `/usr/etc/passwd` to the existing `/etc/passwd`
file at update time. This can cause conflicts, which is why EOS6 prefers to define
as many user accounts in `/lib/passwd` instead.

The `/etc/nsswitch.conf` file defines the following:

```
passwd:         files altfiles systemd
group:          files altfiles systemd
shadow:         files systemd
gshadow:        files systemd
```

This means that user accounts lookups go first to `/etc/passwd`, then to `/lib/passwd`
(via the [nss-altfiles plugin](https://github.com/aperezdc/nss-altfiles)), then finally
to the systemd user/group API via the [nss-systemd plugin](https://www.freedesktop.org/software/systemd/man/latest/nss-systemd.html).

### GNOME OS

GNOME OS uses dynamic IDs for almost all system users and groups. Read on for more information.

#### Integration

The `gnomeos/usr-image.bst` element runs
[`prepare-image.sh`](https://gitlab.com/freedesktop-sdk/freedesktop-sdk/-/blob/freedesktop-sdk-24.08.22/files/vm/prepare-image.sh?ref_type=tags)
which creates an initial `/etc/passwd` and `/etc/group` with just a
`root` user.

Elements that need to create system users install config files into
`/usr/lib/sysusers.d` in the final system. For example,
[components/cups-base.bst](https://gitlab.com/freedesktop-sdk/freedesktop-sdk/-/blob/freedesktop-sdk-24.08.22/elements/components/cups-base.bst)
installs
[files/cups/sysusers.conf](https://gitlab.com/freedesktop-sdk/freedesktop-sdk/-/blob/freedesktop-sdk-24.08.22/files/cups/sysusers.conf)
which defines a user named `lp`, in the systemd-sysusers config format.
There is no user ID defined in the config file -- it will be allocated
dynamically by systemd-sysusers when the OS boots for the first time.

There is no way to create a file owned by a system user at integration
time, because the user ID isn't defined until later. Elements that need
to pre-create files owned by system users must install a
systemd-tmpfiles config file. The `cups-base.bst` element installs
[`files/cups/tmpfiles.conf`](https://gitlab.com/freedesktop-sdk/freedesktop-sdk/-/blob/freedesktop-sdk-24.08.22/files/cups/tmpfiles.conf)
which references the `lp` user by name, rather than by ID. When the
OS boots for the first time, systemd-tmpfiles will run after
systemd-sysusers has run and will create the necessary files.

#### Run time

The `systemd-sysusers.service` service runs during early boot (before sysinit.target).
and calls the `systemd-sysusers` program. This program reads the sysusers.d
config and creates any system users and groups in /etc/passwd and /etc/group
that aren't already defined there.

Note that the GNOME OS initramfs contains systemd, and that *also* runs systemd-sysusers.
So, when looking at the journal entry for a single boot, you will see two sets of logs
from systemd-sysusers, first the initramfs and then the main system.

In `/etc/nsswitch.conf`, the configuration is as follows:

```
passwd: files systemd
group: files [SUCCESS=merge] systemd
shadow: files
```

This enables the [systemd user/group API](https://systemd.io/USER_GROUP_API/)
while also remaining compatible with NSS.

### EOS7

EOS7 defines static IDs for system users and groups only in the following cases:

  * The system user or group already has a static ID in EOS6
  * The system user or group may own files in /etc or /var in existing EOS6 deployments

For new system users and groups, and for those which never own files in /etc or /var,
always use dynamic IDs.

#### Integration time

Elements from Freedesktop SDK and GNOME OS that install `sysusers.d` config files
are re-used as is. These don't set static UIDs or GIDs except for a few special cases,
so each deployment can potentially have a different IDs for groups like 'wheel'.

Endless-specific elements install sysusers.d config files reserving the same UID and
GID that EOS6 used.

The `eos/config/systemd-sysusers-config.bst` element installs some additional
`sysusers.d` config files to reserve certain user IDs for backwards and forwards
compatibility.

In the `eos/repo.bst` element, some of the existing sysusers.d config files are
modified to set static UIDs or GIDs, to match what was used in EOS6. This is
done with a simple helper tool named `systemd_sysusers_override.py`.

We only do this when files in `/etc/` or `/var/` may exist and be owned by those
UIDs and GIDs. For example, it would cause problems if the ID of the
`systemd-journal` group changed at upgrade time because the user would lose access
to existing content in `/var/lib/journal` .

#### Runtime

At runtime, EOS7 runs `systemd-sysusers.service` just like in GNOME OS.
