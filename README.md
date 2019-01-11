# dig_cdn_ip

find the true ip from website which use CDN
## tools
- masscan


## how to use

### why use the yml config
scan the ip block, then compare with the target website


~~ ## python package need install ~~
安装python-nmap一直不行。我就不折腾了。我改ruby吧。
## ruby
#gem
``` yml
require 'yaml'
require 'faraday'
require 'nokogiri'
require 'digest'
```

``` bash
gem install faraday
gem install nokogiri
```

## install masscan
``` bash
sudo apt-get install masscan
brew install masscan
```

## project
- scan_tmp is for saving the masscan scan result data

## how to use
you need the root privilege to run the script

## how to get the ip block
you can registor the passivetotal you enter all the domain name of the company.

you will get the ip block

### update
考虑到有些网站并没有favicon，而且获取title来判断对应的网站，已经准确率很高了。
删除对应代码，增加一些说明




