# sdd-feat

사람이 읽는 메모. Claude는 `SKILL.md`(실행 절차)와 `process.md`(방법론)를 읽는다.

## 개요

SDD(Spec-Driven Development)는 "무엇을, 어떻게 만들지"를 문서(spec)로 먼저 정하고 코드를 작성하는 개발 방식

`/sdd-feat` 스킬 사용시 기능 하나를 아래 5단계로 진행하고, 각 기능별 문서는 `docs/<feature-name>/`에 쌓인다. 

| 단계 | 답하는 질문 | 산출물 |
|---|---|---|
| 1. PRD | 왜, 무엇을 만드나? | `prd.md` |
| 2. SPEC | 어떻게 동작하나? | `spec.md` |
| 3. PLAN | 코드 어디를 바꾸나? | `plan.md` |
| 4. TASK | 어떤 순서로 하나? | `task.md` |
| 5. IMPLEMENT | 제대로 동작하나? | 코드 + `implement.md` |

방법론은 언어와 무관하고, 언어별 규칙만 스택 파일로 더한다. 지금은 **FastAPI**, **Spring Boot**를 지원하며, 프로젝트에만 해당하는 규칙은 각 프로젝트 루트 `CLAUDE.md`에 둔다.

<br>

## 파일 구성

| 파일 | 구분 | 내용 |
|---|---|---|
| `skills/sdd-feat/process.md` | 공통 | 방법론: 단계별 기준, Grill(질문 규칙), 문서 관리·커밋 규칙 |
| `skills/sdd-feat/templates/` | 공통 | 단계별 문서 템플릿 (spec은 `api-`·`component-`·`domain-` 접두사별) |
| `skills/sdd-feat/tracker-github.md` | 공통 | GitHub Project 이슈·상태·PR 연동 (`CLAUDE.md`에 owner·번호가 있을 때만) |
| `skills/sdd-init-fastapi/` | 스택 | 부트스트랩 절차와 기본 코드(`files/`) |
| `stacks/fastapi.md` | 스택 | 레이어·DI·에러·테스트 규칙과 "스택 연결 값" |
| `stacks/spring-boot.md` | 스택 | Spring Boot·Java 규칙 초안 |

<br>

## 다른 언어 추가

공통 파일은 그대로 두고 두 가지만 만든다.

**스택 파일** : `stacks/<stack>.md` (`process.md`의 "스택 연결 값" 표 채우기)<br>
**init 스킬** : `skills/sdd-init-<stack>/` (없으면 각 프레임워크의 생성 도구로 대체)

<br>

## 이름 규칙

SDD 스킬은 모두 `sdd-` 접두사를 쓴다. 자체 방식은 `sdd-feat`·`sdd-init-<stack>`, 다른 방식을 들이면 `sdd-<방식>-*`(예: spec-kit → `sdd-speckit-*`)로 구분한다.
