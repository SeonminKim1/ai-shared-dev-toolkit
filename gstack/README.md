# gstack 사용법

[gstack](https://github.com/garrytan/gstack): Claude Code용 스킬 묶음. 기획 리뷰부터 배포 확인까지.

<br>

## 설치
필요: Claude Code, Git, Bun 1.4.2+

```sh
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
cd ~/.claude/skills/gstack && ./setup
```

- 전역: `~/.claude/skills/gstack`
- 프로젝트: `<프로젝트>/.claude/skills/gstack`
- 프로젝트 설치면 `.gitignore`에 `.claude/skills/`, `.gstack/` 추가
- 업데이트: `/gstack-upgrade`

<br>

## 설정
`~/.gstack/config.yaml`
- `proactive`: 스킬 자동 실행 범위 (`core` / `all` / `off`). 지금 `all`
- `update_channel`: `stable`(릴리스만) / `main`(매 머지)
- `telemetry`: `off`

<br>

## 흐름
| 단계 | 스킬 |
|---|---|
| 아이디어 | `/office-hours` |
| 기획 리뷰 | `/plan-eng-review` (전부: `/autoplan`) |
| 구현 확인 | `/verify` |
| 화면 점검 | `/design-review` |
| QA | `/qa` (보고만: `/qa-only`) |
| PR | `/ship` |
| 배포 후 | `/canary` |

- 기타: `/review`, `/cso`(보안), `/benchmark`(성능), `/retro`(회고)

<br>

## 연관 프로젝트
**[pj-web-app-quiz2](https://github.com/SeonminKim1/pj-web-app-quiz2)**: 퀴즈 웹앱. 프로젝트 설치.
- `CLAUDE.md` Skill routing: 단계별 필수 스킬 지정
- `skill-nudge.sh`: 다음 스킬 알림 (브랜치 생성, UI 커밋, 머지 후)
- `log-skill.sh`: 스킬 사용 기록 → `.gstack/skill-log.jsonl`
- 산출물: `docs/designs/`(설계), `TODOS.md`(미룬 일)

**만든 과정** (gstack 기록 `timeline.jsonl` 기준)

1. 첫 버전 (11-18~19, `main`)
   - `/office-hours`: 아이디어 정리, 설계 문서
   - `/autoplan`: CEO → 디자인 → DX → 엔지니어링 리뷰
   - 구현 → `/design-review` → `/qa-only` → `/health` → 배포 → `/canary`
2. 기능 추가 (예: 모자)
   - `/plan-eng-review` → 구현 → `/verify` → `/design-review` → `/document-release` → `/ship` → 머지 → `/canary`
3. 작은 수정·화면 다듬기
   - 기획 리뷰 없이 `/verify` → `/design-review` → `/document-release` → `/ship`
4. 큰 기능 (예: 스티커첩)
   - `/design-shotgun`(화면 시안) → `/office-hours` → `/plan-eng-review` → `/plan-design-review` → 이후 2번과 같음
