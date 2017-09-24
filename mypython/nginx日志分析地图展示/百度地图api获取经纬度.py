# coding=utf-8
import urllib2
import urllib
import json
import os
import re

url='https://api.map.baidu.com/location/ip?ak=ppbU3GlGzAvrumImczn4BS2PERpQ3nPd&ip='
IPadr=open('ip2.txt').readlines()
def map(ip):
    url_map = url + ip
    resp = urllib2.urlopen(url_map)
    html = resp.read()
    return html

for i in IPadr:
    print map(i)
