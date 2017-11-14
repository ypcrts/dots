#!/usr/bin/env python

"""
webmshare.com python client by ypcrts
"""

from __future__ import print_function

import sys
import json
import pprint
from copy import deepcopy
import os.path
from itertools import chain

import requests
from lxml import html
from lxml.etree import tostring


def strbool(b):
    return 'Yes' if b else ''


def main(
        localFile,
        fileTitle=None,
        fileExpiration='never',
        soundOff=True,
        autoplay=True,
        loop=True):
    """
    for webm and gif only
    """
    assert fileExpiration == 'never' or isinstance(fileExpiration, int)
    s = requests.Session()
    s.headers = {
        'DNT': '1',
        'Referer': 'http://webmshare.com/',
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:57.0) Gecko/20100101 Firefox/57.0'
    }
    res = s.get('https://webmshare.com')
    tree = html.fromstring(res.text)

    # get csrf token or just fail miserably
    token = tree.xpath('.//input[@type="hidden"]')[0].value
    assert len(token) > 10

    # assert form structure
    selects = tree.xpath('//select')
    inputs = tree.xpath('//input')
    assert any(map(lambda x: x.name == 'fileExpiration', selects))
    for y in ['localFile', 'fileTitle', 'private', 'autoplay',
              'loop', 'sound']:
        assert any(map(lambda x: x.name == y, inputs))

    files = dict(
        _token=(None, str(token),),
        localFile=(os.path.basename(localFile), open(localFile, 'rb'),),

        remoteFile=(None, '',),

        fileExpiration=(None, str(fileExpiration),),

        fileTitle=(None, str(fileTitle),),

        autoplay=(None, strbool(autoplay)),
        sound=(None, strbool(soundOff)),  # yiss its fucked like this
        loop=(None, strbool(loop)),

        singlebutton=(None, '',),
    )

    req = requests.Request('POST', 'https://webmshare.com/upload', files=files)
    req = s.prepare_request(req)
    res = s.send(req, allow_redirects=False)
    tree = html.fromstring(res.text)
    errors = [
        err.text for err in
        tree.xpath('//*[contains(@class, "alert")]//li')
    ]
    if errors:
        json.dump({'errors': errors}, sys.stdout, indent=2)
        return 1

    containers = list(tostring(x) for x in tree.xpath('//body'))
    if 'Whoops' in chain(containers):

        # files['localFile'] = files['localFile'][0], '...',
        # req = requests.Request('POST', 'https://webmshare.com/upload', files=files).prepare()
        # print(req.body.decode())

        #pprint.pprint(res.request.headers, indent=2)

        print("Failed")
        return 1

    loc = res.headers.get('Location')
    print(loc)


if __name__ == '__main__':
    try:
        from fire import Fire
        Fire(main)
    except ImportError:
        main(*sys.argv[1:])
