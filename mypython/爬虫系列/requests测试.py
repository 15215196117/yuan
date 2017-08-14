# coding=utf-8
import requests
# import pprint
import json
r = requests.get('http://cuiqingcai.com')
print type(r)
print r.status_code
print r.encoding
# print r.text
print r.cookies
#各种请求方法
'''
r = requests.post("http://httpbin.org/post") r = requests.post(url=,data=,json=) post 传入数据
r = requests.get("http://httpbin.org/post")  r = requests.get(url=url,params=None,) get 传入参数
r = requests.put("http://httpbin.org/put")
r = requests.delete("http://httpbin.org/delete")
r = requests.head("http://httpbin.org/get")
r = requests.options("http://httpbin.org/get")
'''
#不同请求方法 加的参数
payload = {'key1': 'value1', 'key2': 'value2'}
# r = requests.get("http://httpbin.org/get", params=payload)
# r = requests.post("http://httpbin.org/post", data=payload)
r = requests.post("http://httpbin.org/post", data=json.dumps(payload))#json格式化后 传入的数据
#添加代理
proxies = {
    "https": "http://41.118.132.69:4433"
}
r = requests.post("http://httpbin.org/post", proxies=proxies) #增加代理服务器 如ip地址池之类的
print r.text