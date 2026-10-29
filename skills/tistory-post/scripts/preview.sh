#!/bin/zsh
# posts/<slug>/post.html → posts/<slug>/preview.html 생성 후 브라우저로 열기
# 미리보기에서 '복사' 버튼을 누르면 본문이 서식째 클립보드에 들어감 → 티스토리 기본모드에 Cmd+V
set -e
ROOT="${TISTORY_ROOT:-$PWD}"  # posts/ 가 있는 작업 폴더 (기본: 현재 디렉터리)
SLUG="${1:?usage: preview.sh <slug> [--no-open]}"
FILE="$ROOT/posts/$SLUG/post.html"
[[ -f "$FILE" ]] || { echo "not found: $FILE" >&2; exit 1; }
OUT="$ROOT/posts/$SLUG/preview.html"
TITLE=$(grep -m1 -E '^1\. ' "$ROOT/posts/$SLUG/meta.md" 2>/dev/null | sed -E 's/^1\. //; s/ ←.*//' || true)
{
cat <<HEAD
<!doctype html>
<html lang="ko"><head><meta charset="utf-8">
<title>${TITLE:-$SLUG}</title>
<style>
body { margin: 0; background: #f4f4f4; font-family: -apple-system, "Apple SD Gothic Neo", sans-serif; color: #333; }
.bar { position: sticky; top: 0; display: flex; gap: 12px; align-items: center; padding: 12px 24px; background: #fff; border-bottom: 1px solid #ddd; }
.bar button { padding: 8px 20px; font-size: 15px; border: 0; border-radius: 6px; background: #43587F; color: #fff; cursor: pointer; }
.bar .msg { color: #2a7a2a; font-size: 14px; }
.bar .title { font-weight: 600; flex: 1; }
#post { max-width: 760px; margin: 24px auto; padding: 32px 40px; background: #fff; line-height: 1.7; font-size: 16px; }
#post pre { background: #f6f8fa; padding: 12px 16px; overflow-x: auto; font-size: 14px; }
#post code { font-family: Menlo, monospace; }
#post table td { padding: 6px 10px; border: 1px solid #ccc; }
#post blockquote { margin: 0; padding: 4px 16px; border-left: 4px solid #ccc; color: #555; }
</style></head><body>
<div class="bar"><span class="title">${TITLE:-$SLUG}</span><span class="msg" id="msg"></span><button id="copy">복사</button></div>
<article id="post">
HEAD
cat "$FILE"
cat <<'TAIL'
</article>
<script>
document.getElementById('copy').addEventListener('click', () => {
  const post = document.getElementById('post');
  const onCopy = (e) => {
    e.clipboardData.setData('text/html', post.innerHTML);
    e.clipboardData.setData('text/plain', post.innerText);
    e.preventDefault();
  };
  document.addEventListener('copy', onCopy);
  const ok = document.execCommand('copy');
  document.removeEventListener('copy', onCopy);
  document.getElementById('msg').textContent = ok ? '복사됨 - 티스토리 기본모드에 Cmd+V' : '복사 실패 - 본문을 직접 선택해 복사하세요';
});
</script>
</body></html>
TAIL
} > "$OUT"
[[ "$2" == "--no-open" ]] || open "$OUT"
echo "preview: $OUT"
