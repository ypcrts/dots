# dots-dom0

```
usage: install.py [-h] [-n] [-m MANIFEST] [-f | -p] [-v]
                  [section [section ...]]

creates symlinks described by a manifest

positional arguments:
  section               manifest target

optional arguments:
  -h, --help            show this help message and exit
  -n, --dry-run         nop out all syscalls, verbose
  -m MANIFEST, --manifest MANIFEST
                        path to custom manifest file
  -f, --force           on install, remove any existing files or links
  -p, --purge           remove the link or file at target paths
  -v, --verbose
```

## `MANIFEST` syntax

- `~/bin/destination_link: ./section/source_file` 
  - destination-to-source mapping, with the two arguments delimited by a colon

- `$ bin`
  - defines the `bin` section

- `/bin/sh: @delete`
  deletes /bin/sh

- `@include: bin default`
   - includes `bin` and `default`
   - in each run of `install.py` includes are resolved so that they are only processed once



