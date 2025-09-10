# Shim

This directory contains:

  * `shimx64.efi`: Shim bootloader binary signed with Microsoft Corporation UEFI
    certificate, fetched from
    <https://github.com/endlessm/shim-review/releases/tag/endless-shim-x64-20240822>
  * `mmx64.efi`: Shim MOK Manager binary signed with Endless Secure Boot CA
    certificate, copied from an EOS6 system.
  * `fbx64.efi`: Shim fallback loader binary signed with Endless Secure Boot CA
    certificate, copied from an EOS6 system.
  * `bootx64.csv`: UEFI bootloader entry for Endless OS. Note that it must be
    wide character format (UCS-2) to be compatible with the UEFI standard.
