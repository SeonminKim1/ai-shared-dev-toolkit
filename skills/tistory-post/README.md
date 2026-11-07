# tistory-post

사람이 읽는 메모. Claude는 `SKILL.md`만 읽는다.

## 사용법

```
/tistory-post <slug>
```

소재는 `topics/`에, 결과는 `posts/<slug>/`에 생기며 두 폴더는 자동으로 만들어진다.

**소재 추가** : `topics/<slug>/01.md`, `02.md` …를 넣고 "소재 추가했어"<br>
**붙여넣기** : 미리보기의 `복사` 버튼 → 티스토리 기본모드에 Cmd+V (제목·태그는 `meta.md`)<br>
**자동 검사** : 글을 저장할 때마다 훅이 서식을 검사하고 미리보기를 갱신<br>
**권장** : `.gitignore`에 `posts/*/preview.html` 추가

<br>

## 구조

```
SKILL.md       지침 + frontmatter에 훅 등록
hooks/         하네스가 실행 (직접 실행 X)
  on-post-edit.sh
scripts/       Claude(또는 사람)가 실행하는 도구
  preview.sh   post.html → preview.html (복사 버튼)
  copy.sh      클립보드 복사 ("복사해줘" 할 때만)
  render-image.sh  흐름도 SVG → PNG (macOS, Chrome 헤드리스 + sips)
types/ templates/ samples/ reference/   유형별 지침·HTML 뼈대·예시 글 (reference/diagram.md: 이미지 스타일)
```

<br>

## 훅 연결 고리
1. `/tistory-post <slug>`로 스킬이 켜지면 frontmatter의 훅이 등록된다 (등록 후 세션이 끝날 때까지 유지).
2. Claude가 `posts/<slug>/post.html`을 Write/Edit 하면 `on-post-edit.sh`가 실행된다. 훅의 `if` 필터 때문에 다른 파일을 Write/Edit 할 때는 실행되지 않는다. 같은 세션에서 다른 스킬을 쓸 때도 마찬가지다.
3. 서식 규칙(이모지, ul/ol 중첩, li 안 `<br />- ` 하위 줄 5개 이상, h2·ul·ol·table 외 인라인 스타일) 위반 → exit 2 → Claude가 메시지를 받고 고친다.
4. 통과 → `scripts/preview.sh` 호출로 미리보기 갱신 (처음 생성이면 브라우저로 열림, 이후엔 새로고침).

- 스킬 없이 post.html을 고치거나 셸로 고치면 훅이 돌지 않는다. 항상 `/tistory-post`로 시작하고 Edit/Write로 고칠 것. 수동 갱신은 `scripts/preview.sh <slug>`.
- 훅은 미리보기를 첫 생성 때만 연다. 수정 후에는 스킬 지침에 따라 Claude가 응답 끝에 한 번 연다.
- 훅 경로는 `$CLAUDE_PROJECT_DIR/.claude/...` 기준이라 이 저장소가 `.claude` 서브모듈로 붙어 있어야 동작한다.
- 검사 규칙을 바꾸면 `SKILL.md` 작성 원칙과 같이 맞춘다.
