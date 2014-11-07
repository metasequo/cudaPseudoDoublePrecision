cudaPseudoDoublePrecision
=========================

[CUDAで擬似倍精度を実装してみた。｜日曜開発者のブログ](http://ameblo.jp/sunday-developer/entry-11542540705.html "CUDAで擬似倍精度を実装してみた。")  
こちら記事で紹介してあるソースコードをVisual Studioで実行しました。  
詳しいことはそちらの記事を参考にしてください。  
  
ここから引用  
---
そこで、今後のGeForceで倍精度演算が伸びず、単精度演算性能のみが向上した場合に備えて、擬似倍精度を用いた加算、乗算のコードを書いてみた。擬似倍精度とは、単精度浮動小数点数型を2つ用いて倍精度を表現する方法である。普通の倍精度は52ビットの仮数部を持つのに対し、単精度浮動小数点数型は仮数部が23ビットなので、擬似倍精度は46ビットの精度をもつ。よって擬似倍精度は通常の倍精度に比べて若干精度が落ちる。  
  
以下にサンプルコードを示す。  
作成にあたっては、  
[反復法ライブラリ向け4倍精度演算の実装とSSE2を用いた高速化](http://www.slis.tsukuba.ac.jp/~hasegawa.hidehiko.ga/GYOSEKI/IPSJ-TACS0101009A.pdf)  
http://www.slis.tsukuba.ac.jp/~hasegawa.hidehiko.ga/GYOSEKI/IPSJ-TACS0101009A.pdf  
と  
[Implementation of float-float operators on graphics hardware](http://hal.archives-ouvertes.fr/docs/00/06/33/56/PDF/float-float.pdf)  
http://hal.archives-ouvertes.fr/docs/00/06/33/56/PDF/float-float.pdf  
を参考にした。  
---
引用おわり