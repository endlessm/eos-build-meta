# EOS7 images

This is an overview of the available types of image for Endless OS 7
and how they are produced. It's up to date as of 2025-10-10.

## Image variants

Official images of Endless OS are built in an internal CI system with a set of
predefined configs.

The latest in-development version is built by "nightly-master-pipeline", which
produces the variants documented below.

Release pipelines can produce more variants which aren't listed here. And since
Endless OS is developed in the open, there can be an infinite variety of
unofficial builds as well.

## eos-amd64-amd64-base

This image variant targets all users.

To produce it, CI calls eos-image-builder with the following flags:

    --product=eos --arch=amd64 --platform=amd64 --personality=base

Image files for this variant use the prefix `eos-amd64-amd64`.

## eosinstaller-amd64-amd64-base

TBD

## eosimpact-amd64-payg-base

This image is specifically for Pay-as-you-Go laptops. It includes private
components and can only be built inside Endless.

To produce it, CI calls eos-image-builder with the following flags:

    --product=eosimpact --arch=amd64 --platform=payg --personality=base

# Image build process

Images are built using eos-image-builder. Here is are documentation links:

  * The [eos-image-builder README](https://github.com/endlessm/eos-image-builder/blob/master/README.md)
  * The ["Endless OS Image Builder"](https://support.endlessos.org/en/deployment/image-builder) support guide.

If you want a guide to building images locally, see [`doc/howto/build.md`](doc/howto/build.md).
