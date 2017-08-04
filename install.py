#!/usr/bin/env python2.7
# vi: sts=2 ts=2 sw=2 et:

from __future__ import print_function

import sys
import os
import os.path
import argparse
import shutil

parser = argparse.ArgumentParser()
parser.add_argument('section', help='manifest target', type=str)
parser.add_argument('-f','--force', help="remove any existing file", action='store_true')
args = parser.parse_args()

STARTDIR = os.getcwd() 


def link_one(dest, src):
  srcabs = os.path.normpath(os.path.join(STARTDIR, src))
  destabs = os.path.normpath(dest)
  destdir = os.path.dirname(destabs)
  destname = os.path.basename(destabs)

  if not os.path.isdir(destdir):
    os.makedirs(destdir, 0755)
  elif os.path.lexists(destabs):
    if not args.force:
      print('skipping existing file:', destabs)
      return
    if os.path.isdir(destabs) and not os.path.islink(destabs):
      shutil.rmtree(destabs)
    else:
      os.remove(destabs) 
  if src == '@delete':
    return
  os.chdir(destdir)
  try:
    os.symlink(srcabs, destname)
    print('linked', destabs)
  except OSError as e:
    print(e, '::', destabs)


def link_from_manifest(path='./MANIFEST'):
  found_section = None
  with open(path, 'r') as fp:
    for (i, line) in enumerate(fp, 1):
      line = line.strip()
      if not line or line.startswith("#"):
        continue
      if line.startswith("$"):
        if found_section:  # stop at beginning of next section
          break
        section = line.strip("$").strip()
        if section == args.section:
          found_section = True
          continue
      
      if not found_section:
        continue

      parts = map(lambda x: x.strip(), line.split(":"))
      if len(parts) != 2:
        sys.stderr.write('skipping line {:d}: `{:s}`\n'.format(i, line))

      dest, src = map(lambda p: os.path.expanduser(p), parts)
      has_glob = src.endswith('*')
      if not has_glob:
        link_one(dest, src)
      else: 
        assert dest.endswith('/'), 'malformed manifest'
        glob_src_dir = os.path.normpath(os.path.join(STARTDIR, src.strip('*')))
        names = os.listdir(glob_src_dir)
        for name in names:
          link_one(src=os.path.join(glob_src_dir, name),
                   dest=os.path.join(dest, name))

  if not found_section:
    print('Unable to find section {:s}'.format(args.section))

link_from_manifest()
