#!/bin/zsh
# posts/<slug>/post.html 을 서식 있는 HTML로 클립보드에 복사 → 티스토리 기본모드에 Cmd+V
set -e
# --html : 서식 대신 HTML 소스를 텍스트로 복사 (티스토리 HTML 모드에 붙여넣기용, h2 인라인 스타일 유지)
MODE=rich; [[ "$1" == "--html" ]] && { MODE=html; shift; }
ROOT="${TISTORY_ROOT:-$PWD}"  # posts/ 가 있는 작업 폴더 (기본: 현재 디렉터리)
FILE="${1:?usage: copy.sh [--html] <slug | path/to/post.html>}"
[[ -f "$FILE" ]] || FILE="$ROOT/posts/$1/post.html"
[[ -f "$FILE" ]] || { echo "not found: $FILE" >&2; exit 1; }
if [[ $MODE == html ]]; then
  pbcopy < "$FILE"; echo "copied (html source): $FILE"; exit 0
fi
# 브라우저가 읽는 public.html + 텍스트(public.utf8-plain-text)를 함께 넣는다
osascript -l JavaScript - "$FILE" <<'JS'
ObjC.import('AppKit');
function run(argv) {
  const html = $.NSString.stringWithContentsOfFileEncodingError(argv[0], $.NSUTF8StringEncoding, null);
  const full = $('<meta charset="utf-8">').stringByAppendingString(html);
  const attr = $.NSAttributedString.alloc.initWithHTMLDocumentAttributes(
    full.dataUsingEncoding($.NSUTF8StringEncoding), null);
  const pb = $.NSPasteboard.generalPasteboard;
  pb.clearContents;
  pb.setStringForType(full, 'public.html');
  pb.setStringForType(attr.isNil() ? html : attr.string, 'public.utf8-plain-text');
}
JS
echo "copied: $FILE"
