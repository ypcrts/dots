#!/usr/bin/env python3
# vi: sts=4 ts=4 sw=4 et:

from __future__ import print_function

import argparse
import logging
import os
import sys
from os import chdir, makedirs, remove, symlink
from os.path import (basename, dirname, exists, expanduser, isdir, islink,
                     join, lexists, normpath)
from pprint import pprint
from shutil import rmtree


is_windows = sys.platform in ('win32', 'cygwin',)
# is_linux = sys.platform.startswith('linux')
# is_macos = sys.platform ==  'darwin'
PY3 = sys.version_info >= (3, 0, 0,)
if PY3:
    def iteritems(obj): return obj.items()
else:
    if is_windows:
        raise EnvironmentError('python 3 required on windows')
    # Due to missing py2 os.symlink: but could call using ctypes

    def iteritems(obj): return obj.iteritems()



STARTDIR = os.getcwd()
log = logging.getLogger(__name__)
log.setLevel(logging.WARN)
log.addHandler(logging.StreamHandler())


class IllegalSyntax(Exception):
    pass


def nop(f):
    """
    syscall nop function used with `--dry-run`
    """
    name = f.__name__

    def _nop(*a, **k):
        log.debug('nop: %s %s %s' % (name, a, k))
    return _nop


class Manifest(dict):
    DELETE_MACRO = '@delete'
    INCLUDE_MACRO = '@include'
    SRC_MACROS = {DELETE_MACRO}
    DEST_MACROS = {INCLUDE_MACRO}

    def __init__(self, path, force):
        self.force = force
        if path:
            with open(path, 'r') as fp:
                self._parse(fp)

    @staticmethod
    def _parse_line_comment(line):
        return not line or len(line) and line[0] == "#"

    @staticmethod
    def _parse_line_section_declaration(line):
        has_prefix = line and len(line) and line[0] == "$"
        if not has_prefix:
            return None
        if line[-1] in '@*:':
            raise IllegalSyntax(
                "section name {:s} cannot end in {:s}".format(line[:-1], line[-1]))
        return line.strip("$").strip()

    @staticmethod
    def _parse_part_macro(part):
        return part and isinstance(part, str) and part.startswith("@")

    @staticmethod
    def _is_macro_or_parsed(rubberducky):
        return rubberducky and (
            not isinstance(
                rubberducky,
                str) or rubberducky.startswith('@'))

    @staticmethod
    def _parse_part_terminal_glob(part):
        return part and isinstance(part, str) and part.endswith("*")

    def _parse(self, fp):
        section = None
        for (i, line) in enumerate(fp, 1):
            line = line.strip()
            if self._parse_line_comment(line):
                continue

            new_section = self._parse_line_section_declaration(line)
            if new_section:
                if new_section in self:
                    raise IllegalSyntax(
                        "line {:d}: duplicate section declaration".format(i))
                section = self[new_section] = dict()
                continue
            elif section is None:
                raise IllegalSyntax("line {:d}: target definition before "
                                    "section declaration".format(i))

            paths = line.split(":", 2)
            unparsed_separators = paths[-1].find(':') > -1
            if unparsed_separators:
                raise IllegalSyntax("line {:d}: multiple colons".format(i))

            dest, src = paths = map(lambda p: p.strip(), paths)
            dest_is_macro = self._parse_part_macro(dest)
            src_is_macro = self._parse_part_macro(src)

            if dest_is_macro:
                if dest not in self.DEST_MACROS:
                    raise IllegalSyntax(
                        "line {:d}: invalid {:}".format(
                            i, dest))

            if dest == self.INCLUDE_MACRO:
                src = set(src.split(' '))
            elif src_is_macro:
                if src not in self.SRC_MACROS:
                    raise IllegalSyntax(
                        "line {:d}: invalid {:}".format(
                            i, src))

            if not (dest_is_macro or src_is_macro):
                if dest in section:
                    raise IllegalSyntax("line {:d}: target redefinition `{:}` "
                                        "in same section".format(i, dest))

                has_glob = self._parse_part_terminal_glob(src)
                assert has_glob ^ (not dest.endswith('/')), \
                    'line {:d}: glob dest must be directory '\
                    'ending with `/`'.format(i)

            section[dest] = src

    def install_file(self, dest, src):
        """
        :assumptions: manifest has already been parsed and validated.
        """
        destdir = dirname(dest)
        destname = basename(dest)

        if not isdir(destdir):
            makedirs(destdir, 0o755)
        elif lexists(dest):
            if not self.force:
                log.info('skipped (exists): %s' % dest)
                return
            if isdir(dest) and not islink(dest):
                rmtree(dest)
            else:
                remove(dest)
        chdir(destdir)
        if src in self.SRC_MACROS:
            if src == self.DELETE_MACRO:
                if lexists(dest):
                    remove(dest)
            else:
                assert False
            return
        assert exists(src), \
            "Manifest src `{:}` does not exist on the filesystem".format(src)
        try:
            # XXX: Following line's kwarg is useless. [ypcrts // 20180120]
            # symlink(src, destname, target_is_directory=isdir(src))
            # XXX: No kwargs in py3. Should be unnecessary per docs:
            #     "If the target is present, the type of the symlink will be created to match."
            #      - https://docs.python.org/3.6/library/os.html
            symlink(src, destname)
            log.warning('linked %s' % dest)
        except OSError as e:
            log.error('failure - %s :: %s' % (e, dest))

    def iter_section(self, section_name, included=None):
        # recursive base case
        if not included:
            included = set()
        included.add(section_name)
        for (dest, src) in iteritems(self[section_name]):
            if not self._is_macro_or_parsed(src):
                src = normpath(join(STARTDIR, expanduser(src)))
            if not self._is_macro_or_parsed(dest):
                dest = normpath(expanduser(dest))
            else:
                if dest == self.INCLUDE_MACRO:
                    included.update(src)
                    for sn in src:
                        assert sn != section_name,\
                            "cannot include `{:}` inside itself'\
                                '!".format(section_name)
                        assert sn in self, \
                            "cannot include `{:}` '\
                                '- does not exist".format(section_name)
                        for s in self.iter_section(sn, included):
                            yield s
                    continue
                else:
                    assert False

            dest = normpath(dest)
            has_glob = self._parse_part_terminal_glob(src)
            if not has_glob:
                yield dest, src
                continue

            src = src.strip('*')
            names = os.listdir(src)
            for name in names:
                yield (join(dest, name), join(src, name),)


