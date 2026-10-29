# ai-shared-dev-toolkit
프로젝트 간 서브모듈로 공유 사용하는 AI 개발 자산(Hooks, Skills 등) 모음

## 사용법

저장소 루트가 그대로 `.claude/` 내용이 되도록 구성되어 있다.

```sh
git submodule add <이 저장소 URL> .claude

# 업데이트
git submodule update --remote .claude
```

clone 시에는 `git clone --recurse-submodules`, 이미 clone했다면 `git submodule update --init`.

### 지원 도구

- Claude Code: `.claude/skills`를 읽는다.
- Cursor: 호환 경로로 `.claude/skills`도 읽으므로 추가 작업 없이 스킬을 쓸 수 있다.

훅은 도구마다 설정 형식이 달라 현재 Claude Code 전용이다.

- 프로젝트 전용 스킬/설정은 `.claude/`에 두지 않는다 (서브모듈이 dirty 상태가 됨).
  프로젝트별 지침은 루트의 `CLAUDE.md`에 둔다.
- `settings.local.json`은 `.gitignore`로 제외되어 있다.

## 구조

```
skills/<스킬명>/SKILL.md   # → .claude/skills/...
hooks/                     # → .claude/hooks/...
```

자산 작성 규칙은 [CONTRIBUTING.md](CONTRIBUTING.md) 참고.

## Skills

### learning-examples
새 라이브러리를 익히기 위한 학습용 예제 모음(`ex1.*`, `ex2.*` ...)을 계획 → 단위별 작성 →
피드백 순으로 만들어 간다. 목차는 대상 프로젝트의 `README.md`에 유지된다.

- 사용: `/learning-examples <라이브러리>` 또는 "`<라이브러리>` 학습용 예제 만들어줘"

## Hooks

(아직 없음)
