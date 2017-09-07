#!/usr/bin/env bash
官方的文档是最完整的文档没有之一,建议直接参考官方文档
http://nginx.org/en/docs/
推荐几个不常用的模块
Google代理模块:http://nginx.org/en/docs/ngx_google_perftools_module.html
WAF防护模块(秒硬件防火墙):https://github.com/nbs-system/naxsi
nginx消息订阅:https://www.nginx.com/resources/wiki/modules/push_stream/
nginx限制连接数量/流量     :ngx_http_limit  http://nginx.org/en/docs/http/ngx_http_limit_req_module.html
    limit_zone lit_zone $binary_remote_addr 20m;
    limit_req_zone $binary_remote_addr zone=ctohome_req_zone:20m rate=2r/s; #设置保存区域大小为10M(k/v保存用户的访问记录，每秒钟的访问量不超过次)
ab测试 # ab -c 10 -n 300 http://onepieceyuan.com
nginx转发模块(端口转发udp tcp 挺实用的) http://nginx.org/en/docs/stream/ngx_stream_core_module.html#stream  #设置在http标签外面

其他的反向代理（4种算法，官方好像不止这几种了）301，302跳转 location 设置 这些网上一大把  也可以参考之前的博客  http://blog.csdn.net/onepieceyuan

祝愿nginx越来越好