package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

var url  = "https://api.map.baidu.com/location/ip?ak=ppbU3GlGzAvrumImczn4BS2PERpQ3nPd&ip="
//var ip  = ""

func http_get() {
	resp, err := http.Get(url + "101.226.162.90")
	if err != nil {
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body) //请求数据进行读取
	if err != nil {
		// handle error
	}
	fmt.Println(string(body))
}
