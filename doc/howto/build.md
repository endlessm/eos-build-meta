# How to build EOS7

## Introduction 

This is a guide for developers, integrators and testers working on EOS7,
documenting how to build it.

The EOS7 build process is split into two stages, and so is this guide:

  1. OSTree build (defined in [eos-build-meta.git](https://github.com/endlessm/eos-build-meta/))
  2. Image build (defined in [eos-image-builder.git](https://github.com/endlessm/eos-image-builder))

In many cases you only need to run the ostree build, as you can test a new
ostree build by deploying it as an update to an existing machine, as documented
in `doc/howto/test.md`.

## OSTree build stage

### Automated Builds

Github Actions runs the OSTree build stage for each pull request open in
eos-build-meta.  It does not push the resulting OSTree anywhere, so you
can't use it directly. It does push all artifacts to the Endless cache server,
and you should pull these when building locally.

When a pull request lands in eos-build-meta's `main` branch, Github Actions
runs the OSTree build stage, and pushes the result to `os/eos/amd64/master`.
So if you need to test something already merged to eos-build-meta's
`main` branch you don't need to build it yourself.

### Local builds

#### Prerequisites

You need an `x86_64` machine with fast IO, many CPU cores, and a reliable
network connection.

  * A modern tower PC or server machine is a good choice.
  * A laptop is not a good choice unless it's very powerful. 
  * At least 100GB of disk space is recommended.

The machine needs to run a modern Linux distribution.

#### Important: Don't accept slow builds!

The BuildStream elements in eos-build-meta define a pipeline that builds
Endless OS completely from source code, using only a minimal
["binary-seed"](https://gitlab.com/freedesktop-sdk/freedesktop-sdk/-/wikis/freedesktop-sdk-binary-seed).
The pipeline is complex and it takes a loooong time to build Endless OS
completely from source code.

Endless provide an artifact cache with prebuilt artifacts for each element.
With correct configuration, BuildStream should download prebuilt artifacts
where possible and will only rebuild locally if you have local changes
affecting that element.

Read the following before building to ensure you don't waste time:

 1. Set up `~/.config/buildstream.conf` as documented below. BuildStream
    can't autodetect the ideal config for your build machine.

 2. Make sure your clone of `eos-build-meta.git` is in the same partition
    as the configured BuildStream cache directory. (When checking out
    artifacts from the cache, BuildStream can then can quickly hardlink
    each file instead of slowly copying each file).

 3. Make sure your build machine's power profile is set to "Performance".

 4. If you see BuildStream building elements with names that begin
    `freedesktop-sdk.bst:bootstrap/`, it is going to rebuild *everything*
    from source. This means caching is not working as expected, and your
    build will take all day.

#### Setup steps

##### Install build tools

EOS7 uses BuildStream with various 3rd party plugins, all which are implemented
in Python. Use `utils/requirements.txt` to get a set of known-good dependencies.

The recommended way to install the BuildStream is in a venv, using
[uv](https://docs.astral.sh/uv/), as follows:

    uv venv ./_venv
    uv pip install -p ./_venv -r utils/requirements.txt

Depending on your operating system, you might need to install some system
packages. You will need at least `make`.

You can run BuildStream inside of a suitably configured container.
[Toolbx](https://containertoolbx.org/) is known to work.

See also:

  * The BuildStream reference manual's
    ["Installing Dependencies"](https://docs.buildstream.build/master/main_install.html#installing-dependencies)
    section.
  * Freedesktop SDK guide's
    ["Prerequisites and dependencies"](https://freedesktop-sdk.gitlab.io/documentation/getting-started/prerequisites/)
    section

##### Configure Endless artifact cache servers

A BuildStream project can recommend cache servers in its project.conf, but that
doesn't travel across junctions. The eos-build-meta repo junctions two other projects,
freedesktop-sdk and gnome-build-meta, and each of these recommends an cache server.
So the default configuration has 3 cache servers. On startup, `bst` has to make GRPC
calls around the world to each of them, and if any is under load then this will block
`bst` startup.

To ensure fast operation of `bst`, it's recommended to ignore the Freedesktop and GNOME
caches, and connect only to Endless's cache.

In your `~/.config/buildstream.conf` file, add the following to achieve that:

```
projects:
  eos:
    artifacts:
      override-project-caches: true
      servers:
        - url: https://bstcache.endlessos.org
```

(Set `override-project-caches: false` if you're going to update the
`gnome-build-meta.bst` junction to a new GNOME OS base version, as in this case
the Endless cache won't have prebuilt artifacts).

##### Configure BuildStream scheduler

BuildStream runs pipeline jobs in parallel. It does not have a mechanism to monitor
the CPU, IO and RAM consumption of each job. It groups jobs by type and limits how
many jobs of a certain type can run in parallel. These limits have conservative
defaults to avoid overloading a "regular" build machine. You can increase or decrease
limits for certain job types depending on your build machine.

The "fetch" jobs download source code. Endless do not provide a source cache and
do not mirror upstream repos, so fetch jobs pull from the canonical upstream Git
servers and tarball servers and are constrained by your build machine's connection
speed to those. The default `fetchers` value is usually fine.

The "push" jobs are not relevant for local builds as only CI builds push to the artifact cache.

The "build" jobs are most complicated as these can be constrained by available CPU cores,
available RAM, and disk IO bandwidth. There are two config values relevant
here, because BuildStream runs build jobs in parallel, and each build job then
runs a build tool such as Make which will also parallelize work:

  * `build.max-jobs`, which limits how many cores each Make instance uses
  * `scheduler.builders`, which limits how many "build" jobs can run in parallel.

Each build machine has different constraints so we can only give a
recommendation. On a machine with 16 or fewer cores, try the default values first.
On a machine with more cores, leave max-jobs at the default (8), and set `builders`
to the number of cores divided by 8.

Beware that Linux's handling of resource overload situations can be hard to
reason about. If building on a machine that you use as a desktop, then when all
CPU cores are loaded, the desktop can become unusable. If memory becomes overloaded
(particularly when building large C++ projects like WebKitGTK), the OOM killer may
cause a compiler process to exit unexpectedly, which leads to a build failure.

Here's an example scheduler config for a 72 core machine in `~/.config/buildstream.conf`:

```
scheduler:
  builders: 9
```

See the BuildStream manual's
["Using > User configuration" section](https://docs.buildstream.build/2.5/using_config.html)
for a full guide to configuring BuildStream and for the default configuration.

Have fun! Building an operating system is fun once you get a good build
machine setup.

##### Generate local signing keys

In official Endless builds of EOS7, several components are signed with private
keys and certificates. In local builds, you won't have these private keys
available.

In your clone of `eos-build-meta.git`, run `make ostree-gpg` to create a
local GPG key for the OSTree repo. You only need to do this once.

#### Build steps

At this point, running the build pipeline to produce an OSTree is one command:

    bst build eos/repo.bst

As noted above, this should mostly pull artifacts from the Endless cache, and will
only build locally where you have local changes. (Since the OSTree signing key is
locally generated, you will always see a local build of `eos/repo.bst`.)

The `eos/repo.bst` element produces an OSTree repo with a single commit, containing
the new eos7 filesystem.

There is a helper in the Makefile which maintains a local OSTree repo in `./ostree-repo`.
Every time you run `make update-ostree`, it runs `bst build` and if any elements changed,
it'll use `bst artifact checkout` to get the new OSTree commit and import it into an
existing branch in `./ostree-repo`.

See [`doc/howto/test.md`](./test.md) for further instructions on how to test the OSTree
output.

## Image build stage

### Automated builds

Image builds of 'master' run nightly in a private Jenkins instance. (If you
have access, look for the job "nightly-master-pipeline").

If the nightly job succeeds, it uploads images to a private file server at
images.endless.org, under `/files/nightly/`.

### Local builds

#### Prerequisites

You need a fast x86_64 machine with plenty of disk space and IO.

Note that the eos-image-builder tool needs to run as the `root` user. It cannot
run inside of container tools like Podman or Toolbox.

#### Setup steps

Clone [eos-image-builder.git](https://github.com/endlessm/eos-image-builder).

Set up your `config/local.ini` file, which overrides the default image build
config. There are some suggestions below for what to configure, and see also
`config/local.ini.example` for more guidance.

##### `[ostree]`

If you're building an image from the 'master' ostree branch, leave the
`[ostree]` settings as their defaults.

If you built the ostree stage locally, configure eos-image-builder to
pull from wherever it is -- here's an example pulling from `localhost`:

    [ostree]
    deploy_server_url = http://127.0.0.1:8000
    pull_server_url = http://127.0.0.1:8000
    dev_repo_path =
    repo =

You'll need to replace the GPG key in `data/keys` with the locally generated
public key, exported as plain text with a `.asc` extension.

Note that while you can put multiple keys in `data/keys`, only the last one
will be used. The image builder maintains a repo in its cache, which embeds
the public key. It won't update the cache if you change files in `data/keys`,
you need to do that, or you'll see OSTree pull failures if you switch between
local and CI builds.

#### Build steps

Run this command in the eos-image-builder.git clone:

    sudo ./eos-image-builder

On success, it will tell you where to find your new image. See
`docs/howto/test.md` for a guide to testing.
