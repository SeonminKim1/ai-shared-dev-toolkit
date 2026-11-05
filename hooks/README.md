# hooks

여러 스킬이 같이 쓰는 공용 훅. 루트 `settings.json` 대신 사용자 설정(`~/.claude/settings.json`)에 등록한다.

<br>

## auto-update.sh (Claude Code 전용)

Claude를 켤 때 6시간에 한 번 `origin/main`으로 갱신한다. 원격에 없는 로컬 커밋이 있거나 수정 중인 파일과 겹치면 건너뛴다.

`~/.claude/settings.json`에 한 번만 등록하면 된다. 서브모듈이 없는 프로젝트에서는 아무 동작도 하지 않는다.

```json
"hooks": {
  "SessionStart": [{ "hooks": [{ "type": "command",
    "command": "f=\"$CLAUDE_PROJECT_DIR/.claude/hooks/auto-update.sh\"; [ -x \"$f\" ] && \"$f\" || true",
    "timeout": 15 }] }]
}
```

단, 프로젝트마다 처음 한 번은 직접 업데이트해야 한다 (`auto-update.sh`를 받아야 동작하므로).
