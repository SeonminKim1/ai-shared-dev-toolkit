---
name: sdd-init-react
description: 빈 프로젝트에 React + TypeScript(Vite) 프론트엔드 뼈대와 SDD용 CLAUDE.md·README를 만든다. SDD 방식(`sdd-feat` 또는 spec-kit 기반 `sdd-speckit`)을 골라 그에 맞게 세팅한다. 새 React 프로젝트를 시작하거나 "템플릿대로 세팅해줘"라고 할 때, 첫 기능(`/sdd-feat`·`/sdd-speckit-specify`)을 시작하기 전에 사용.
---

# /sdd-init-react

새 React 프로젝트를 한 번 세팅하는 절차다. 평소 코드 규칙은 `.claude/stacks/react.md`, SDD 진행은 2번에서 고른 방식의 스킬이 맡는다. 아래 단계를 순서대로 **모두** 수행한다(`CLAUDE.md`만 만들고 끝내지 않는다). SDD 방식별 값(스킬 폴더, 방법론, 첫 명령, 기능 문서, 기능 요구사항 위치)은 `.claude/skills/sdd-init-fastapi/SKILL.md` 맨 위 표를 따른다.

1. **확인**: `.claude/stacks/react.md`와 `.claude/skills/sdd-feat/`·`.claude/skills/sdd-speckit/`가 있는지 본다. 없으면 `git submodule update --init`을 안내하고 멈춘다. `node -v`(20.19+ 또는 22.12+)와 `npm -v`를 확인하고, 없으면 설치를 안내하고 멈춘다. `package.json`이나 `src/`가 이미 있으면 덮어쓰지 말고 무엇을 할지 묻는다.
2. **질문 한 번에 하기**(AskUserQuestion): SDD 방식(`sdd-speckit` / `sdd-feat`) / 서비스 이름과 한 줄 설명 / 화면이 여러 개라 라우팅이 필요한지(필요 → `react-router`) / 배포 대상(Netlify, Cloudflare Pages, Vercel, 미정) / 이슈 트래커: GitHub Project owner·Project 번호(없음 가능. 있으면 `gh project view <번호> --owner <owner>`로 제목 확인).
3. **Vite 프로젝트 생성**: 현재 디렉터리에 다른 파일(`.claude/`, 기획 문서 등)이 있어도 되도록 임시 폴더에 만들어 옮긴다.
   - `npm create vite@latest .sdd-init-tmp -- --template react-ts --no-interactive` → `.sdd-init-tmp/`의 파일(숨김 파일 포함)을 루트로 옮기고 임시 폴더를 지운다. 같은 이름의 파일이 루트에 있으면 덮어쓰지 말고 합친다(`.gitignore`는 줄 합치기, `README.md`는 8번에서 다시 쓴다).
   - 데모 파일 삭제: `src/App.css`, `src/assets/`, `public/`의 템플릿 아이콘(`favicon.svg`, `icons.svg` 등). `index.html`은 `lang="ko"`, `<title>`을 서비스 이름으로 바꾸고 favicon `<link>` 줄을 지운다.
   - `npm install` (npm 11+의 install-scripts 경고(`esbuild`, `fsevents`)는 승인하지 않아도 동작한다)
   - `npm install -D prettier vitest jsdom @testing-library/react @testing-library/dom @testing-library/jest-dom @testing-library/user-event tsx`
   - 라우팅이 필요하면 `npm install react-router`
