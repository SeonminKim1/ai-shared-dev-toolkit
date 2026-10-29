# ai-shared-dev-toolkit
프로젝트에 `.claude` 서브모듈로 붙여 쓰는 AI 개발 자산(Skills, Hooks) 모음. Claude Code, Cursor에서 사용.

| 자산 | 종류 | 설명 |
|---|---|---|
| [learning-examples](#learning-examples) | Skill | 새 라이브러리 학습용 예제를 계획하고 단계별로 작성 |
| [tistory-post](#tistory-post) | Skill | 소재로 티스토리 붙여넣기용 글 생성 (개인용, macOS) |

## 설치

```sh
git submodule add https://github.com/SeonminKim1/ai-shared-dev-toolkit.git .claude
git submodule update --remote .claude   # 업데이트
```

- clone할 때는 `git clone --recurse-submodules`
- 프로젝트 전용 지침은 `.claude/`가 아닌 루트 `CLAUDE.md`에 둔다
- 자산 추가 규칙: [CONTRIBUTING.md](CONTRIBUTING.md)

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
- 스크립트: `.claude/skills/tistory-post/scripts/preview.sh <slug>`, `copy.sh [--html] <slug>`
- `.gitignore`: `posts/*/preview.html`
