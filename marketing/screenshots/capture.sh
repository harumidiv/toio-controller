#!/bin/sh
# アプリの画面をシミュレータで撮り、assets/ に保存する
# 使い方: ./capture.sh <ToioController.appのパス>
#   DEBUGビルドのアプリを渡す(-screenshotScreen はDEBUGビルドだけで使える起動引数)
# 撮影専用のシミュレータ「Screenshot iPhone 17 Pro Max」「Screenshot iPhone Duo」が無ければ作る
set -eu
cd "$(dirname "$0")"

APP="$1"
BUNDLE_ID=harumidiv.toio.controller
SETTING_ARGS="-screenshotScreen setting -appReview YES -up 90 -left 35 -right 50 -down 75"
CONTROL_ARGS="-screenshotScreen control -appReview YES"

simulator() {
  name=$1; type=$2; runtime=$3
  udid=$(xcrun simctl list devices | grep "$name (" | head -1 | sed -E 's/.*\(([0-9A-F-]+)\).*/\1/')
  if [ -z "$udid" ]; then
    udid=$(xcrun simctl create "$name" "$type" "$runtime")
  fi
  xcrun simctl boot "$udid" 2>/dev/null || true
  xcrun simctl spawn "$udid" defaults write -g AppleLanguages -array ja-JP
  xcrun simctl spawn "$udid" defaults write -g AppleLocale ja_JP
  xcrun simctl ui "$udid" appearance light
  xcrun simctl install "$udid" "$APP"
  echo "$udid"
}

# --terminate-running-process では前のプロセスが残って起動引数が効かないことがあるので、明示的に終了してから起動する
shoot() {
  udid=$1; out=$2; display=$3; shift 3
  xcrun simctl terminate "$udid" "$BUNDLE_ID" >/dev/null 2>&1 || true
  sleep 2
  xcrun simctl launch "$udid" "$BUNDLE_ID" "$@" >/dev/null
  sleep 10
  if [ -n "$display" ]; then
    xcrun simctl io "$udid" screenshot --display="$display" "$out" >/dev/null 2>&1
  else
    xcrun simctl io "$udid" screenshot "$out" >/dev/null 2>&1
  fi
  echo "$out"
}

IPHONE=$(simulator "Screenshot iPhone 17 Pro Max" com.apple.CoreSimulator.SimDeviceType.iPhone-17-Pro-Max com.apple.CoreSimulator.SimRuntime.iOS-27-0 | tail -1)
DUO=$(simulator "Screenshot iPhone Duo" com.apple.CoreSimulator.SimDeviceType.iPhone-Duo com.apple.CoreSimulator.SimRuntime.iOS-27-1 | tail -1)

# iPhone Duoのシミュレータは折りたたんだ状態で起動し、内側の画面は真っ黒になる。外側の画面(1398x2034)を指定して撮る
DUO_OUTER=$(xcrun simctl io "$DUO" enumerate 2>&1 | awk '/UUID:/{u=$2} /Default width: 1398/{print u; exit}')

shoot "$IPHONE" assets/iphone_control.png "" $CONTROL_ARGS
shoot "$IPHONE" assets/iphone_setting.png "" $SETTING_ARGS
shoot "$DUO" assets/duo_control.png "$DUO_OUTER" $CONTROL_ARGS
shoot "$DUO" assets/duo_setting.png "$DUO_OUTER" $SETTING_ARGS
echo "撮影した画面を開いて、目的の画面(コントローラ/設定)になっているか確かめてください"