4. **설정**
   - scripts(`npm pkg set`으로): `lint`=`oxlint --deny-warnings`(경고도 실패로 본다), `format`=`prettier --write .`, `format:check`=`prettier --check .`, `typecheck`=`tsc -b`, `test`=`vitest run`, `test:watch`=`vitest`. `dev`·`build`·`preview`는 템플릿 값을 그대로 둔다.
   - `vite.config.ts`: `files/vite.config.ts`로 바꾼다(`defineConfig`를 `vitest/config`에서 가져와 `test` 설정을 둔다).
   - `.oxlintrc.json`: `"ignorePatterns": [".claude", "dist"]`를 더한다. lint 도구는 템플릿 기본값(지금은 oxlint)을 따른다. 템플릿이 ESLint를 주면 `eslint.config.js`의 `globalIgnores`에 `'.claude'`를 더하고 `eslint-config-prettier`를 붙인다.
   - `tsconfig.node.json`의 `include`에 `"scripts"`를 더한다(빌드 타임 스크립트도 `typecheck` 대상).
   - `.prettierrc.json`: `{ "singleQuote": true }` / `.prettierignore`: `dist`, `.claude`, `package-lock.json`
5. **디렉터리와 기본 코드**: `.claude/stacks/react.md` "레이어드 아키텍처" 표의 디렉터리(`src/pages/`, `src/components/`, `src/hooks/`, `src/lib/`, `src/data/`, `src/types/`, `src/errors/`, `scripts/`)를 만든다. 빈 디렉터리에는 `.gitkeep`을 둔다. 이 스킬의 `files/`를 복사한다.
   - `files/AppError.ts` → `src/errors/AppError.ts`
   - `files/ErrorBoundary.tsx` → `src/components/ErrorBoundary.tsx`
   - `files/HomePage.tsx` → `src/pages/HomePage.tsx` (`<서비스 이름>`을 바꾼다)
   - `files/App.tsx` → `src/App.tsx`, `files/main.tsx` → `src/main.tsx`, `files/index.css` → `src/index.css`
   - `files/App.test.tsx` → `src/App.test.tsx` (스모크 테스트), `files/setup.ts` → `src/test/setup.ts`
   - 라우팅이 필요하면 `App.tsx`에 `BrowserRouter`·`Routes`로 `HomePage`를 `/`에 등록하고, Netlify·Cloudflare Pages면 `public/_redirects`에 `/* /index.html 200`을 둔다.
6. **`.gitignore`**: 템플릿 내용에 `.env*`, `!.env.example`, `.DS_Store`, `.sdd-init-tmp/`를 더한다.
7. **`CLAUDE.md`**: `.claude/skills/sdd-init-fastapi/SKILL.md` 7번 틀을 쓰되, 첫 문단의 "FastAPI"를 "React"로, import를 `@.claude/stacks/react.md`로, 프로젝트 개요의 스택을 `React + TypeScript(Vite) + <라우팅·외부 SDK>, <배포 대상> 배포`로 바꾼다. 스타일링 방식(기본: CSS Modules)도 개요에 적는다.
8. **`README.md`**
   ```markdown
   # <서비스 이름>
   <서비스 한 줄 설명>

   ## 요구 사항
   - Node.js 20.19+ (또는 22.12+), npm

   ## 실행
   git submodule update --init   # .claude (ai-shared-dev-toolkit)
   npm install
   npm run dev
   → http://localhost:5173

   ## 환경 변수
   | 이름 | 기본값 | 설명 |
   (`VITE_` 접두사만 브라우저에 노출된다. 비밀 값은 넣지 않는다)

   ## 화면
   | 경로 | 설명 |
   (기능을 구현할 때마다 추가)

   ## 개발
   npm run lint / npm run format / npm run typecheck
   npm test
   npm run build && npm run preview
   - 코드 규칙: .claude/stacks/react.md
   - 개발 프로세스(SDD): <방식 방법론> — 기능은 <방식 첫 명령>으로 진행
   - 배포: <배포 대상> (빌드 명령 `npm run build`, 출력 폴더 `dist`)
   ```
9. **확인**: `npm run lint`, `npm run format`, `npm run typecheck`, `npm test`, `npm run build`가 모두 통과해야 한다.
10. **보고**: 만든 파일 목록, 고른 SDD 방식, 다음 할 일("`<방식 첫 명령>`으로 첫 기능 시작")을 알려준다.
