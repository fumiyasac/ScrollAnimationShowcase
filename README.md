# ScrollAnimationShowcase

[ING] - UIScrollViewやUICollectionViewの特性を活用した表現サンプル

### 実装機能一覧

UICollectionViewとUIPageViewControllerの性質を利用した、メディアアプリでよく見る無限スクロールするタブの動きを実装したUIサンプルになります。

### 本サンプルの画面設計図

全体的なアーキテクチャや全体的な画面構成、そしてそれぞれの画面に対応するViewControllerや処理の橋渡しを行うための各種Protocolとの関連性などをまとめたものは下記の図解のような形となります。

__1. 画面キャプチャ:__

![capture.jpg](https://qiita-image-store.s3.amazonaws.com/0/17400/aa4c7d31-6d45-41db-bb1f-4d2a774a972f.jpeg)

__2. Storyboardの構成:__

![capture.jpg](https://qiita-image-store.s3.amazonaws.com/0/17400/aa4c7d31-6d45-41db-bb1f-4d2a774a972f.jpeg)

__3. 該当箇所の全体的なポイントをまとめた概略図:__

![whole_relationships.png](https://camo.qiitausercontent.com/0a5fa9a8a475d1f1bdf670beff579004c60433a1/68747470733a2f2f71696974612d696d6167652d73746f72652e73332e616d617a6f6e6177732e636f6d2f302f31373430302f62653239333833662d643935642d363564312d373937342d3539316632663766386639352e706e67)

### UICollectionViewやUIScrollViewを有効活用する

このサンプルでは、UICollectionViewやUIScrollViewの性質や各種Delegateの処理を活用してUI表現をしています。特に表現を実現する前段階において押さえておくと良さそうな部分についてまとめています。

__1. UICollectionViewFlowLayoutを継承したクラスを適用する:__

![uicollectionview_layout_atrributes.png](https://qiita-image-store.s3.amazonaws.com/0/17400/b62b8cf1-3bb4-e732-b909-8b51f2a13586.png)

__2. 無限スクロールを伴うタブ型UI実装する上で必要なセルのインデックス値の調整する:__

![uicollectionview_calculate_index.png](https://qiita-image-store.s3.amazonaws.com/0/17400/fe84d355-f840-b086-344a-736e633d3753.png)

### その他コードにおいてポイントとなる部分の実装

具体的な実装においてポイントになる部分については、下図に示した部分になります。

__1. インデックス値を調整するための実装:__

![point1.png](https://qiita-image-store.s3.amazonaws.com/0/17400/d7a36833-8bb1-3fc9-221f-bda57dffaf76.png)

__2. 配置したUICollectionViewのoffset値を調整するための実装:__

![point2.png](https://qiita-image-store.s3.amazonaws.com/0/17400/58b1edbd-27b4-bc0c-5f60-4c31a17dbedf.png)

__3. UICollectionViewCellのインデックス値の変更の前後状態を元にUIPageViewControllerの動き方を決定するための実装:__

![point3.png](https://qiita-image-store.s3.amazonaws.com/0/17400/a6000f9a-192b-bfef-90c9-2c8f8f62737c.png)

__4. 配置したUICollectionViewのスクロールが停止した際の表示位置を調整するための実装:__

![point4.png](https://qiita-image-store.s3.amazonaws.com/0/17400/c7beb155-f930-2aed-61da-3e45d33e9813.png)

### その他

このサンプル全体の詳細解説とポイントをまとめたものは下記に掲載しております。

(Qiita) https://qiita.com/fumiyasac@github/items/af4fed8ea4d0b94e6bc4
