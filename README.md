# ai-shared-dev-toolkit
프로젝트 간 서브모듈로 공유 사용하는 AI 개발 자산(Hooks, Skills 등) 모음

| 자산 | 종류 | 한 줄 설명 |
|---|---|---|
| [learning-examples](#learning-examples) | Skill | 새 라이브러리 학습용 예제(`ex1`, `ex2` …)를 계획하고 단계별로 작성 |
| [tistory-post](#tistory-post) | Skill | 소재로 "잉여개발자" 티스토리 붙여넣기용 글 생성 (개인용, macOS) |

## 사용법

저장소 루트가 그대로 `.claude/` 내용이 되도록 구성되어 있다.

```sh
git submodule add https://github.com/SeonminKim1/ai-shared-dev-toolkit.git .claude

# 업데이트
git submodule update --remote .claude
```

clone 시에는 `git clone --recurse-submodules`, 이미 clone했다면 `git submodule update --init`.

### 지원 도구

- Claude Code: `.claude/skills`를 읽는다.
- Cursor: 호환 경로로 `.claude/skills`도 읽으므로 추가 작업 없이 스킬을 쓸 수 있다.

훅은 도구마다 설정 형식이 달라 현재 Claude Code 전용이다.

- 프로젝트 전용 스킬/설정은 `.claude/`에 두지 않는다 (서브모듈이 dirty 상태가 됨).
  프로젝트별 지침은 루트의 `CLAUDE.md`에 둔다.
- `settings.local.json`은 `.gitignore`로 제외되어 있다.

## 구조

```
skills/<스킬명>/SKILL.md   # → .claude/skills/...
hooks/                     # → .claude/hooks/...
```

자산 작성 규칙은 [CONTRIBUTING.md](CONTRIBUTING.md) 참고.

## Skills

### learning-examples
새 라이브러리를 익히기 위한 학습용 예제 모음(`ex1.*`, `ex2.*` ...)을 계획 → 단위별 작성 →
피드백 순으로 만들어 간다. 목차는 대상 프로젝트의 `README.md`에 유지된다.

- 사용: `/learning-examples <라이브러리>` 또는 "`<라이브러리>` 학습용 예제 만들어줘"

### tistory-post
소재(.md/PDF)를 주면 "잉여개발자" 블로그 문체·서식에 맞춘 티스토리 기본모드 붙여넣기용 본문을
만든다. 업로드는 직접 한다. 작업 폴더(프로젝트 루트)에 `topics/`, `posts/`를 쓴다. macOS 전용
(`open`, `pbcopy`, `osascript` 사용).

- 사용: `topics/`에 소재를 넣고 `/tistory-post <slug>` 또는 "글 써줘"
- 소재 형식은 자유. 선택 항목을 적으면 그대로 반영 (`유형`을 안 적으면 쓰기 전에 물어봄):
  ```markdown
  유형: 개념 / 실습 / 프로젝트 회고 / 개선기 / 트러블슈팅 / 자격증 후기 / 세미나·전시회 후기 / 요약 / 자료 공유
  카테고리: 개념 정리 / 개발 지식 정리
  제목: [키워드] 원하는 제목
  참고 링크: https://...
  ```
- 소재 위치: 한 번에 끝나는 글은 `topics/<slug>.md`. 나눠서 줄 글은 `topics/<slug>/01.md`, `02.md` …를
  추가하고 "소재 추가했어". PDF도 같은 폴더에 넣으면 됨 (요약은 `_digest.md`에 남아 재사용).
- 결과물: `posts/<slug>/post.html`(본문), `meta.md`(제목 후보·카테고리·태그·TODO). 생성 후 미리보기가
  열리고 `복사` 버튼 → 티스토리 **기본모드**에 Cmd+V
- 스크립트 (프로젝트 루트에서 실행):
  ```sh
  .claude/skills/tistory-post/scripts/preview.sh <slug>        # 미리보기 다시 열기
  .claude/skills/tistory-post/scripts/copy.sh <slug>           # 바로 복사 (= "복사해줘")
  .claude/skills/tistory-post/scripts/copy.sh --html <slug>    # HTML 소스 복사 → HTML 모드에 붙여넣기 (h2 스타일 유지)
  ```
- `topics/`, `posts/`는 실행한 프로젝트 루트에 없으면 자동 생성된다. 블로그 전용 저장소에서 쓰는 걸 권장하며,
  그 저장소의 `.gitignore`에는 생성물인 `posts/*/preview.html`만 넣는다. 다른 프로젝트에서 쓸 땐
  그 프로젝트의 `.gitignore`에 `topics/`, `posts/`를 추가한다.

## Hooks

(아직 없음)
