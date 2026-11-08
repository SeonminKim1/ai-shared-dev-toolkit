#!/bin/zsh
# SVG → PNG (2배 해상도). 흐름도·구조도를 티스토리에 올릴 이미지로 만든다. macOS 전용 (Chrome + sips)
# usage: render-image.sh posts/<slug>/flow.svg [out.png]   (out 기본: 같은 이름 .png)
# SVG 루트에 width/height 속성(px)이 있어야 한다. 스타일 기준은 reference/diagram.md
set -e
SVG="${1:?usage: render-image.sh <file.svg> [out.png]}"
OUT="${2:-${SVG%.svg}.png}"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
[[ -x "$CHROME" ]] || { echo "Google Chrome 없음: $CHROME" >&2; exit 1; }
W=$(grep -m1 -oE '<svg[^>]*' "$SVG" | grep -oE 'width="[0-9.]+' | head -1 | grep -oE '[0-9]+' | head -1)
H=$(grep -m1 -oE '<svg[^>]*' "$SVG" | grep -oE 'height="[0-9.]+' | head -1 | grep -oE '[0-9]+' | head -1)
[[ -n "$W" && -n "$H" ]] || { echo "svg 루트에 width/height 필요" >&2; exit 1; }
# 헤드리스 창은 아래쪽 일부가 렌더링되지 않으므로 위아래 여백(PAD/2)을 두고 그린 뒤 가운데를 잘라낸다
PAD=200
TMP=$(mktemp -d)
{ print '<!doctype html><meta charset="utf-8"><style>html,body{margin:0;background:#fff}svg{display:block;margin-top:'$((PAD/2))'px}</style>'; cat "$SVG"; } > "$TMP/page.html"
"$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=2 \
  --window-size=$W,$((H+PAD)) --screenshot="$OUT" "file://$TMP/page.html" >/dev/null 2>&1
sips --cropToHeightWidth $((H*2)) $((W*2)) "$OUT" >/dev/null
rm -rf "$TMP"
echo "image: $OUT (${W}x${H} @2x)"
