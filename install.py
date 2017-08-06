#!/usr/bin/env python2.7
# vi: sts=4 ts=4 sw=4 et:

from __future__ import print_function

import argparse
import inspect
import os
import os.path
import shutil
import sys

STARTDIR = os.getcwd()
SRC_MACROS = ('@delete',)
manifest = None

rmtree = shutil.rmtree
rmfile = os.remove
makedirs = os.makedirs
symlink = os.symlink
chdir = os.chdir


def nop(f):
    """
    syscall nop function used with `--dry-run`
    """
    name = f.__name__

    def _nop(*a, **k):
        print('would:', name, *a, **k)
    return _nop


class Manifest(dict):

    def __init__(self, path, force):
        self.force = force
        if path:
            with open(path, 'r') as fp:
                self.parse(fp)

    def parse(self, fp):
        section = None
        for (i, line) in enumerate(fp, 1):
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            if line.startswith("$"):
                section_name = line.strip("$").strip()
                assert section_name not in self, \
                    "line {:d}: duplicate section declaration".format(i)
                section = self[section_name] = dict()
                continue

            assert section is not None, \
                "line {:d}: target definition before "\
                "section declaration".format(i)

            paths = map(lambda x: x.strip(), line.split(":"))
            assert len(paths) == 2, \
                "line {:d}: must be exactly one colon per line".format(i)

            dest, src = paths = map(lambda p: os.path.expanduser(p), paths)
            assert not src.startswith('@') or src in SRC_MACROS, \
                "line {:d}: unknown src macro {:}".format(i, src)
            has_glob = src.endswith('*')
            if has_glob:
                assert dest.endswith('/'), \
                    'line {:d}: glob dest must be directory '\
                    'ending with `/`'.format(i)
            section[dest] = src

    def install_file(self, dest, src):
        srcabs = os.path.normpath(os.path.join(STARTDIR, src))
        destabs = os.path.normpath(dest)
        destdir = os.path.dirname(destabs)
        destname = os.path.basename(destabs)

        if not os.path.isdir(destdir):
            makedirs(destdir, 0o755)
        elif os.path.lexists(destabs):
            if not self.force:
                print('skipped (exists):', destabs)
                return
            if os.path.isdir(destabs) and not os.path.islink(destabs):
                rmtree(destabs)
            else:
                rmfile(destabs)
        if src == '@delete':
            return
        assert os.path.exists(srcabs), \
            "Manifest src `{:}` does not exist on the filesystem"
        chdir(destdir)
        try:
            symlink(srcabs, destname)
            print('linked', destabs)
        except OSError as e:
            print(e, '::', destabs)

    def install_section(self, section_name):
        assert section_name

        for (dest, src) in self[section_name].iteritems():
            has_glob = src.endswith('*')
            if not has_glob:
                self.install_file(dest, src)
                continue

            glob_src_dir = os.path.normpath(
                os.path.join(STARTDIR, src.strip('*')))
            names = os.listdir(glob_src_dir)
            for name in names:
                self.install_file(
                    dest=os.path.join(dest, name),
                    src=os.path.join(glob_src_dir, name)
                )


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('section',
                        help='manifest target', type=str, nargs='*',
                        default=('default,'))
    parser.add_argument('-f', '--force',
                        help="remove any existing files or links",
                        action='store_true')
    parser.add_argument('-n', '--dry-run', action='store_true',
                        help='nop out all syscalls, verbose')
    parser.add_argument('-m', '--manifest', type=str,
                        help="path to custom manifest file",
                        default='./MANIFEST')

    args = parser.parse_args()
    if args.dry_run:
        print('dry run')
        rmtree = nop(rmtree)
        rmfile = nop(rmfile)
        makedirs = nop(makedirs)
        symlink = nop(symlink)
        chdir = nop(chdir)

    m = Manifest(force=args.force, path=args.manifest)
    for sn in args.section:
        assert sn in m, "section `{:s}` is not in the manifest".format(sn)

    for sn in args.section:
        m.install_section(sn)
