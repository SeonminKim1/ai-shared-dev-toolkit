#!/bin/zsh
# PostToolUse(Write|Edit) 훅 — SKILL.md frontmatter에서 등록, if 필터로 post.html 수정 때만 실행됨
# posts/<slug>/post.html 이 바뀌면: 서식 규칙 검사 → 위반 시 exit 2 (stderr가 Claude에게 전달되어 고치게 함)
#                                   통과 시 preview.html 재생성 (처음 생성이면 브라우저로 열기)
FILE=$(jq -r '.tool_input.file_path // empty')
[[ "$FILE" == */posts/*/post.html ]] || exit 0
[[ -f "$FILE" ]] || exit 0

ERRORS=$(perl -CSD -0777 -ne '
  use utf8; my @e; my $n = 0;
  # 이모지 (→ 같은 화살표는 허용)
  while (/([\x{1F000}-\x{1FAFF}\x{2600}-\x{27BF}\x{2B50}\x{2B55}])/g) { push @e, "이모지 금지: $1"; last if ++$n >= 5 }
  # 중첩 리스트
  pos = undef; my $d = 0;
  while (/<(\/?)(ul|ol)\b/g) { if ($1) { $d-- } elsif (++$d > 1) { push @e, "중첩 리스트 금지 (ul/ol 안에 ul/ol)"; last } }
  push @e, "중첩 리스트 금지 (li 안 <br />- 줄, 예시 한 줄만 허용)" if /<li\b(?:(?!<\/li>).)*<br\s*\/?>\s*-\s(?!예)/s;
  # 인라인 스타일은 스니펫의 h2/ul/ol/table만
  if (/<((?!h2\b|ul\b|ol\b|table\b)\w+)[^>]*\sstyle=/) { push @e, "인라인 스타일 금지: <$1 style=...>" }
  print join("\n", @e);
' "$FILE")

if [[ -n "$ERRORS" ]]; then
  print -u2 "tistory-post 서식 규칙 위반 ($FILE):\n$ERRORS\n규칙(SKILL.md 작성 원칙)에 맞게 post.html을 고칠 것."
  exit 2
fi

SLUG=${${FILE%/post.html}:t}
ROOT=${FILE%/posts/*}
OPEN=--no-open; [[ -f "$ROOT/posts/$SLUG/preview.html" ]] || OPEN=
TISTORY_ROOT="$ROOT" "${0:A:h}/../scripts/preview.sh" "$SLUG" $OPEN >/dev/null
