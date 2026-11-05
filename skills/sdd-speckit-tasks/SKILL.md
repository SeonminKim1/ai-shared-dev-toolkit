---
name: sdd-speckit-tasks
description: spec-kit 기반 SDD의 작업 분할 단계. `specs/NNN-<이름>/`의 plan·spec·설계 문서로 유저 스토리별 phase와 의존 순서가 있는 tasks.md를 만든다(`/sdd-speckit-tasks [NNN] [제약]`). 사용자가 직접 호출했을 때만 사용한다.
---

# /sdd-speckit-tasks

시작 전에 읽는다: `CLAUDE.md`, `.claude/skills/sdd-speckit/process.md`, `.claude/skills/sdd-speckit/constitution.md`, 스택 파일의 "스택 연결 값"(특히 **TASK 기본 순서**). 대상 기능은 process.md "기능 디렉터리"대로 찾는다. `plan.md`가 없으면 `/sdd-speckit-plan`을 안내하고 멈춘다. 아래의 `templates/`는 `.claude/skills/sdd-speckit/templates/`다.

## 1. 작성
1. 읽는다: `plan.md`(변경 파일), `spec.md`(유저 스토리·우선순위), 있으면 `data-model.md`, `contracts/`, `research.md`, `quickstart.md`.
2. `templates/tasks.md` 형식으로 `tasks.md`를 만든다.
   - **phase**: 준비(새 의존성·설정, 없으면 생략) → 기반(여러 스토리가 함께 쓰는 모델·에러 항목·repository) → 유저 스토리별(우선순위 순, `[US1]`) → 마무리(문서 갱신, quickstart 확인).
   - **phase 안 순서**: 스택 연결 값의 TASK 기본 순서(레이어 안쪽 → 바깥쪽). 테스트는 그 계층 작업에 함께 넣는다.
   - **매핑**: 엔티티 → 처음 쓰는 스토리(여러 스토리면 기반), 계약 → 그것을 쓰는 스토리, research 결정 → 준비. data-model의 제약은 설명에 그대로 옮긴다.
   - 번호는 `T001`부터 실행 순서대로. `[P]`는 다른 파일이고 미완료 작업에 의존하지 않을 때만.
   - 작업마다 파일 경로와 선행 작업을 적고, 이를 바탕으로 **실행 흐름**(순차/병렬 단계)을 만든다.
3. 이미 `tasks.md`가 있으면(기존 기능 수정) `## Phase N: 변경 YYYY-MM-DD <요약>`을 아래에 추가하고 번호를 이어간다. 기존 작업은 process.md "작업 변경 규칙"대로 다룬다.

## 2. 검증
1. **Grill 체크리스트**로 점검한다.
2. 실행 흐름을 보여주고 작업 계획 검증 질문 1~2개를 한다(크기·순서, 병렬 묶음, 빠진 작업). 사용자가 확인해야 끝난다.
3. 이슈 트래커가 설정돼 있으면 만들지 묻고, 만들기로 하면 이슈를 만들고(process.md "이슈 트래커 연동") 만든 목록(번호, 제목)을 보고한다.
4. 보고: 작업 수(스토리별), 병렬 묶음, 스토리별 독립 테스트, MVP 범위(보통 US1).
5. 다음 안내: `/sdd-speckit-analyze`(권장) 후 `/sdd-speckit-implement`.

## Grill 체크리스트
- 모든 기능 요구사항(FR)·계약에 작업이 있는가? 요구사항과 연결되지 않은 작업은 없는가?
- 하루를 넘는 작업이 없는가? 선행 관계가 실제 코드 의존과 맞는가?
- 비즈니스 규칙·에러 케이스마다 테스트가 들어 있는가? 문서 갱신 작업이 빠지지 않았는가?
- 같은 파일을 건드리는 작업에 `[P]`가 붙지 않았는가?
