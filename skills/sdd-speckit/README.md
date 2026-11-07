# sdd-speckit

사람이 읽는 메모. Claude는 단계별 `SKILL.md`와 이 폴더의 `process.md`·`constitution.md`·`templates/`를 읽는다.

## 개요

[GitHub spec-kit](https://github.com/github/spec-kit)(v1.3.0 기준)의 단계·산출물·품질 장치를 따르는 SDD 스킬 묶음. `specify` CLI·`.specify/` 스크립트·extension 훅 없이 툴킷 안에서 동작하고, 본문은 한국어로 다시 썼다. 기능별 문서는 `specs/NNN-<접두사>-<이름>/`에, 브랜치도 같은 이름으로 생긴다(접두사: `api-`, `ui-`, `component-`, `domain-`).

이 폴더에는 `SKILL.md`가 없다. 단계별 스킬(`skills/sdd-speckit-<단계>/`)이 함께 쓰는 규칙·템플릿만 둔다.

| 단계 | 명령 | 산출물 |
|---|---|---|
| 1. specify | `/sdd-speckit-specify <기능 설명>` | `spec.md`, `checklists/requirements.md`, 브랜치 `NNN-<이름>` |
| 2. clarify | `/sdd-speckit-clarify` | `spec.md`의 `## 명확화` (질문 최대 5개, 모호한 점이 없으면 건너뜀) |
| 3. plan | `/sdd-speckit-plan` | `plan.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md` |
| 4. tasks | `/sdd-speckit-tasks` | `tasks.md` |
| 5. analyze | `/sdd-speckit-analyze` | 보고서 (읽기 전용, implement 전에 권장) |
| 6. implement | `/sdd-speckit-implement` | 코드, `implement.md`, 작업별 커밋 |
| 7. converge | `/sdd-speckit-converge` | `tasks.md`에 남은 작업 추가 (수렴할 때까지 6↔7) |

```sh
/sdd-speckit-specify 유저가 주문을 생성한다. 1인당 하루 10건 제한.   # 새 기능 → specs/004-api-order-create/
/sdd-speckit-clarify
/sdd-speckit-plan
/sdd-speckit-tasks
/sdd-speckit-analyze
/sdd-speckit-implement
/sdd-speckit-converge
/sdd-speckit-specify 004 쿠폰 필드 추가                               # 기존 기능 수정
/sdd-speckit-implement 004 주문 목록 정렬 버그 수정                   # 버그·문구 수정은 바로 implement
```

**새 프로젝트** : `/sdd-init-fastapi`에서 SDD 방식으로 `sdd-speckit`을 고르면 CLAUDE.md·README가 이 방식 기준으로 만들어진다.<br>
**대상 기능** : specify 외 단계는 인자(`004`) → 현재 브랜치(`004-...`) 순으로 찾고, 둘 다 없으면 `specs/` 목록을 보여주고 묻는다.<br>
**끝까지** : 인자 끝에 "끝까지"를 붙이면 단계 사이 확인만 생략하고 다음 단계를 이어 호출한다. 질문과 implement의 작업별 확인은 그대로 한다.<br>
**작은 변경** : 버그·문구 수정은 바로 implement(`tasks.md`에 변경 phase 추가). 기존 기능의 동작 변경은 specify로 spec을 고친 뒤 plan부터. 새 API·컴포넌트는 specify부터.<br>
**이슈 트래커** : `CLAUDE.md`에 GitHub Project가 설정돼 있을 때만 작업별 이슈·PR을 연동한다(`sdd-feat/tracker-github.md` 재사용). 기능 하나만 빼려면 tasks 단계에서 그렇게 답하면 된다.

<br>

## upstream과 다른 점

| 따르는 것 (뼈대) | 바꾼 것 (알맹이) |
|---|---|
| 단계 순서, 산출물 구성, spec·plan·tasks 목차 | 한국어 명사형·단문, 제목에 영어 원문 병기 |
| `FR-###`·`SC-###`·`US1`·`T001 [P] [US1]` 표기, Phase 구성 | 테스트 필수(upstream은 선택), 작업 하나 = 커밋 하나 크기 |
| `[NEEDS CLARIFICATION]` 최대 3개, spec 품질 체크리스트 | 기존 PRD를 spec의 `## 개요`로 흡수(배경, 완료 기준, 범위 제외) |
| clarify 분류표·질문 5개·답마다 반영 | 질문은 AskUserQuestion + 추천안, Grill 규칙(비용 큰 순서, 한도 초과는 `## 확인 필요`) |
| Constitution Check, analyze 심각도, converge 추가 전용 규칙 | constitution = 툴킷 공통 원칙 + 스택 파일 + `CLAUDE.md` 요구사항 |
| `NNN` 순번 디렉터리·브랜치 | 에러 표·레이어별 변경 파일·확인 명령은 스택 연결 값으로 |
| | implement는 작업마다 멈추고 확인 → 커밋, GitHub Project 연동(`sdd-feat/tracker-github.md` 재사용) |
| | 없앤 것: `specify` CLI, `.specify/`(scripts, feature.json, extensions.yml 훅), preset, `checklist` 명령 |

contracts는 기능 접두사로 고른다: `api-` → `contract-api.md`(엔드포인트별, 에러 표 포함), `ui-` → `contract-ui.md`(화면별), `component-` → `contract-component.md`, `domain-` → 없음(data-model이 계약).

<br>

## 파일 구성

| 파일 | 내용 |
|---|---|
| `skills/sdd-speckit/process.md` | 공통 규칙: 단계, 기능 디렉터리·브랜치, constitution 범위, 문서 관리, 질문, 커밋, 이슈 연동 |
| `skills/sdd-speckit/constitution.md` | 공통 원칙 I~VI |
| `skills/sdd-speckit/templates/` | spec, checklist, plan, research, data-model, contract-api·ui·component, quickstart, tasks, implement |
| `skills/sdd-speckit-<단계>/SKILL.md` | 단계별 절차와 Grill 체크리스트 |
| `skills/sdd-speckit/LICENSE-spec-kit` | upstream MIT 라이선스와 기준 버전 |
| `stacks/<stack>.md` | 스택 규칙 (`sdd-feat`와 같이 씀). 다른 언어 추가는 [../sdd-feat/README.md](../sdd-feat/README.md#다른-언어-추가) 참고 |

<br>

## sdd-feat와의 관계

두 방식은 독립이다. 한 프로젝트에서는 하나만 쓴다(문서 위치로 구분: `docs/<feature>/` → `sdd-feat`, `specs/NNN-*/` → `sdd-speckit`). `sdd-feat` 문서를 옮길 때의 대응:

| sdd-feat | sdd-speckit |
|---|---|
| `prd.md` | `spec.md`의 `## 개요` |
| `spec.md` (api·component) | `spec.md`의 시나리오·요구사항·엣지 케이스 + `contracts/` |
| `spec.md` (domain) | `spec.md` + `data-model.md` |
| `plan.md` | `plan.md` (+ 결정 근거는 `research.md`) |
| `task.md` (`T1`) | `tasks.md` (`T001`, phase) |
| `implement.md` | `implement.md` |

<br>

## upstream 갱신

`LICENSE-spec-kit`에 적힌 버전 이후 upstream `templates/`·`templates/commands/`의 변경을 보고 필요한 것만 손으로 옮긴다. 옮기면 그 버전으로 갱신한다.
