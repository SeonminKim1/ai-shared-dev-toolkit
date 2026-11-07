---
name: sdd-feat
description: 기능 추가/수정을 SDD 프로세스(PRD → SPEC → PLAN → TASK → IMPLEMENT)로 진행하는 스킬. `/sdd-feat <기능 설명>`으로 짧은 설명만 받아 PRD 초안부터 시작하고, `/sdd-feat <feature-name> [변경 내용]`으로 기존 기능을 이어서 진행하거나 수정한다. 사용자가 직접 호출했을 때만 사용한다.
disable-model-invocation: true
---

# /sdd-feat

이 폴더의 `process.md` 단계대로 기능을 진행하는 실행 절차다. 규칙(Grill, 문서 관리, 커밋, 진행 보고, 작업 확인)은 `process.md`가 기준이고, 여기에는 순서만 적는다.

시작 전에 읽는다: `CLAUDE.md`, 이 폴더의 `process.md`, 스택 파일(`CLAUDE.md`가 import하는 `.claude/stacks/<stack>.md`의 "스택 연결 값"). `src/`가 없는 새 프로젝트면 먼저 `/sdd-init-<stack>`(예: `/sdd-init-fastapi`)을 권한다. 문서는 이 폴더의 `templates/<단계>.md`로 쓴다. SPEC만 접두사로 고른다: `api-` → `spec-api.md`, `ui-` → `spec-ui.md`, `component-` → `spec-component.md`, `domain-` → `spec-domain.md`. 한 기능이 둘에 걸치면(예: API와 컴포넌트를 함께 추가) 기능을 나누자고 제안한다.

## 사용법
```
/sdd-feat 유저가 주문을 생성한다. 1인당 하루 10건 제한.   # 새 기능
/sdd-feat api-order-create                                # 멈춘 단계부터 이어서
/sdd-feat api-order-create 쿠폰 필드 추가                  # 기존 기능 수정
```
끝에 "끝까지"를 붙이면 **단계 사이의 확인만** 생략하고 IMPLEMENT까지 진행한다. Grill 질문, TASK 검증, 진행 보고, 작업별 코드 확인은 생략하지 않는다.

## 1. 모드 판별
- 인자의 첫 단어로 된 `docs/<첫 단어>/` 폴더가 있으면 **기존 기능**(뒤에 설명이 없으면 "이어서", 있으면 "수정"), 없으면 **새 기능**이다.
- 인자가 없으면 무엇을 할지 묻는다.

## 2. 새 기능: PRD 초안
사용자가 PRD를 길게 쓰지 않아도 되게 하는 것이 목적이다.
1. 설명에서 `<feature-name>`을 추론한다(`process.md`의 접두사 규칙).
2. 설명, `CLAUDE.md` 요구사항, 기존 `docs/*/prd.md`를 참고해 `templates/prd.md`를 채운다.
   - PRD Grill로 점검하고 정할 수 없는 것만 AskUserQuestion으로 묻는다(한도 3개).
   - 질문 없이 추정으로 채운 항목에는 `(추정)`을 붙인다.
   - 서비스 전체 규칙이 섞여 있으면 확인 후 `CLAUDE.md` 요구사항으로 옮긴다. 요구사항 섹션이 비어 있으면(첫 PRD) 특히 꼼꼼히 본다.
3. `docs/<feature-name>/prd.md`로 저장하고 요약을 보여주고 확인받는다.

## 3. 단계 진행
- 현재 단계는 폴더의 문서로 판단한다: `prd.md`만 → SPEC, `spec.md`까지 → PLAN, `plan.md`까지 → TASK, `task.md`에 미완료 → IMPLEMENT, 모두 완료 → 상태 보고 후 종료.
- 각 단계: Grill 점검 → 정할 수 없는 것만 질문(한도 초과분은 `## 확인 필요`) → 템플릿대로 작성 → 보여주고 확인("끝까지"면 이 확인만 생략).
- **TASK**: 실행 흐름을 보여주고 검증 질문 후 확인받는다. 이슈 트래커가 설정돼 있으면 확인 후 이슈를 만들고(`tracker-github.md`) 만든 목록(번호, 제목)을 보고한다.
- **IMPLEMENT**:
  1. `feature/<feature-name>` 브랜치에서 PRD~TASK 문서를 먼저 커밋한다.
  2. 실행 흐름 순서대로 작업을 하나씩 진행한다. 시작 시 이슈 `In Progress`, ▶·✔·■ 진행 보고.
  3. 작업이 끝나면 **멈추고 작업 확인**을 받는다. 확인되면 그 작업의 변경만 커밋하고(다른 작업의 변경이 섞인 파일은 그 작업 시점의 내용만), 이슈를 `Done`으로 닫는다.
  4. 모든 작업이 끝나면 완료 체크리스트를 수행하고 README의 API 표를 갱신한 뒤 `/code-review`를 권한다.
  5. 리뷰 반영 후(이슈 트래커 연동 시) push하고 PR을 만든다(`tracker-github.md`의 "PR 생성"). 머지는 사용자에게 맡기고 일반 머지 명령을 안내한다.

## 4. 기존 기능 수정
1. 변경 종류를 분류해 알린다: **버그·문구** → 바로 구현, `implement.md`에 변경 섹션 / **동작 변경** → `spec.md` 수정 → `plan.md`·`task.md` 변경 섹션 → 구현 / **규칙 변경** → `prd.md`부터.
2. 문서는 문서 관리 규칙대로 덮어쓰거나 추가한다. 새로 생긴 작업만 이슈로 만든다.
3. 서비스 전체 방향에 관한 변경이면 `CLAUDE.md` 요구사항 논의를 먼저 제안한다.
