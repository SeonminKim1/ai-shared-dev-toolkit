#!/bin/zsh
# SessionStart 훅 — 소비 프로젝트의 .claude 서브모듈을 origin/main으로 자동 갱신 (6시간에 1회)
# 등록: ~/.claude/settings.json (README "자동 업데이트" 참고). 실패해도 세션 시작은 막지 않는다.
# 건너뜀: 서브모듈이 아님 / origin에 없는 로컬 커밋 / 수정 중인 파일과 겹침 (git이 checkout을 거부)
D="${CLAUDE_PROJECT_DIR:-$PWD}/.claude"
git -C "$D" rev-parse --show-superproject-working-tree 2>/dev/null | grep -q . || exit 0

STAMP="$(git -C "$D" rev-parse --absolute-git-dir)/auto-update-stamp"
[[ -n $(find "$STAMP" -mmin -360 2>/dev/null) ]] && exit 0

GIT_TERMINAL_PROMPT=0 git -C "$D" fetch -q origin main 2>/dev/null || exit 0
touch "$STAMP"

OLD=$(git -C "$D" rev-parse --short HEAD)
NEW=$(git -C "$D" rev-parse --short origin/main)
[[ "$OLD" == "$NEW" ]] && exit 0
git -C "$D" merge-base --is-ancestor HEAD origin/main || exit 0

if [[ $(git -C "$D" symbolic-ref -q --short HEAD) == main ]]; then
  git -C "$D" merge -q --ff-only origin/main
else
  git -C "$D" checkout -q --detach origin/main  # 다른 브랜치에 있어도 브랜치 자체는 그대로 남음
fi 2>/dev/null || exit 0
echo "ai-shared-dev-toolkit(.claude) 업데이트됨: $OLD → $NEW"
git -C "$D" log --oneline --no-merges "$OLD..$NEW" | head -5
