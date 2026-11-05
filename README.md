# ai-shared-dev-toolkit

개발·학습·글쓰기에 쓰는 AI 자산 모음. 어느 저장소든 .claude 서브모듈로 붙여 쓴다. (Claude Code)

```sh
git submodule add https://github.com/SeonminKim1/ai-shared-dev-toolkit.git .claude
```

| 명령 | 하는 일 |
|---|---|
| [`/sdd-init-fastapi`](#-sdd) | 새 FastAPI 프로젝트 뼈대 생성 (`/sdd-feat` 전에 1회) |
| [`/sdd-feat <기능 설명>`](#-sdd) | SDD(PRD → SPEC → PLAN → TASK → IMPLEMENT)로 기능 추가·수정 |
| [`/sdd-speckit-specify <기능 설명>`](#-sdd-spec-kit-기반) | spec-kit 기반 SDD(specify → clarify → plan → tasks → analyze → implement → converge)로 기능 추가·수정 |
| [`/learning-examples <라이브러리>`](#-learning-examples) | 라이브러리 학습용 예제를 계획하고 단계별로 작성 |
| [`/tistory-post <slug>`](#-tistory-post) | 소재로 티스토리 붙여넣기용 글 생성 (개인용, macOS) |

<br>

## 📚 SDD

문서(spec)를 먼저 정하고 코드를 작성하는 SDD(Spec-Driven Development) 방식으로, 기능을 PRD → SPEC → PLAN → TASK → IMPLEMENT 순서로 진행한다.

```sh
# 1. 뼈대·CLAUDE.md·README 생성 (최초 실행)
/sdd-init-fastapi

# 2. 기능마다
/sdd-feat 유저가 주문을 생성한다. (api-order-create/가 생성됨)

# 3. 기존 기능 업데이트
/sdd-feat api-order-create 쿠폰 필드 추가
```

단계별 설명 · 파일 구성 · 다른 언어 추가는 [skills/sdd-feat/README.md](skills/sdd-feat/README.md) 참고

<br>

## 📚 SDD (spec-kit 기반)

[GitHub spec-kit](https://github.com/github/spec-kit)의 단계·산출물을 따르고 본문은 이 툴킷 규칙으로 다시 쓴 SDD. `specify` CLI 없이 동작하며 문서는 `specs/NNN-<이름>/`에 쌓인다. 한 프로젝트에서는 `sdd-feat`와 둘 중 하나만 쓴다.

```sh
/sdd-speckit-specify 유저가 주문을 생성한다.   # specs/004-api-order-create/ + 브랜치
/sdd-speckit-clarify → /sdd-speckit-plan → /sdd-speckit-tasks → /sdd-speckit-analyze
/sdd-speckit-implement ↔ /sdd-speckit-converge   # 수렴할 때까지
```

upstream과 다른 점 · 파일 구성 · sdd-feat 문서 옮기기는 [skills/sdd-speckit/README.md](skills/sdd-speckit/README.md) 참고

<br>

## 📚 learning-examples

새 라이브러리 학습용 예제(`ex1.*`, `ex2.*` …)를 계획하고, 피드백을 받으며 몇 개씩 작성한다.

```
/learning-examples <라이브러리>
```

<br>

## 📚 tistory-post

소재(.md/PDF)를 "잉여개발자" 블로그 문체의 티스토리 글로 만든다. (개인용, macOS)

```
/tistory-post <slug>
```

소재 넣는 법 · 붙여넣기 · 훅 연결 방식은 [skills/tistory-post/README.md](skills/tistory-post/README.md) 참고

<br>

## 🔄 업데이트

```sh
git submodule update --remote .claude
```

갱신 후 `.claude/`가 modified로 보이는 건 서브모듈이 가리키는 커밋이 바뀐 것이라 정상<br>
서브모듈이 있는 프로젝트를 처음 clone할 때는 `git clone --recurse-submodules`를 사용

Claude를 켤 때 자동으로 갱신하려면 [hooks/README.md](hooks/README.md)를 참고한다.

<br>

## 🤝 기여

다른 프로젝트에서 쓰다가 고칠 게 생기면 그 자리에서 바로 PR을 보낸다.

```sh
cd .claude
git switch -c improve/<내용>   # 브랜치 먼저 (안 하면 커밋 유실 위험)
git commit -am "<설명>" && git push -u origin HEAD && gh pr create
```

```
skills/<이름>/   스킬 (SKILL.md + 전용 hooks/, scripts/)
stacks/          스택별 코드 규칙 (각 프로젝트 CLAUDE.md가 import)
hooks/           공용 훅 (~/.claude/settings.json에 등록)
settings.json    권한만 (uv·gradlew·gh 허용, 위험 명령 차단). 개인용
```

폴더별 작성 규칙은 [CONTRIBUTING.md](CONTRIBUTING.md) 참고
