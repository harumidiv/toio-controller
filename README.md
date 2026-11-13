<img src= "https://user-images.githubusercontent.com/42649032/60424866-37ca2700-9c2c-11e9-9e76-4dab16a10d4b.png" width="36" height="36"> toio controller
======================================

## Requirements

![OS](https://img.shields.io/badge/target-iOS%2026.0+-orange.svg) [![Editor](https://img.shields.io/badge/editor-Xcode%2027.2-orange.svg)](https://developer.apple.com/jp/xcode/) [![Language](https://img.shields.io/badge/language-Swift%205-green.svg)](https://swift.org)

- iOS 26.0 以降（iPhone・横向き）
- Xcode 27.2 で動作確認しています

## Description

This app is a controller app of toio core cube sold by Sony Interactive Entertainment.<br>
You need to buy toio to use the app.

主な機能

- 十字キーでcubeを操作（前進・後退・左右）
- アクションボタン（バック・ホーン・スピン・ジグザグ）
- 方向ごとのスピード設定
- DUALSHOCK 4などのゲームコントローラでの操作

## Architecture

- 画面はSwiftUIで作成し、各画面の`UIViewController`がホストとしてPresenterとの連携や画面遷移を担当しています
- 左端のサイドレール（`Presentation/Common/SideRail.swift`）を全画面で共通して使っています
- cubeとの通信はCoreBluetoothで直接実装しています（`Domain/Bluetooth`）
- 依存の生成は`DI/Dependencies.swift`にまとめています。`Develop`・`Mock`ビルドではcube無しで画面を確認するためのMockに差し替わります

## Dependencies

ライブラリはSwift Package Manager（SPM）で管理しています。

| ライブラリ | バージョン | 用途 |
|---|---|---|
| [lottie-ios](https://github.com/airbnb/lottie-ios) | 4.6.1 | 接続画面の検索中アニメーション |
| [R.swift](https://github.com/mac-cain13/R.swift) | 7.8.0 | 文字列・画像リソースの型安全なアクセス |
| [SwiftLint](https://github.com/realm/SwiftLint) | 0.65.1 | 静的解析 |

## Installation

リポジトリをクローン後、`ToioController.xcodeproj` をXcodeで開くだけで使えます。

```
git clone <repository-url>
open ToioController.xcodeproj
```

Xcodeがパッケージを自動的に解決します。初回はパッケージのダウンロードに数分かかることがあります。

### 開発ツール（任意）

ビルド時に次のツールが実行されます。未インストールの場合でもビルド・実行に影響はありません（ビルド時にwarningが表示されます）。

| ツール | バージョン | 内容 |
|---|---|---|
| [SwiftLint](https://github.com/realm/SwiftLint) | 0.65.1 | コードの静的解析 |
| [SwiftFormat](https://github.com/nicklockwood/SwiftFormat) | 0.64.6 | コードの自動整形 |
| [LicensePlist](https://github.com/mono0926/LicensePlist) | 3.28.3 | 設定アプリに表示するライセンス一覧の生成（Debugビルドのみ） |

[Mint](https://github.com/yonaskolb/Mint)を使うと、`Mintfile`に書いたバージョンでまとめてインストールできます。

```
mint bootstrap
```

Homebrewでもインストールできます（この場合は最新版が入ります）。

```
brew install swiftlint swiftformat licenseplist
```

`R.generated.swift` はビルド時にR.swiftが自動で生成・更新します。

## License
toio controller is licensed under the MIT license.<br>
Copyright ©2019 Harumi Sagawa<br>

The license of toio is referred from the following link<br>
[https://toio.io/news/2019/20190320-1.html](https://toio.io/news/2019/20190320-1.html)
