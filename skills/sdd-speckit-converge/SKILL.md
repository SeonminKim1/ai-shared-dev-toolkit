---
name: sdd-speckit-converge
description: spec-kit 기반 SDD의 수렴 단계. implement 후 현재 코드를 spec·plan·tasks·constitution과 대조해 남은 일을 찾고, 있으면 tasks.md 끝에 Convergence phase로 추가한다(`/sdd-speckit-converge [NNN]`). 수렴할 때까지 implement와 번갈아 쓴다. 사용자가 직접 호출했을 때만 사용한다.
---

# /sdd-speckit-converge

시작 전에 읽는다: `CLAUDE.md`, `.claude/skills/sdd-speckit/process.md`, `.claude/skills/sdd-speckit/constitution.md`, 스택 파일. 대상 기능은 process.md "기능 디렉터리"대로 찾는다. `spec.md`·`plan.md`·`tasks.md` 중 없는 것이 있으면 만들 단계를 안내하고 멈춘다.

**추가만 한다**: 유일한 쓰기는 `tasks.md` 끝에 `## Phase N: 수렴 (Convergence)`를 추가하는 것이다. `spec.md`·`plan.md`, 기존 작업(번호·순서·체크), 코드는 바꾸지 않는다. 남은 일이 없으면 `tasks.md`를 한 글자도 바꾸지 않는다. git diff로 판단하지 않고 지금 코드 상태만 본다.

## 1. 의도 목록 (출력하지 않음)
- FR-###, 구현이 필요한 SC-###, 유저 스토리 인수 시나리오(`US1/AC2`), contracts 에러 표 행, plan의 결정(변경 파일·DB 변경), constitution·스택 파일·`CLAUDE.md`의 MUST
- 점검 범위: plan·tasks에 적힌 파일 + 요구사항 개념의 키워드 검색. 그 밖으로 넓히지 않는다.

## 2. 코드 대조
체크된 작업도 다시 확인한다(체크는 증거가 아니다). 차이가 있는 곳만 발견 항목으로 만든다.
- **missing**: 코드에 없음 / **partial**: 있지만 요구사항을 다 채우지 못함 / **contradicts**: 의도·MUST와 충돌 / **unrequested**: 문서에 없는 작업(지우지 않고 검토 작업만 추가)
- 심각도: **CRITICAL** MUST 위반, P1 스토리를 막는 missing·contradicts / **HIGH** 핵심 요구사항의 missing·partial / **MEDIUM** 부차 요구사항의 partial, 근거 불명확한 unrequested / **LOW** 사소한 partial, 위험 낮은 unrequested
- 확인 명령(테스트)도 돌려 실패를 발견 항목에 넣는다.

## 3. 보고 후 추가
1. 먼저 보여준다:
   ```
   ## 수렴 점검 결과
   | ID | 유형 | 심각도 | 출처 | 근거(파일·위치) | 남은 일 |
   점검 수: 요구사항·인수 시나리오 / plan 결정 / 원칙, 유형별·심각도별 건수
   ```
2. 발견 항목이 있으면 `tasks.md` 끝에 새 phase를 추가한다. 번호는 기존 최대 + 1부터, CRITICAL·HIGH 먼저, 원칙 위반은 맨 앞에 `CRITICAL`로:
   `- [ ] T042 <명령형 설명> — <출처: FR-003 | US1/AC2 | plan: DB 변경 | Constitution III> (<유형>)`
   이전 수렴 phase가 있어도 고치지 않고 그 아래에 새로 추가한다. 이슈 트래커가 설정돼 있으면 새 작업만 이슈로 만든다.
3. 없으면 `tasks.md`를 그대로 두고 **"✅ 수렴 — 구현이 spec·plan·tasks를 모두 채웠습니다."**와 점검 수를 보고한다.

## 4. 다음 안내
- 작업을 추가했으면 `/sdd-speckit-implement` → 다시 `/sdd-speckit-converge`.
- 수렴했으면 `implement.md` 완료 체크리스트의 converge 항목을 체크하고 `/code-review` → PR(process.md "커밋과 브랜치").
- 같은 항목이 두 번 연속 남으면 문서 쪽 문제일 수 있으니 spec·plan 수정을 제안한다.
