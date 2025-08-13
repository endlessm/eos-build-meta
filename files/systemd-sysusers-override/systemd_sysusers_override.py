#!/usr/bin/env python3

"""
Helper script to patch sysusers.d config files.

In EOS7 we need to force static UIDs and GIDs for certain system users and
groups, for backwards compatibility with EOS6.

We could do this by patching systemd.git or setting configure args in the
freedesktop-sdk.bst/components/systemd-base.bst element. That means taking
ownership of the whole systemd build instead of reusing the one from FDSDK,
which creates ongoing extra work when updating the freedesktop-sdk.bst
junction.

Using this tool, a filesystem preparation hook in `eos/repo.bst` can
instead post-process the sysusers.d files installed by system components.
"""

import argparse
import sys
from typing import Optional
from pathlib import Path


def modify_config(input_path: Path,
                  user: Optional[str] = None,
                  group: Optional[str] = None,
                  static_id: Optional[int] = None):
    found_user = False
    found_group = False

    if not (user or group) or not static_id:
        return

    lines = input_path.read_text().splitlines()

    for i, line in enumerate(lines):
        if line.strip().startswith('#') or not line.strip():
            continue

        parts = line.split()
        if len(parts) < 3:
            continue

        type_, name, id_spec, *rest = parts

        # Match user or group
        if user and type_ in ['u', 'u!'] and name == user:
            found_user = True
            if ':' in id_spec:  # If there's both UID:GID
                uid, gid = id_spec.split(':')
                uid = str(static_id)
                new_id_spec = f"{uid}:{gid}"
            else:  # Single ID
                new_id_spec = str(static_id)
            lines[i] = f"{type_}   {name}   {new_id_spec}   {' '.join(rest)}"
        elif group and type_ == 'g' and name == group:
            found_group = True
            new_id_spec = str(static_id)

            lines[i] = f"{type_}   {name}   {new_id_spec}   {' '.join(rest)}"

    if user and not found_user:
        raise RuntimeError(f"User '{user}' was not found in file '{input_path}'")
    if group and not found_group:
        raise RuntimeError(f"Group '{group}' was not found in file '{input_path}'")

    # Write back to file
    input_path.write_text('\n'.join(lines) + '\n')


def main():
    parser = argparse.ArgumentParser(description='Override systemd-sysusers config with static IDs')
    parser.add_argument('config_file', type=Path, help='Path to sysusers config file')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--user', help='User to modify')
    group.add_argument('--group', help='Group to modify')
    parser.add_argument('--static-id', type=int, required=True, help='Static ID to set')

    args = parser.parse_args()

    if not args.config_file.exists():
        print(f"Error: Config file {args.config_file} does not exist", file=sys.stderr)
        sys.exit(1)

    modify_config(args.config_file, args.user, args.group, args.static_id)


try:
    main()
except RuntimeError as e:
    sys.stderr.write(f"ERROR: {e}\n")
    sys.exit(1)
