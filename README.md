<img src= "https://user-images.githubusercontent.com/42649032/60424866-37ca2700-9c2c-11e9-9e76-4dab16a10d4b.png" width="36" height="36"> toio controller
======================================

## Requirements

![OS](https://img.shields.io/badge/target-iOS%2013.0-orange.svg) [![Editor](https://img.shields.io/badge/editor-Xcode%2026.0+-orange.svg)](https://developer.apple.com/jp/xcode/) [![Language](https://img.shields.io/badge/language-Swift%205.0+-green.svg)](https://swift.org)

## Description

This app is a controller app of toio core cube sold by Sony Interactive Entertainment.<br>
You need to buy toio to use the app.

## Dependencies

ライブラリはSwift Package Manager（SPM）で管理しています。

| ライブラリ | バージョン |
|---|---|
| lottie-ios | 4.6.1 |
| Swinject | 2.10.0 |
| RxSwift | 5.1.3 |
| RxBluetoothKit | 6.0.0 |
| R.swift | 7.8.0 |
| SwiftLint | 0.65.0 |

## Installation

リポジトリをクローン後、`ToioController.xcodeproj` をXcodeで開くだけで使えます。

```
git clone <repository-url>
open ToioController.xcodeproj
```

Xcodeがパッケージを自動的に解決します。初回はパッケージのダウンロードに数分かかることがあります。

### オプションツール（コード品質）

SwiftLint・SwiftFormat・LicensePlistはHomebrewでインストールできます。

```
brew install swiftlint swiftformat
```

未インストールの場合でもビルド・実行に影響はありません（ビルド時にwarningが表示されます）。

## snapshot

```
bundle exec fastlane screenshots
```

## License
toio controller is licensed under the MIT license.<br>
Copylight ©2019 Harumi Sagawa<br>

The license of toio is referred from the following link<br>
[https://toio.io/news/2019/20190320-1.html](https://toio.io/news/2019/20190320-1.html)
