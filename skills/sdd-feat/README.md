# sdd-feat

사람이 읽는 메모. Claude는 `SKILL.md`(실행 절차)와 `process.md`(방법론)를 읽는다.

## 개요

SDD(Spec-Driven Development)는 "무엇을, 어떻게 만들지"를 문서(spec)로 먼저 정하고 코드를 작성하는 개발 방식

`/sdd-feat` 스킬을 쓰면 기능 하나를 아래 5단계로 진행하고, 기능별 문서는 `docs/<feature-name>/`에 쌓인다. 명령 하나로 단계를 이어 가며, 각 단계 문서를 보여주고 확인받은 뒤 다음으로 넘어간다.

| 단계 | 답하는 질문 | 산출물 |
|---|---|---|
| 1. PRD | 왜, 무엇을 만드나? | `prd.md` |
| 2. SPEC | 어떻게 동작하나? | `spec.md` |
| 3. PLAN | 코드 어디를 바꾸나? | `plan.md` |
| 4. TASK | 어떤 순서로 하나? | `task.md` |
| 5. IMPLEMENT | 제대로 동작하나? | 코드 + `implement.md` |

```sh
/sdd-feat 유저가 주문을 생성한다.          # 새 기능 → docs/api-order-create/
/sdd-feat api-order-create 쿠폰 필드 추가   # 기존 기능 수정
```

**작은 변경**은 단계를 줄인다: 버그·문구 수정은 바로 5단계, 기존 기능의 동작 변경은 `spec.md`를 고친 뒤 3~5단계, 새 API·컴포넌트는 1단계부터.<br>
**새 프로젝트**는 먼저 `/sdd-init-fastapi`(React는 `/sdd-init-react`)에서 SDD 방식으로 `sdd-feat`을 고른다.

방법론은 언어와 무관하고, 언어별 규칙만 스택 파일로 더한다. 지금은 **FastAPI**, **Spring Boot**(초안), **React**(프론트엔드)를 지원하며, 프로젝트에만 해당하는 규칙은 각 프로젝트 루트 `CLAUDE.md`에 둔다.

<br>

## 파일 구성

| 파일 | 구분 | 내용 |
|---|---|---|
| `skills/sdd-feat/process.md` | 공통 | 방법론: 단계별 기준, Grill(질문 규칙), 문서 관리·커밋 규칙 |
| `skills/sdd-feat/templates/` | 공통 | 단계별 문서 템플릿 (spec은 `api-`·`ui-`·`component-`·`domain-` 접두사별) |
| `skills/sdd-feat/tracker-github.md` | 공통 | GitHub Project 이슈·상태·PR 연동 (`CLAUDE.md`에 owner·번호가 있을 때만). `sdd-speckit`도 재사용 |
| `skills/sdd-init-fastapi/` | 스택 | 부트스트랩 절차와 기본 코드(`files/`) |
| `skills/sdd-init-react/` | 스택 | React(Vite) 부트스트랩 절차와 기본 코드(`files/`) |
| `stacks/fastapi.md` | 스택 | 레이어·DI·에러·테스트 규칙과 "스택 연결 값" |
| `stacks/spring-boot.md` | 스택 | Spring Boot·Java 규칙 초안 |
| `stacks/react.md` | 스택 | React·TypeScript(Vite) 프론트엔드 규칙과 새 프로젝트 순서 |

<br>

## 다른 언어 추가

공통 파일은 그대로 두고 두 가지만 만든다. 스택 파일은 `sdd-speckit`도 같이 쓰므로 한쪽 방식에만 맞는 문구를 넣지 않는다.

**스택 파일** : `stacks/<stack>.md` (`process.md`의 "스택 연결 값" 표 채우기)<br>
**init 스킬** : `skills/sdd-init-<stack>/` (없으면 각 프레임워크의 생성 도구로 대체)

<br>

## sdd-speckit과의 관계

[GitHub spec-kit](https://github.com/github/spec-kit) 기반의 다른 방식이다. 한 프로젝트에서는 둘 중 하나만 쓰고, 문서 위치로 구분한다(`docs/<feature>/` → `sdd-feat`, `specs/NNN-*/` → `sdd-speckit`). 비교와 문서 옮기기는 [../sdd-speckit/README.md](../sdd-speckit/README.md) 참고.
