# coding=utf-8
# Requests：data为dict，json
import requests测试
import urllib2,cookielib,urllib
url = 'https://console.qingcloud.com/gd1/instances/'
#爬虫根据cookie验证
# cookie_support = urllib2.HTTPCookieProcessor(cookielib.CookieJar())
# opener = urllib2.build_opener(cookie_support,urllib2.HTTPHandler)
data = {}
headers = {'Cookie':'gr_user_id=dc2c05c2-f50b-4320-af16-6e4889bcd9d7; nav_toggle=hide; resource_group=self_resources; __utma=52871208.2107917556.1502332784.1502338288.1502338288.1; __utmz=52871208.1502338288.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _gat=1; sk=oeuztz9tWXmNCoMPbXLczgzNOU3aBOU2; Hm_lvt_17a3a88cbe9f9c8808943e8ed1c7155a=1502332779,1502423150; Hm_lpvt_17a3a88cbe9f9c8808943e8ed1c7155a=1502433621; lang=zh-cn; csrftoken=9efuufWebcsG7vj4mXjRSHGEZATnfY1m; sid=segr9chrcuesqgq2xg9chyaoo797wbga; zone=gd1; _ga=GA1.2.2107917556.1502332784; _gid=GA1.2.1409371773.1502332784; gr_session_id_ab7e0583a75979c5=1fe187c7-209d-4161-8797-2bfab2f1cb6e; gr_cs1_1fe187c7-209d-4161-8797-2bfab2f1cb6e=user_id%3Ausr-eE1RGO00',
           'Referer':'https://console.qingcloud.com/gd1','User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.78 Safari/537.36',
           'X-CSRFToken':'9efuufWebcsG7vj4mXjRSHGEZATnfY1m'}
r = requests测试.get(url=url, headers=headers)
# r = requests.get(url=url)
print r.text