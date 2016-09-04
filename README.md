# GankIO
A demonstration app with FRP and MVVM using http://gank.io/api.

## 9.4

用 FMDB(sqlite) 做了存储，后面的计划是改进一下 UI，继续实践 ReactiveCocoa，另外开始准备学习并迁移到 RxSwift 和 RAC 4。

## 8.13

基本完成了干货列表的一些基本功能：历史干货、随机干货、上一篇干货、下一篇干货。

本来是想实现上拉拖动 tableView 到下一个 tableView 的，但是发现要高效的实现起来是比较困难的，希望下次更新能够带来这个功能。

## 8.9

噢，这次终于基本弄懂了 RACCommand。但是在实践的过程中，准确的说是实践 RAC 的过程中还是发现一些问题：

- 如何用 FRP 的思想来写代码，而不是之前的声明式的编程方式，一段代码写出来肯定可以优化的。
- 对 RAC 的一些函数式操作还不太熟悉，学会用一个，记得记下来用法。
- 虽然现在在看的还是 OC 版的 RAC，但是我相信只要学会了这种思想，想后面的 4 以上版本以及 RxSwift 应该会很快入门。

继续努力。

## 7.31

用 MVVM 一开始就遇到了 tableview 的问题，看了 @雷纯锋 的代码，发现他用的 RACCommand 做请求，还没搞懂这一块，只是尝试写了一个 viewModle，顺便研究了一下 [RACMulticastConnection](http://www.jianshu.com/p/ad91314ccf66)。

## 7.24

过了将近一个周才更新！只是初步做了首页，用到了一点 RAC，暂时没用 MVVM，好吧，实践起来还是比较慢的。继续研究！

## 7.19

这两天先研究了阅读了 AFNetworking 的源码，然后看了 RAC 并写了一篇[总结](http://www.jianshu.com/p/678ca949f902)。
## 7.17 
准备通过这个小 app 练习一下 FRP 和 MVVM。但是到底用 OC 还是 Swift 还有点纠结，毕竟目前只看了 ReactiveCocoa 2.5 的版本，那就先通过它来做第一个版本吧。
