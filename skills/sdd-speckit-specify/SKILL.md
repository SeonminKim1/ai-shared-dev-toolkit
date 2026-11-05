---
name: sdd-speckit-specify
description: spec-kit 기반 SDD의 첫 단계. 짧은 기능 설명으로 `specs/NNN-<이름>/spec.md`를 만들거나(`/sdd-speckit-specify <기능 설명>`), 기존 기능의 spec을 고친다(`/sdd-speckit-specify <NNN> <변경 내용>`). 사용자가 직접 호출했을 때만 사용한다.
---

# /sdd-speckit-specify

시작 전에 읽는다: `CLAUDE.md`, `.claude/skills/sdd-speckit/process.md`(규칙 기준), `.claude/skills/sdd-speckit/constitution.md`, 스택 파일의 "스택 연결 값". `src/`가 없는 새 프로젝트면 먼저 `/sdd-init-<stack>`을 권한다. 아래의 `templates/`는 `.claude/skills/sdd-speckit/templates/`다.

```
/sdd-speckit-specify 유저가 주문을 생성한다. 1인당 하루 10건 제한.   # 새 기능
/sdd-speckit-specify 004 쿠폰 필드 추가                               # 기존 기능 수정
```

## 1. 모드 판별
- 첫 단어가 `specs/`의 번호·디렉터리 이름이면 **수정**, 아니면 **새 기능**. 인자가 없으면 무엇을 할지 묻는다.
- 수정이면 변경 종류를 알린다: **버그·문구** → spec은 그대로, `/sdd-speckit-implement`로 안내 / **동작 변경** → spec 수정 후 plan부터 / **규칙 변경** → `개요`·요구사항부터. 3으로 간다.

## 2. 새 기능: 디렉터리와 브랜치
1. 설명에서 이름을 정한다: `<접두사>-<2~4단어>`(kebab-case, 접두사는 process.md "기능 디렉터리").
2. 번호 `NNN`을 정하고 working tree가 깨끗한지 본다(아니면 묻는다). 최신 `main`에서 `NNN-<이름>` 브랜치를 만든다.
3. `templates/spec.md`로 `specs/NNN-<이름>/spec.md`를 만든다.

## 3. spec 작성
1. 설명, `CLAUDE.md` 요구사항, 기존 `specs/*/spec.md`, 관련 코드를 참고해 채운다.
   - 설명에서 행위자·행동·데이터·제약을 뽑는다. 유저 흐름이 정해지지 않으면 멈추고 묻는다.
   - 모호한 점은 합리적 기본값으로 정하고 `## 가정`에 남긴다. 범위·보안·사용자 경험에 크게 영향을 주고 기본값이 없는 것만 `[NEEDS CLARIFICATION: <질문>]`(최대 3개).
   - 서비스 전체 규칙이 섞여 있으면 확인 후 `CLAUDE.md` 요구사항으로 옮기고 spec에는 참조만 남긴다.
2. **Grill 체크리스트**로 점검하고, 정할 수 없는 것만 묻는다(`[NEEDS CLARIFICATION]` 포함 3개).
3. `templates/checklist-requirements.md`로 `checklists/requirements.md`를 만들고 항목마다 판정한다. 실패 항목은 spec을 고치고 다시 판정한다(최대 3회, 남으면 체크리스트 `## 메모`에 이유).
4. spec 요약, 체크리스트 결과, 남은 `[NEEDS CLARIFICATION]`을 보여주고 확인받는다.
5. 다음 안내: 모호한 점이 남았으면 `/sdd-speckit-clarify`, 아니면 `/sdd-speckit-plan`.

## Grill 체크리스트
- 이 기능이 없으면 무엇이 안 되는가? 완료 기준이 검증 가능한 문장인가?
- 범위 제외가 비어 있지 않은가? 범위가 한 기능으로 너무 크지 않은가?
- 유저 스토리마다 독립 테스트와 인수 시나리오가 있는가? P1만으로 MVP가 되는가?
- `CLAUDE.md` 요구사항이나 다른 기능과 충돌하지 않는가?
- 구현 디테일(Method/Path, 타입, 상태 코드)이 섞이지 않았는가? (plan의 contracts로 미룬다)
