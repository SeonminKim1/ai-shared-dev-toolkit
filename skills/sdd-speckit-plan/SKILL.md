---
name: sdd-speckit-plan
description: spec-kit 기반 SDD의 계획 단계. `specs/NNN-<이름>/spec.md`로 plan.md, research.md, data-model.md, contracts/, quickstart.md를 만든다(`/sdd-speckit-plan [NNN] [기술 방향]`). Constitution Check를 통과해야 한다. 사용자가 직접 호출했을 때만 사용한다.
disable-model-invocation: true
---

# /sdd-speckit-plan

시작 전에 읽는다: `CLAUDE.md`, `.claude/skills/sdd-speckit/process.md`, `.claude/skills/sdd-speckit/constitution.md`, 스택 파일 전체(레이어·에러·문서 규칙 포함). 대상 기능은 process.md "기능 디렉터리"대로 찾는다. `spec.md`가 없으면 `/sdd-speckit-specify`를 안내하고 멈춘다. `[NEEDS CLARIFICATION]`이 남아 있거나 체크리스트 미통과 항목이 있으면 알리고 `/sdd-speckit-clarify`를 권한다(사용자가 진행하자고 하면 진행). 아래의 `templates/`는 `.claude/skills/sdd-speckit/templates/`다.

## 1. 기술 맥락과 Constitution Check
1. `templates/plan.md`로 `plan.md`를 만들고 기술 맥락을 채운다. 프로젝트 코드·스택 파일로 답이 나오면 그대로, 모르는 것만 `NEEDS CLARIFICATION`.
2. Constitution Check를 채운다(process.md "Constitution"). constitution 원칙만이 아니라 스택 파일의 규칙 중 이 기능이 건드리는 것(예: API 문서, 에러 응답 문서, 요청 파싱)도 행으로 넣는다. 통과하지 못하면 예외의 근거를 복잡도 기록에 적거나, 근거가 없으면 멈추고 묻는다.

## 2. Phase 0: research.md
- `NEEDS CLARIFICATION`마다, 새 의존성·연동마다 결정 하나를 `templates/research.md` 형식(결정 / 근거 / 검토한 대안)으로 적는다. 기존 코드 패턴(`specs/*/`, `src/`)을 먼저 찾아 맞춘다.
- 모든 `NEEDS CLARIFICATION`이 풀려야 Phase 1로 간다.

## 3. Phase 1: 설계
1. **data-model.md** (`templates/data-model.md`): spec의 핵심 엔티티 → 필드·타입·제약·인덱스·상태 전이. 기존 모델만 쓰면 "변경 없음 — <경로>".
2. **contracts/**: 접두사로 고른다. `api-` → 엔드포인트마다 `templates/contract-api.md`, `ui-` → 화면마다 `templates/contract-ui.md`, `component-` → `templates/contract-component.md`, `domain-` → 만들지 않는다(data-model.md가 계약). spec 엣지 케이스마다 에러 표 행이 있어야 한다. 기존 contracts의 에러 식별자·응답 형태를 맞춘다.
3. **quickstart.md** (`templates/quickstart.md`): 정상·대표 에러 시나리오를 스택 연결 값의 **동작 확인 방법**·**확인 명령**으로.
4. plan의 변경 파일·데이터 변경·외부 의존성을 채우고 Constitution Check를 다시 확인한다.

## 4. 마무리
1. **Grill 체크리스트**로 점검하고, 설계 대안 중 정할 수 없는 것만 묻는다(최대 3개).
2. 요약을 보여주고 확인받는다: 변경 파일(레이어 순), 데이터 변경, 계약 목록, research 결정, Constitution Check 결과.
3. 다음 안내: `/sdd-speckit-tasks`.

## Grill 체크리스트
- 레이어 규칙을 어기는 곳이 없는가? 변경 파일이 레이어 순서로 빠짐없이 나열됐는가?
- 스택 연결 값의 **데이터 변경**(저장 구조, 인덱스·제약, 기존 데이터 호환)이 필요한가?
- spec의 동시성·실패 케이스를 코드에서 어떻게 지키는가? (스택 연결 값의 엣지 케이스에 적힌 수단)
- 모든 엣지 케이스에 에러 식별자와 결과(에러 표현)가 있는가?
- 단위 테스트가 가짜 객체로 대체한 동작(DB 정밀도·인덱스, 외부 시스템, 브라우저 동작)을 quickstart가 실제로 확인하는가?
- (API 기능) 스택의 API 문서 규칙을 요청 쪽(path·query·header·body의 설명·example)과 응답 쪽(성공·에러 example) 모두에 적용했는가? 새 파라미터마다 example 상수가 변경 파일에 있는가?
- 더 단순한 대안은 없는가? 되돌리기 어려운 결정이나 기존 기능에 주는 영향이 있는가?
