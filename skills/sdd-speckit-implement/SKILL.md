---
name: sdd-speckit-implement
description: spec-kit 기반 SDD의 구현 단계. `specs/NNN-<이름>/tasks.md`의 실행 흐름대로 작업을 하나씩 구현하고, 작업마다 멈춰 확인받은 뒤 커밋한다(`/sdd-speckit-implement [NNN] [작업 범위]`). 사용자가 직접 호출했을 때만 사용한다.
disable-model-invocation: true
---

# /sdd-speckit-implement

시작 전에 읽는다: `CLAUDE.md`, `.claude/skills/sdd-speckit/process.md`(커밋·트래커 규칙), `.claude/skills/sdd-speckit/constitution.md`, 스택 파일 전체. 대상 기능은 process.md "기능 디렉터리"대로 찾는다. `tasks.md`가 없으면 `/sdd-speckit-tasks`를 안내하고 멈춘다. 인자로 작업 범위(예: `T005-T008`, `US1`)를 받으면 그것만 한다. 인자가 버그·문구 수정 설명이면(process.md "작은 변경") `tasks.md` 끝에 `## Phase N: 변경 YYYY-MM-DD <요약>`과 작업을 추가해 보여주고 확인받은 뒤 그 작업만 한다. 아래의 `templates/`는 `.claude/skills/sdd-speckit/templates/`다.

## 1. 준비
1. `checklists/`의 체크리스트를 표로 보여준다(파일, 전체, 완료, 남음). 남은 항목이 있으면 진행할지 묻는다.
2. 현재 브랜치가 `NNN-<이름>`인지 본다(아니면 전환). `tasks.md`, `plan.md`와 있으면 `data-model.md`, `contracts/`, `research.md`, `quickstart.md`를 읽는다.
3. 아직 커밋하지 않은 문서(spec~tasks, `CLAUDE.md` 요구사항 변경)를 `docs(<scope>): spec·plan·tasks`로 먼저 커밋한다.
4. `templates/implement.md`로 `implement.md`를 만든다(있으면 이어서).

## 2. 작업마다
실행 흐름 순서대로 미완료(`- [ ]`) 작업을 **하나씩** 한다. 병렬 단계도 하나씩 한다. 실행 흐름이 끝나면 수렴(Convergence) phase를 위에서부터 그 phase의 실행 순서대로 한다.
1. ▶ 보고하고(process.md 형식), 이슈가 있으면 `In Progress`(tasks.md에 이슈를 만들지 않는다고 적혀 있으면 트래커 명령은 모두 건너뛴다).
2. 구현한다. 스택 규칙과 contracts·data-model을 그대로 따르고, 테스트를 함께 쓴다. spec·plan이 다루지 않는 상황이면 ⏸ 보고 후 멈추고 묻는다(되돌아가기). 답을 받으면:
   1. 해당 문서(spec·plan·data-model 등, 다른 기능의 문서 포함)를 먼저 고친다.
   2. 새 작업이 필요하면 `tasks.md`에 phase로 추가하고, 시작 전 작업(중단한 작업 포함)의 선행·순서를 조정한다(process.md "작업 변경 규칙"). 조정 이유는 진행 기록에 남긴다.
   3. 새 작업부터 이 절차대로 진행하고, 끝나면 중단한 작업을 ▶로 다시 시작한다.
3. 스택 연결 값의 **확인 명령**을 돌린다.
4. **멈추고 작업 확인**을 받는다. 보여줄 것:
   - **바뀐 파일**(파일별 한 줄), **핵심 코드**(리뷰할 부분만, `파일경로:줄번호`)
   - **왜 이렇게 했나**(근거가 된 규칙·FR·계약, 고려한 대안), **확인 결과**(명령 출력 요약, 직접 실행)
   - **봐 줄 것**(사용자 판단이 필요한 부분, 없으면 생략)
5. 확인되면 `tasks.md`에서 그 작업을 `- [x]`로 바꾸고 그 작업의 변경만 커밋한다(`feat(<scope>): T005 <요약> (#이슈)`). 이슈를 `Done`으로 닫는다. ✔ 보고와 `implement.md` 진행 기록을 남긴다.
6. 단계가 끝나면 ■ 보고. 확인 전에는 다음 작업을 시작하지 않는다.

구현 중 spec과 달라진 점은 `implement.md`의 `## spec과 달라진 점`에 남기고 해당 문서도 고쳐 그 작업 커밋에 넣는다.

## 3. 모든 작업이 끝나면
1. `implement.md` 완료 체크리스트를 수행한다(스택 연결 값의 확인 명령·API 확인 방법·추가 완료 항목, quickstart 시나리오).
2. 다음 안내: `/sdd-speckit-converge`. 수렴하면 `/code-review` → 리뷰 반영 → (트래커 연동 시) push·PR 생성. 머지는 사용자에게 맡기고 일반 머지 명령을 안내한다.

## Grill 체크리스트 (질문하지 않음)
- spec의 에러 케이스·비즈니스 규칙마다 테스트가 있는가? spec과 달라진 점이 기록됐는가?
- 작업 범위 밖의 파일을 바꾸지 않았는가?