class Actions:
    def __init__(self, manifest, args):
        self.manifest = manifest
        self.args = args
        self._assert_symlink_works()

    def install(self):
        for section in self.args.section:
            for (dest, src) in self.manifest.iter_section(section):
                self.manifest.install_file(dest, src)

    def purge(self):
        for section in self.args.section:
            for (dest, src) in self.manifest.iter_section(section):
                if lexists(dest) or exists(dest):
                    log.warning('purged %s' % dest)
                    remove(dest)

    def inspect(self):
        print('inspecting...')
        pprint(dict(
            (key, self.manifest[key].get('@include', None),)
            for key in self.manifest.keys()
        ))

    def _assert_symlink_works(self):
        if self.args.no_preflight:
            return True
        nonce = 'symlinknonce-lkjho8ho98hp923h4iouh90sa0d98u9d8j1p92d8'
        target = nonce + '.target'
        try:
            symlink(nonce, target)
        except OSError:
            raise
        finally:
            if lexists(target):
                remove(target)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='creates symlinks described by a manifest')
    parser.add_argument('action',
                        choices=('install', 'purge', 'inspect'),
                        nargs='?', default='install')
    parser.add_argument('section',
                        help='manifest target', type=str, nargs='*')
    parser.add_argument('-n', '--dry-run', action='store_true',
                        help='nop out all syscalls, verbose')
    parser.add_argument('-m', '--manifest', type=str,
                        help='path to custom manifest file',
                        default='./MANIFEST')
    parser.add_argument('-f', '--force', action='store_true',
                        help='allow clobbering files in target paths')
    parser.add_argument('-v', '--verbose', default=0, action='count')
    parser.add_argument(
        '--no-preflight',
        action='store_true',
        dest='no_preflight')

    args = parser.parse_args()

    if args.dry_run:
        args.verbose = 3
        log.warn('seting up dry run')
        rmtree = nop(rmtree)
        remove = nop(remove)
        makedirs = nop(makedirs)
        symlink = nop(symlink)
        chdir = nop(chdir)

    if args.verbose >= 2:
        log.setLevel(logging.DEBUG)
    elif args.verbose >= 1:
        log.setLevel(logging.INFO)

    m = Manifest(force=args.force, path=args.manifest)
    args.section = list(map(lambda sn: sn.rstrip('/'), args.section))
    for sn in args.section:
        assert sn in m, "section `{:s}` is not in the manifest".format(sn)

    getattr(Actions(m, args), args.action)()
