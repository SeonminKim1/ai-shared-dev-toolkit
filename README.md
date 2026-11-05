# ai-shared-dev-toolkit
프로젝트에 `.claude` 서브모듈로 붙여 쓰는 AI 개발 자산(Skills, 스킬 전용 Hooks) 모음. Claude Code, Cursor에서 사용.

| 자산 | 종류 | 설명 |
|---|---|---|
| [learning-examples](#learning-examples) | Skill | 새 라이브러리 학습용 예제를 계획하고 단계별로 작성 |
| [tistory-post](#tistory-post) | Skill | 소재로 티스토리 붙여넣기용 글 생성 (개인용, macOS) |
| [sdd-feat](#sdd) | Skill | SDD(PRD → SPEC → PLAN → TASK → IMPLEMENT)로 기능 추가·수정. 언어 무관 |
| [sdd-init-fastapi](#sdd) | Skill | 새 FastAPI 프로젝트 뼈대 생성 (`/sdd-feat` 전에 1회) |
| [stacks/](#sdd) | Stack | 스택별 코드 규칙(`fastapi.md`, `spring-boot.md`). 소비 프로젝트 `CLAUDE.md`가 import |
| `settings.json` | 설정 | 권한(`uv`·`./gradlew`·`gh` 허용, 위험 명령 차단). 개인용 |

## 설치

```sh
git submodule add https://github.com/SeonminKim1/ai-shared-dev-toolkit.git .claude
git submodule update --remote .claude   # 업데이트
```

- clone할 때는 `git clone --recurse-submodules`
- 프로젝트 전용 지침은 `.claude/`가 아닌 루트 `CLAUDE.md`에 둔다
- 자산 추가 규칙: [CONTRIBUTING.md](CONTRIBUTING.md)

### 자동 업데이트 (선택)
`~/.claude/settings.json`에 한 번 등록하면, 이 서브모듈이 있는 프로젝트에서 Claude를 켤 때 6시간에 1회 `origin/main`으로 갱신한다.
로컬 커밋이 원격에 없거나 수정 중인 파일과 겹치면 건너뛴다. 갱신 후 상위 프로젝트에 `.claude`가 modified로 보이는 건 정상.

```json
"hooks": {
  "SessionStart": [{ "hooks": [{ "type": "command",
    "command": "f=\"$CLAUDE_PROJECT_DIR/.claude/hooks/auto-update.sh\"; [ -x \"$f\" ] && \"$f\" || true",
    "timeout": 15 }] }]
}
```

### 다른 프로젝트에서 개선해서 PR 보내기

```sh
cd .claude
git switch -c improve/<내용>   # 브랜치 먼저 (안 하면 커밋 유실 위험)
# 수정 후
git commit -am "<설명>" && git push -u origin HEAD && gh pr create
```

머지되면 각 프로젝트에서 `git submodule update --remote .claude`로 반영.

## SDD
SDD 관련 스킬은 모두 `sdd-` 접두사를 쓴다. 지금은 자체 방식(`sdd-feat`, `sdd-init-<stack>`) 하나다.

기능 하나를 `docs/<feature-name>/`의 prd·spec·plan·task·implement 문서로 진행하는 자체 SDD 방식이다. 방법론은 언어와 무관하고(`skills/sdd-feat/`), 언어별 규칙은 스택 파일(`stacks/<stack>.md`)과 init 스킬(`skills/sdd-init-<stack>/`)로 더한다.

새 FastAPI 프로젝트:
```sh
git init && git submodule add https://github.com/SeonminKim1/ai-shared-dev-toolkit.git .claude
```
```
/sdd-init-fastapi                          # 1. 뼈대·CLAUDE.md·README 생성 (먼저 한 번)
/sdd-feat 유저가 주문을 생성한다. 하루 10건 제한   # 2. 기능마다
/sdd-feat api-order-create                  #    멈춘 단계부터 이어서
/sdd-feat api-order-create 쿠폰 필드 추가    #    기존 기능 수정
```

| 파일 | 구분 | 내용 |
|---|---|---|
| `skills/sdd-feat/process.md` | 공통 | 방법론: 단계별 기준, Grill(질문 규칙), 문서 관리·커밋 규칙 |
| `skills/sdd-feat/templates/` | 공통 | 단계별 문서 템플릿 (spec은 `api-`·`component-`·`domain-` 접두사별) |
| `skills/sdd-feat/tracker-github.md` | 공통 | GitHub Project 이슈·상태·PR 연동 (`CLAUDE.md`에 owner·번호가 있을 때만) |
| `stacks/fastapi.md` | 스택 | 레이어·DI·에러·테스트 규칙과 "스택 연결 값" |
| `skills/sdd-init-fastapi/` | 스택 | 부트스트랩 절차와 기본 코드(`files/`) |
| `stacks/spring-boot.md` | 스택 | Spring Boot·Java 규칙 초안 (init 스킬 없음: start.spring.io로 생성) |

- 다른 언어: `stacks/<stack>.md`(`process.md`의 "스택 연결 값" 표를 채움)와 `skills/sdd-init-<stack>/`만 추가한다.
- 프로젝트에만 해당하는 모듈·요구사항은 소비 프로젝트 루트 `CLAUDE.md`에 둔다.

## Skills

### learning-examples
라이브러리 학습용 예제(`ex1.*`, `ex2.*` …)를 계획 → 단위별 작성 → 피드백 순으로 만든다.

```
/learning-examples <라이브러리>
```

### tistory-post
`topics/`의 소재(.md/PDF)로 "잉여개발자" 블로그 문체에 맞춘 본문을 `posts/<slug>/`에 만든다.
두 폴더는 실행한 프로젝트 루트에 자동 생성된다.

```
/tistory-post <slug>
```

- 소재: `topics/<slug>.md`, 나눠 줄 땐 `topics/<slug>/01.md`, `02.md` … 추가 후 "소재 추가했어"
- 결과: 미리보기의 `복사` 버튼 → 티스토리 기본모드에 Cmd+V. 제목·태그는 `meta.md`
- 훅: post.html 저장 시 서식 검사 + 미리보기 자동 갱신 (스킬 실행 중에만). 구조: [skills/tistory-post/README.md](skills/tistory-post/README.md)
- 스크립트: `.claude/skills/tistory-post/scripts/preview.sh <slug>`, `copy.sh [--html] <slug>`
- `.gitignore`: `posts/*/preview.html`
