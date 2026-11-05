# ai-shared-dev-toolkit

프로젝트에 `.claude` 서브모듈로 붙여 쓰는 AI 개발 자산 모음 (Claude Code, Cursor)

```sh
git submodule add https://github.com/SeonminKim1/ai-shared-dev-toolkit.git .claude
```

| 명령 | 하는 일 |
|---|---|
| [`/sdd-init-fastapi`](#sdd) | 새 FastAPI 프로젝트 뼈대 생성 (`/sdd-feat` 전에 1회) |
| [`/sdd-feat <기능 설명>`](#sdd) | SDD(PRD → SPEC → PLAN → TASK → IMPLEMENT)로 기능 추가·수정 |
| [`/learning-examples <라이브러리>`](#learning-examples) | 라이브러리 학습용 예제를 계획하고 단계별로 작성 |
| [`/tistory-post <slug>`](#tistory-post) | 소재로 티스토리 붙여넣기용 글 생성 (개인용, macOS) |

<br>

## SDD

기능 하나를 `docs/<feature-name>/`의 prd·spec·plan·task·implement 문서로 진행한다.

```
/sdd-init-fastapi                              # 1. 뼈대·CLAUDE.md·README 생성 (먼저 한 번)
/sdd-feat 유저가 주문을 생성한다. 하루 10건 제한   # 2. 기능마다
/sdd-feat api-order-create                     #    멈춘 단계부터 이어서
/sdd-feat api-order-create 쿠폰 필드 추가        #    기존 기능 수정
```

- 방법론은 언어 무관(`skills/sdd-feat/`), 언어별 규칙은 `stacks/<stack>.md` + `skills/sdd-init-<stack>/`
- 지원 스택: FastAPI (init 있음), Spring Boot (규칙 초안만, start.spring.io로 생성)
- 프로젝트 전용 모듈·요구사항은 소비 프로젝트 루트 `CLAUDE.md`에 둔다

<details>
<summary>파일 구성 · 다른 언어 추가</summary>

| 파일 | 구분 | 내용 |
|---|---|---|
| `skills/sdd-feat/process.md` | 공통 | 방법론: 단계별 기준, Grill(질문 규칙), 문서 관리·커밋 규칙 |
| `skills/sdd-feat/templates/` | 공통 | 단계별 문서 템플릿 (spec은 `api-`·`component-`·`domain-` 접두사별) |
| `skills/sdd-feat/tracker-github.md` | 공통 | GitHub Project 이슈·상태·PR 연동 (`CLAUDE.md`에 owner·번호가 있을 때만) |
| `stacks/fastapi.md` | 스택 | 레이어·DI·에러·테스트 규칙과 "스택 연결 값" |
| `skills/sdd-init-fastapi/` | 스택 | 부트스트랩 절차와 기본 코드(`files/`) |
| `stacks/spring-boot.md` | 스택 | Spring Boot·Java 규칙 초안 |

- 다른 언어: `stacks/<stack>.md`(`process.md`의 "스택 연결 값" 표를 채움)와 `skills/sdd-init-<stack>/`만 추가
- SDD 스킬은 모두 `sdd-` 접두사. 지금은 자체 방식 하나

</details>

<br>

## learning-examples

라이브러리 학습용 예제(`ex1.*`, `ex2.*` …)를 계획 → 단위별 작성 → 피드백 순으로 만든다.

```
/learning-examples <라이브러리>
```

<br>

## tistory-post

`topics/`의 소재(.md/PDF)로 "잉여개발자" 블로그 문체의 본문을 `posts/<slug>/`에 만든다. 두 폴더는 프로젝트 루트에 자동 생성.

```
/tistory-post <slug>
```

- 소재 추가: `topics/<slug>/01.md`, `02.md` … 넣고 "소재 추가했어"
- 결과: 미리보기 `복사` 버튼 → 티스토리 기본모드에 Cmd+V (제목·태그는 `meta.md`)
- 저장할 때마다 훅이 서식 검사 + 미리보기 갱신
- `.gitignore`에 `posts/*/preview.html` 추가 권장

구조와 훅 연결 고리: [skills/tistory-post/README.md](skills/tistory-post/README.md)

<br>

## 업데이트

```sh
git submodule update --remote .claude
```

- clone할 땐 `git clone --recurse-submodules`
- 갱신 후 상위 프로젝트에 `.claude`가 modified로 보이는 건 정상 (서브모듈 포인터 변경)

<details>
<summary>자동 업데이트 켜기 (선택, Claude Code 전용)</summary>

Claude를 켤 때 6시간에 1회 `origin/main`으로 갱신한다. 원격에 없는 로컬 커밋이 있거나 수정 중인 파일과 겹치면 건너뛴다.
`~/.claude/settings.json`에 한 번만 등록 (서브모듈 없는 프로젝트에선 아무것도 안 함):

```json
"hooks": {
  "SessionStart": [{ "hooks": [{ "type": "command",
    "command": "f=\"$CLAUDE_PROJECT_DIR/.claude/hooks/auto-update.sh\"; [ -x \"$f\" ] && \"$f\" || true",
    "timeout": 15 }] }]
}
```

프로젝트마다 처음 한 번은 수동 업데이트가 필요하다 (`auto-update.sh`가 받아져야 동작).

</details>

<br>

## 기여

다른 프로젝트에서 쓰다가 개선하면 거기서 바로 PR:

```sh
cd .claude
git switch -c improve/<내용>   # 브랜치 먼저 (안 하면 커밋 유실 위험)
git commit -am "<설명>" && git push -u origin HEAD && gh pr create
```

```
skills/<이름>/   스킬 (SKILL.md + 전용 hooks/, scripts/)
stacks/          스택별 코드 규칙 (소비 프로젝트 CLAUDE.md가 import)
hooks/           공용 훅 (~/.claude/settings.json에 등록)
settings.json    권한만 (uv·gradlew·gh 허용, 위험 명령 차단). 개인용
```

작성 규칙: [CONTRIBUTING.md](CONTRIBUTING.md)
