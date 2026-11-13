# App Store用スクリーンショット

`output/` が App Store Connect にアップロードする画像です（透過なしのPNG）。

| 枠 | ファイル |
|---|---|
| iPhone 6.3インチ（横向き 2622×1206） | `output/iphone_1〜3_2622x1206.png` |
| iPhone Duo（横向き 2853×2007） | `output/duo_1〜3_2853x2007.png` |

| 番号 | 見出し | 端末に映す画面 |
|---|---|---|
| 1 | toioをスマホでらくらく操作♪ | コントローラ画面 |
| 2 | Dualshock4対応!! | コントローラ画面 |
| 3 | スピード調整対応！コントローラ不要！ | 設定画面 |

## 作り直し方

1. DEBUGビルドを作る

   ```
   xcodebuild -project ToioController.xcodeproj -scheme ToioController -configuration Debug \
     -destination 'generic/platform=iOS Simulator' -derivedDataPath /tmp/toio-dd build
   ```

2. アプリの画面を撮る（`assets/iphone_*.png`、`assets/duo_*.png` を上書き）

   ```
   ./capture.sh /tmp/toio-dd/Build/Products/Debug-iphonesimulator/ToioController.app
   ```

   - 撮影専用のシミュレータ（`Screenshot iPhone 17 Pro Max`、`Screenshot iPhone Duo`）を使います。普段使いのシミュレータは使いません
   - DEBUGビルドの起動引数 `-screenshotScreen control` / `setting` で、cubeに接続しなくても各画面を開けます
   - 撮影が不安定なことがあるので、撮った画像が目的の画面になっているか確かめてください

3. 画像を書き出す（`output/` に6枚）

   ```
   ./render.sh
   ```

   - Microsoft Edge と Pillow（`python3 -m pip install pillow`）が必要です
   - 構図・見出しは `screenshot.html` の `layouts` に、端末ごと・画面ごとに書いてあります

`assets/cube.png`・`dualshock.png`・`track.png` は以前のスクリーンショットから切り出したイラストです。
