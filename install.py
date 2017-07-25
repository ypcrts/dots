#!/usr/bin/env python2.7

from __future__ import print_function

import sys
import os
import os.path

startdir = os.getcwd() 

with open('./MANIFEST', 'r') as fp:
  for (i, line) in enumerate(fp, 1):
    line = line.strip()
    if not line:
      continue
    parts = map(lambda x: x.strip(), line.split(":"))
    if len(parts) != 2:
      sys.stderr.write('skipping line {:d}: `{:s}`\n'.format(i, line))

    dest, src = parts

    srcabs = os.path.normpath(os.path.join(startdir, src))
    destabs = os.path.normpath(dest)
    destdir = os.path.dirname(destabs)
    destname = os.path.basename(destabs)

    if not os.path.isdir(destdir):
      os.makedirs(destdir, 0755)

    os.chdir(destdir)
    if os.path.isfile(destabs):
      if os.path.islink(destabs):
        continue
      os.remove(destname) 
    try: 
      os.symlink(srcabs, destname)
    except OSError as e:
      print(e, '::', destabs)


# vim: set sts=2 ts=2 sw=2 et:

