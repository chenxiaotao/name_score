# name-score

最近小孩要出生了，名字还没想好，突发奇想，想着有没有那种名字算命的网站，在github上搜了一下，发现一个Python的抓取程序 Chinese-name-score 作为一个ruby程序员，利用周末空闲时间自己也写一个ruby版本的出来，虽然这有点不靠谱，可是能给自己提供一些取名的参考还是不错

主要抓取为[http://life.httpcn.com/xingming.asp](http://life.httpcn.com/xingming.asp) 这个姓名测试中的两种分数

### 运行方式

1、bundle install

2、ruby auto_run.rb

然后根据提示一步一步往下走就OK了

### 注意
本脚本使用了当前最新版的ruby2.4.1安装，mechanize依赖的nokogiri安装时可能会装不上，请自行Google 或者看看 [http://www.nokogiri.org/tutorials/installing_nokogiri.html#mac_os_x](http://www.nokogiri.org/tutorials/installing_nokogiri.html#mac_os_x)


### 其他
该脚本提供了两种字库，所谓女诗经，男楚辞，本程序就提供了这两种字库，如果有其他的想使用的字库，请将其复制到work_libary文件下

另外附上 [原来的Python版本](https://github.com/peiss/chinese-name-score)

### 此脚本纯属娱乐，切勿深信，命运都掌握在自己手里
