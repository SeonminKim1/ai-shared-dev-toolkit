# ai-shared-dev-toolkit

개발·학습·글쓰기에 쓰는 AI 자산 모음. 어느 저장소든 .claude 서브모듈로 붙여 쓴다. (Claude Code)

```sh
git submodule add https://github.com/SeonminKim1/ai-shared-dev-toolkit.git .claude
```

| 명령 | 하는 일 |
|---|---|
| [`/sdd-init-fastapi`](#-sdd) | 새 FastAPI 프로젝트 뼈대 생성 + SDD 방식 선택 (첫 기능 전에 1회) |
| [`/sdd-speckit-specify <기능 설명>`](#-sdd) | spec-kit 기반 SDD로 기능 추가·수정 (이후 단계마다 `/sdd-speckit-<단계>`) |
| [`/sdd-feat <기능 설명>`](#-sdd) | 자체 5단계 SDD로 기능 추가·수정 (명령 하나로 진행) |
| [`/learning-examples <라이브러리>`](#-learning-examples) | 라이브러리 학습용 예제를 계획하고 단계별로 작성 |
| [`/tistory-post <slug>`](#-tistory-post) | 소재로 티스토리 붙여넣기용 글 생성 (개인용, macOS) |

<br>

## 📚 SDD

문서(spec)를 먼저 정하고 코드를 작성하는 SDD(Spec-Driven Development) 스킬. 방식이 두 가지이고, 한 프로젝트에서는 하나만 쓴다.

| | `sdd-speckit` | `sdd-feat` |
|---|---|---|
| 기반 | [GitHub spec-kit](https://github.com/github/spec-kit) 단계·산출물 (`specify` CLI 없이 동작) | 이 툴킷의 자체 방식 |
| 단계 | specify → clarify → plan → tasks → analyze → implement ↔ converge | PRD → SPEC → PLAN → TASK → IMPLEMENT |
| 명령 | 단계마다 `/sdd-speckit-<단계>` | `/sdd-feat` 하나로 진행 |
| 문서 위치 | `specs/NNN-<이름>/` | `docs/<feature>/` |
| 맞는 경우 | 산출물·점검(analyze, converge)을 꼼꼼히 남길 때. `/sdd-init-fastapi` 추천값 | 문서를 가볍게 유지할 때 |

```sh
# 0. 새 프로젝트면 먼저 1회: 뼈대·CLAUDE.md·README 생성, SDD 방식 선택
/sdd-init-fastapi

# sdd-speckit
/sdd-speckit-specify 유저가 주문을 생성한다.   # specs/004-api-order-create/ + 브랜치
/sdd-speckit-clarify → /sdd-speckit-plan → /sdd-speckit-tasks → /sdd-speckit-analyze
/sdd-speckit-implement ↔ /sdd-speckit-converge  # 수렴할 때까지
/sdd-speckit-specify 004 쿠폰 필드 추가          # 기존 기능 수정

# sdd-feat
/sdd-feat 유저가 주문을 생성한다.               # docs/api-order-create/
/sdd-feat api-order-create 쿠폰 필드 추가        # 기존 기능 수정
```

지원 스택은 **FastAPI**(init 스킬 포함), **Spring Boot**(규칙 초안), **React**(프론트엔드, init 스킬 없음)이며, 스택 규칙(`stacks/`)은 두 방식이 같이 쓴다.

- sdd-speckit: 단계별 산출물 · upstream과 다른 점 · sdd-feat 문서 옮기기 → [skills/sdd-speckit/README.md](skills/sdd-speckit/README.md)
- sdd-feat: 단계별 설명 · 파일 구성 · 다른 언어 추가 → [skills/sdd-feat/README.md](skills/sdd-feat/README.md)

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
skills/<이름>/   스킬 (SKILL.md + 전용 hooks/, scripts/). 여러 스킬이 같이 쓰는 파일은 SKILL.md 없는 폴더에 (예: skills/sdd-speckit/)
stacks/          스택별 코드 규칙 (각 프로젝트 CLAUDE.md가 import)
hooks/           공용 훅 (~/.claude/settings.json에 등록)
settings.json    권한만 (uv·gradlew·gh 허용, 위험 명령 차단). 개인용
```

폴더별 작성 규칙은 [CONTRIBUTING.md](CONTRIBUTING.md) 참고
