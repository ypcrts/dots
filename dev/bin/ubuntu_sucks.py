#!/usr/bin/env python2

"""
.--.--|  |--.--.--.-----|  |_.--.--.    .-----.--.--.----|  |--.-----.
|  |  |  _  |  |  |     |   _|  |  |    |__ --|  |  |  __|    <|__ --|
|_____|_____|_____|__|__|____|__________|_____|_____|____|__|__|_____|
                                  |______|https://github.com/ypcrts

This script takes a debian and ubuntu package name as a parameter
and outputs pretty formatted JSON listing the latest available
version of the package in both Debian and Ubuntu for recent LTS
version and other versions of interest.

This script wouldn't have to exist if Ubuntu didn't.
"""


import json
import os
import re

import requests


class DebianAPI(object):
    ENDPOINT = "https://sources.debian.net/api/src/{:s}/"
    SUITES_OF_INTEREST = ('sid', 'squeeze', 'wheezy', 'jessie', 'stretch')
    PKG_NAME_REGEX = re.compile(r"^[-_A-z0-9]+$")

    def __init__(self, pkg_):
        if not self.PKG_NAME_REGEX.match(pkg_):
            raise ValueError("invalid package name")
        self.pkg = pkg_

    def __call__(self):
        os.write(2, '.')
        r = requests.get(self.ENDPOINT.format(self.pkg))
        obj = r.json()
        ret = dict()
        for a in obj['versions']:
            version = a.get('version')
            suites = a.get('suites')
            if not version or not suites:
                continue
            for suite in suites:
                if suite not in self.SUITES_OF_INTEREST:
                    continue
                ret[suite] = max(ret.get(suite), version)
        return ret


class UbuntuSucks(DebianAPI):

    ENDPOINT = "https://api.launchpad.net/1.0/ubuntu/+archive/primary?ws.op=getPublishedSources&source_name={:s}&exact_match=true"
    LTS_SUITES = ('trusty', 'xenial',)
    HEAD_SUITES = ('artful',)
    SUITES_OF_INTEREST = LTS_SUITES + HEAD_SUITES

    def __call__(self):
        ret = dict()
        all_entries = []
        link = self.ENDPOINT.format(self.pkg)
        while True:
            r = requests.get(link)
            os.write(2, '.')
            obj = r.json()
            entries = obj.get('entries')
            assert entries, "inconsistent api response"
            all_entries.extend(entries)
            link = obj.get('next_collection_link')
            if not link:
                break
            assert link.startswith('https://api.launchpad.net/')

        for e in all_entries:
            pkg_, version, sep, suite = e.get('display_name', "").split(' ')
            assert pkg_ == self.pkg, "inconsistent api response"
            if suite not in self.SUITES_OF_INTEREST:
                continue
            status = e.get('status')
            if not status or status != "Published":
                continue
            ret[suite] = max(ret.get(suite), version)
        return ret


if __name__ == '__main__':
    import sys
    assert len(sys.argv) == 2
    writeme = dict(
        ubuntu=UbuntuSucks(sys.argv[1])(),
        debian=DebianAPI(sys.argv[1])()
    )
    os.write(2, '\n')
    sys.stdout.write(json.dumps(writeme, indent=2))

