# SDD 프로세스 (spec-kit 기반)

**specify ➔ clarify ➔ plan ➔ tasks ➔ analyze ➔ implement ➔ converge**

[spec-kit](https://github.com/github/spec-kit)의 단계·산출물·품질 장치를 따르고, 본문 규칙(언어, 질문, 커밋, 확인, 이슈 연동)은 이 툴킷의 방식으로 바꾼 SDD 방법론이다. 언어·프레임워크와 무관하며, 스택별 값은 스택 파일의 "스택 연결 값"에서 가져온다. 각 단계 스킬(`/sdd-speckit-<단계>`)은 이 파일을 기준으로 진행한다.

## 파일 구성
경로는 소비 프로젝트 루트 기준이다.

| 파일 | 구분 | 담는 내용 |
|---|---|---|
| `.claude/skills/sdd-speckit/process.md` | 공통 | 이 파일: 단계, 문서 위치, 질문·커밋·확인 규칙 |
| `.claude/skills/sdd-speckit/constitution.md` | 공통 | 모든 단계가 지키는 원칙(Constitution) |
| `.claude/skills/sdd-speckit/templates/` | 공통 | 산출물 템플릿 |
| `.claude/skills/sdd-speckit-<단계>/SKILL.md` | 공통 | 단계별 실행 절차와 Grill 체크리스트 |
| `.claude/stacks/<stack>.md` | 스택 | 코드 규칙과 "스택 연결 값"(레이어, 에러 표현, TASK 기본 순서, 확인 명령 등) |
| `CLAUDE.md` | 프로젝트 | 개요, 고유 모듈, 서비스 요구사항. 스택 파일을 `@import` |
| `specs/NNN-<이름>/` | 기능 | 기능 하나의 spec~구현 기록 |

같은 내용을 두 군데에 쓰지 않는다. 언어와 무관하면 이 파일, 같은 스택의 다른 프로젝트에도 맞으면 스택 파일, 이 프로젝트에서만 맞으면 `CLAUDE.md`.

## 단계와 산출물
| 단계 | 스킬 | 답하는 질문 | 산출물 (`specs/NNN-<이름>/`) |
|---|---|---|---|
| 0. 방향성 | (논의) | 서비스는 무엇을 하나? | `CLAUDE.md` 서비스 요구사항 |
| 1. specify | `/sdd-speckit-specify` | 왜, 무엇을, 어떻게 동작하나? | `spec.md`, `checklists/requirements.md` |
| 2. clarify | `/sdd-speckit-clarify` | spec의 빈틈은? | `spec.md`의 `## 명확화` |
| 3. plan | `/sdd-speckit-plan` | 코드 어디를 어떻게 바꾸나? | `plan.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md` |
| 4. tasks | `/sdd-speckit-tasks` | 어떤 순서로 하나? | `tasks.md` |
| 5. analyze | `/sdd-speckit-analyze` | 문서끼리 맞나? | 보고서(파일 쓰지 않음) |
| 6. implement | `/sdd-speckit-implement` | 제대로 동작하나? | 코드, `implement.md` |
| 7. converge | `/sdd-speckit-converge` | 코드가 문서를 다 채웠나? | `tasks.md`에 Convergence phase 추가(남은 일이 있을 때만) |

- clarify는 모호한 점이 없으면 건너뛸 수 있다(이유를 알린다). analyze는 implement 전에 권한다.
- implement와 converge는 converge가 `✅ 수렴`을 보고할 때까지 반복한다.
- 각 단계는 문서를 보여주고 확인받은 뒤 끝나며, 다음 단계 명령을 안내한다. 인자 끝에 "끝까지"가 있으면 **단계 사이 확인만** 생략하고 다음 단계 스킬을 이어 호출한다(질문, tasks 검증, implement의 작업별 확인은 생략하지 않는다).
- **spec 없이 구현하지 않는다.** 결과가 마음에 들지 않으면 산출물을 직접 고치지 말고 spec부터 고친다(아래 "되돌아가기").

## 기능 디렉터리
- 이름: `specs/NNN-<접두사>-<이름>/`. `NNN`은 `specs/`에 있는 가장 큰 번호 + 1(3자리, 처음은 `001`). 접두사는 HTTP API `api-`, 백그라운드 컴포넌트 `component-`, 도메인 모델만 정의 `domain-`. 한 기능이 둘에 걸치면 나누자고 제안한다.
- 브랜치: 디렉터리 이름과 같은 `NNN-<접두사>-<이름>`. specify가 최신 `main`에서 만든다.
- 대상 기능 찾기(specify 외 단계): 인자의 첫 단어가 `NNN` 또는 디렉터리 이름이면 그 기능 → 아니면 현재 브랜치 이름과 같은 디렉터리 → 둘 다 아니면 `specs/` 목록을 보여주고 묻는다.

## Constitution
`constitution.md`(공통 원칙), 스택 파일, `CLAUDE.md`의 서비스 요구사항을 합쳐 이 기능의 constitution으로 본다. 충돌하면 `CLAUDE.md` > 스택 파일 > `constitution.md` 순서로 따른다. plan의 Constitution Check와 analyze·converge의 판정 기준이다.

## 문서 관리
| 문서 | 수정 방식 |
|---|---|
| `spec.md`, `plan.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md` | 항상 현재 상태로 **덮어쓰기** (이력은 git) |
| `tasks.md` | 새 작업은 phase를 아래에 **추가**(번호 이어서). 기존 작업은 아래 "작업 변경 규칙"대로 |
| `implement.md` | `## 진행 기록`·`## 변경` 섹션에 **추가** |

**작업 변경 규칙** (`tasks.md`)
- **완료된 작업**: 고치지 않는다. 바꿀 일이 생기면 새 작업으로 추가한다.
- **진행 중인 작업**: 고치지 않는다. 단, spec에 없는 상황으로 중단(⏸)했다면 시작 전 작업으로 본다.
- **시작 전 작업**: 구현 상황에 따라 선행 관계와 실행 순서를 조정할 수 있다. 조정하면 `implement.md` 진행 기록에 이유를 남긴다.

- 문서는 한국어 명사형·단문으로 쓴다. 번역투 금지. 템플릿 제목 옆 영어 원문(`(User Scenarios)`)은 upstream과 대조용이므로 남긴다.
- 템플릿의 `<!-- -->` 안내 주석과 쓰지 않는 예시 항목은 지운다.
- 예시·용어는 upstream 예시 대신 프로젝트 것을 쓴다: 에러는 스택 연결 값의 **에러 표현**, 파일은 **레이어** 디렉터리, 명령은 **확인 명령**.

## 질문 규칙 (Grill)
각 단계 스킬의 **Grill 체크리스트**로 문서를 쓰기 전에 허점을 점검한다.
1. **점검과 질문을 나눈다.** 코드·문서·`CLAUDE.md`로 답이 나오면 묻지 않고 정하고 근거를 적는다. 질문은 Claude가 정할 수 없는 것(비즈니스 판단, 트레이드오프)에만 쓴다.
2. **틀렸을 때 비용이 큰 순서로 묻는다.** 데이터 구조·공개 API 형태 → 보안·권한·데이터 손실 → 비즈니스 규칙 해석 → 나머지.
3. **AskUserQuestion으로 묻고, 추천안을 첫 번째 선택지에 `(Recommended)`로 둔다.**
4. **한도를 넘은 질문은 버리지 않는다.** 가정과 함께 문서 끝 `## 확인 필요`에 남긴다.

질문 한도: specify 3개(`[NEEDS CLARIFICATION]` 표시 포함) / clarify 5개 / plan 3개 / tasks 1~2개(계획 검증) / implement 0개 / analyze·converge 0개(보고만).

**되돌아가기**: 어느 단계에서든 spec·plan이 다루지 않는 상황을 발견하면 추측으로 메우지 않는다. 멈추고 질문한 뒤 해당 문서를 먼저 고치고 이어간다.

## 작은 변경은 단계를 줄인다
- **버그 수정 / 문구·로깅 수정**: 바로 implement. `tasks.md`에 phase를 추가하고 `implement.md`에 한 줄 남긴다.
- **기존 기능의 동작 변경**: `/sdd-speckit-specify <NNN> <변경 내용>`으로 spec을 고친 뒤 plan부터.
- **새 API·새 컴포넌트**: specify부터 모두.
- 서비스 전체 방향이 바뀌면 `CLAUDE.md` 서비스 요구사항 논의를 먼저 제안한다.

## 커밋과 브랜치
- **브랜치**: `main` ➔ `NNN-<이름>`, 끝나면 `main`에 머지(일반 머지, squash 금지).
- **커밋 scope**는 번호를 뺀 `<접두사>-<이름>`이다(예: `api-job-create`).
  - implement 시작 전: `docs(<scope>): spec·plan·tasks` (`CLAUDE.md` 요구사항 변경 포함)
  - 작업 확인 후: `feat(<scope>): T005 <작업 요약> (#<이슈 번호>)`. 문서만이면 `docs(...)`, 이슈가 없으면 `(#번호)` 생략.
  - 그 작업의 코드·테스트, `tasks.md` 체크, 작업 중 고친 문서를 함께 넣는다. 커밋 전에 스택 연결 값의 **확인 명령**이 통과해야 한다.
- 머지 전에 converge 수렴 → `/code-review` → PR. 머지는 사용자가 한다.

## 이슈 트래커 연동
`CLAUDE.md`에 이슈 트래커가 설정돼 있을 때만 한다(없으면 건너뛰고 알림). GitHub이면 `.claude/skills/sdd-feat/tracker-github.md`의 명령을 쓰되 아래 값만 바꾼다.
- 이슈 제목 `T005 [<scope>] <작업 내용>`, 본문 문서 경로 `specs/NNN-<이름>/tasks.md`
- 브랜치 `NNN-<이름>`, PR 본문의 문서 줄 `specs/NNN-<이름>/` (spec · plan · tasks · implement)

| 시점 | 할 일 |
|---|---|
| tasks 확인 후 | 이슈가 없는 작업마다 이슈 생성, 보드 `Todo`, `tasks.md` 작업 끝에 ` — #<번호>` |
| 작업 시작(▶) | `In Progress` |
| 작업 확인·커밋 후 | `Done`, 이슈 닫기(결과 한 줄) |
| converge로 추가된 작업 | 새 작업만 이슈 생성 |
| 수렴·리뷰 후 | push, PR 생성 |

기능 하나만 이슈를 만들지 않기로 하면(사용자 결정) `tasks.md` 머리말에 `- **이슈 트래커**: 이 기능은 이슈를 만들지 않는다`를 남기고, 이후 단계는 그 기능의 트래커 명령을 모두 건너뛴다.

트래커 명령이 실패해도 진행은 멈추지 않는다. 보고하고 `implement.md`의 `## 메모`에 남긴다.
