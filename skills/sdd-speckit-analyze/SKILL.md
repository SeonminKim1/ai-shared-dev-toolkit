---
name: sdd-speckit-analyze
description: spec-kit 기반 SDD의 점검 단계. tasks 작성 후 implement 전에 spec.md·plan.md·tasks.md와 constitution 사이의 모순·중복·누락을 읽기 전용으로 분석해 보고한다(`/sdd-speckit-analyze [NNN] [집중할 부분]`). 사용자가 직접 호출했을 때만 사용한다.
---

# /sdd-speckit-analyze

시작 전에 읽는다: `CLAUDE.md`, `.claude/skills/sdd-speckit/process.md`, `.claude/skills/sdd-speckit/constitution.md`, 스택 파일. 대상 기능은 process.md "기능 디렉터리"대로 찾는다. `spec.md`·`plan.md`·`tasks.md` 중 없는 것이 있으면 만들 단계를 안내하고 멈춘다.

**읽기 전용**: 파일을 고치지 않는다. 보고서를 보여주고, 고칠지는 사용자가 정한다. constitution(process.md "Constitution") 위반은 협상 대상이 아니며 항상 CRITICAL이다. 원칙을 바꾸려면 이 기능 밖에서 따로 논의한다.

## 1. 모델 만들기 (출력하지 않음)
- **요구사항 목록**: FR-###, SC-###, 유저 스토리 인수 시나리오(`US1/AC2`), contracts 에러 표 행
- **작업 매핑**: 작업마다 연결되는 요구사항·스토리(ID, 파일, 키워드로)
- **원칙 목록**: constitution·스택 파일·`CLAUDE.md`의 MUST/SHOULD 문장

## 2. 점검 (높은 신호만, 최대 50건)
| 분류 | 볼 것 |
|---|---|
| 중복 | 거의 같은 요구사항 |
| 모호함 | 측정 기준 없는 형용사, 남은 `TODO`·`[NEEDS CLARIFICATION]`·`<placeholder>` |
| 불충분 | 대상·결과가 빠진 요구사항, 인수 기준 없는 스토리, spec·plan에 없는 파일을 건드리는 작업 |
| 원칙 위반 | MUST 원칙과 충돌, 레이어 위반, 테스트 없는 비즈니스 규칙, 정해지지 않은 에러 표현 |
| 커버리지 | 작업 없는 요구사항·에러 케이스, 요구사항 없는 작업 |
| 불일치 | 문서마다 다른 용어, plan과 spec의 엔티티 차이, 선행 관계와 어긋난 작업 순서 |

심각도: **CRITICAL** 원칙 MUST 위반, 핵심 문서 없음, P1 기능을 막는 미커버 요구사항 / **HIGH** 충돌·중복 요구사항, 모호한 보안·성능 기준, 테스트 불가능한 인수 기준 / **MEDIUM** 용어 차이, 비기능 작업 누락, 엣지 케이스 불충분 / **LOW** 문구, 실행에 영향 없는 중복.

## 3. 보고
```
## 명세 분석 보고서
| ID | 분류 | 심각도 | 위치 | 요약 | 권장 조치 |
(ID는 분류 머리글자 + 번호: D1 중복, A1 모호함, U1 불충분, C1 원칙, G1 커버리지, I1 불일치)

커버리지: | 요구사항 | 작업 있음 | 작업 ID | 비고 |
원칙 위반: (있으면) / 연결 안 된 작업: (있으면)
지표: 요구사항 수, 작업 수, 커버리지 %, 모호함·중복·CRITICAL 건수
```
- 위치는 `spec.md:L12`처럼 줄 번호로.
- 다음 안내: CRITICAL이 있으면 implement 전에 해결을 권한다(spec이면 `/sdd-speckit-specify <NNN> ...`, plan이면 `/sdd-speckit-plan`, 작업이면 `tasks.md` 수정). LOW·MEDIUM만 있으면 진행해도 된다고 알린다.
- 마지막에 "상위 N건의 수정안을 만들까요?"라고 묻는다. 승인 없이는 고치지 않는다.
