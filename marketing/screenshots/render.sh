#!/bin/sh
# App Store用スクリーンショットを書き出す。output/ に透過なしのPNGを6枚作る
# 必要なもの: Microsoft Edge、Pillow(python3 -m pip install pillow)
set -eu
cd "$(dirname "$0")"

EDGE="/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
PYTHON="${PYTHON:-python3}"
mkdir -p output

for device in iphone duo; do
  # 横幅(CSSピクセル)が500未満だとレイアウトが崩れるため、倍率は 幅 / 倍率 >= 500 になるようにする
  if [ "$device" = iphone ]; then W=2622; H=1206; SCALE=2; else W=2853; H=2007; SCALE=3; fi
  for shot in 1 2 3; do
    out="output/${device}_${shot}_${W}x${H}.png"
    "$EDGE" --headless=new --disable-gpu --hide-scrollbars --allow-file-access-from-files \
      --force-device-scale-factor=$SCALE --window-size=$((W / SCALE)),$((H / SCALE)) \
      --virtual-time-budget=10000 --screenshot="$PWD/$out" \
      "file://$PWD/screenshot.html?device=$device&shot=$shot&scale=$SCALE" >/dev/null 2>&1
    # App Store Connectは透過のあるPNGを受け付けないので、RGBにする
    "$PYTHON" -c "import sys; from PIL import Image; Image.open(sys.argv[1]).convert('RGB').save(sys.argv[1])" "$out"
    echo "$out"
  done
done
