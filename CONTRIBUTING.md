# 자산 작성 가이드

이 저장소는 프로젝트에 `.claude/`로 마운트되는 서브모듈이다. 저장소 루트가 곧 소비
프로젝트의 `.claude/` 내용이 된다.

> `CLAUDE.md`를 루트에 두지 않는다 — 마운트되면 `.claude/CLAUDE.md`가 되어 모든 소비
> 프로젝트의 컨텍스트에 로드된다. 작성 규칙은 이 파일에 둔다.

## 구조
- `skills/<이름>/SKILL.md` — 스킬. frontmatter(`name`, `description`) 필수. `name`은
  디렉터리명과 같게, `description`에는 언제 써야 하는지(트리거)를 적는다.
- `stacks/<stack>.md` — 언어·프레임워크별 코드 규칙. 소비 프로젝트 `CLAUDE.md`가 `@.claude/stacks/<stack>.md`로 import한다. 언어와 무관한 SDD 규칙은 `skills/sdd-feat/process.md`에 두고 여기에 다시 쓰지 않는다.
- `settings.json` — 루트에 권한(allow/deny)만 둔다. 지금은 개인용이라 둔 것이며, 소비 프로젝트 설정과 충돌하므로 훅은 넣지 않는다.
- `hooks/` — 공용 훅 스크립트. 루트 settings.json 대신 사용자 설정(`~/.claude/settings.json`)에 등록한다 (예: `auto-update.sh`).
- 스킬 전용 훅은 루트 `settings.json` 대신 스킬 frontmatter(`hooks:`)에 등록하고, 스크립트는 `skills/<이름>/hooks/`에 둔다
  (루트 settings.json은 소비 프로젝트 설정과 충돌하고 모든 작업에 적용됨). 직접 실행하는 도구는 `scripts/`.
- 스킬의 상세 설명(사용법 세부, 파일 구성, 훅 연결 고리)은 `skills/<이름>/README.md`에 둔다 (사람용, 스킬 본문에 넣지 않음).
  루트 `README.md`에는 한두 문장 소개 + 명령 + 링크만 둔다.

## 규칙
- 자산은 가능하면 특정 프로젝트/언어에 종속되지 않게 작성한다. 개인용(특정 블로그·OS 전용 등)이면 README에 명시한다.
- 스크립트는 스킬 디렉터리 안(`skills/<이름>/scripts/`)에 두고, 작업 대상 경로는 스크립트 위치가 아니라 현재 디렉터리 기준으로 잡는다.
- 스킬 본문은 호출될 때마다 컨텍스트에 로드되므로 간결하게 유지한다. 내용을 추가할 땐
  새 섹션을 늘리기보다 기존 문장에 끼워 넣거나 중복을 먼저 정리한다. 편집자용 메모는
  스킬 본문이 아니라 이 파일에 둔다.
- 자산을 추가·변경하면 `README.md`의 해당 섹션(사용법)을 함께 갱신한다.
- 문서와 스킬 본문은 한국어로 작성한다.
- SDD 스킬은 모두 `sdd-` 접두사를 쓴다. 자체 방식은 `sdd-feat`(기능 진행)·`sdd-init-<stack>`(새 프로젝트), 다른 방식은 `sdd-<방식>-*`(예: spec-kit → `sdd-speckit-*`)으로 구분한다. 스택 파일(`stacks/`)은 방식과 무관하게 함께 쓴다.
