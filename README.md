# ScrollAnimationShowcase

[ING] - UIScrollViewやUICollectionViewの特性を活用した表現サンプル

### 実装機能一覧

UICollectionViewとUIPageViewControllerの性質を利用した、メディアアプリでよく見る無限スクロールするタブの動きを実装したUIサンプルになります。

### 本サンプルの画面設計図

__1. 画面キャプチャ:__

![capture.jpg](https://qiita-image-store.s3.amazonaws.com/0/17400/aa4c7d31-6d45-41db-bb1f-4d2a774a972f.jpeg)

__2. UICollectionViewFlowLayoutを継承したクラスを適用する:__

![uicollectionview_layout_atrributes.png](https://qiita-image-store.s3.amazonaws.com/0/17400/b62b8cf1-3bb4-e732-b909-8b51f2a13586.png)

__3. 無限スクロールを伴うタブ型UI実装する上で必要なセルのインデックス値の調整:__

![uicollectionview_calculate_index.png](https://qiita-image-store.s3.amazonaws.com/0/17400/fe84d355-f840-b086-344a-736e633d3753.png)
