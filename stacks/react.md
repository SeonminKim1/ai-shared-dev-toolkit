# React 스택 규칙

언어와 무관한 SDD 방법론(`.claude/skills/sdd-feat/process.md` 또는 `.claude/skills/sdd-speckit/process.md`)에 React + TypeScript(Vite) 프론트엔드 규칙을 더한 스택 파일이다. 소비 프로젝트의 `CLAUDE.md`가 `@.claude/stacks/react.md`로 import한다. **같은 스택의 어느 프로젝트에도 맞는 내용만** 둔다. 이 프로젝트에만 해당하는 화면·요구사항·스타일링 방식은 `CLAUDE.md`에 둔다.

> Vite + React + TypeScript, npm, oxlint·Prettier, Vitest·React Testing Library 기준이다.

- **SDD**: 기능 추가·수정은 `/sdd-feat`(`.claude/skills/sdd-feat/process.md`) 또는 `/sdd-speckit-specify`부터(`.claude/skills/sdd-speckit/process.md`) 진행한다. 기능 문서가 `docs/<feature-name>/`에 있으면 sdd-feat, `specs/NNN-<이름>/`에 있으면 sdd-speckit 방식이다. spec 없이 구현하지 않고, spec·plan에 없는 상황은 추측하지 말고 묻는다.
- **새 프로젝트**: `src/`가 없으면 `/sdd-init-react`로 먼저 뼈대를 만든다.
- **기능 접두사**: 화면·UI 기능은 `ui-`, 화면 없는 순수 로직·데이터 모델은 `domain-`, 빌드 타임 스크립트·Worker는 `component-`. 백엔드 API를 함께 만들면 그 API는 백엔드 스택 프로젝트에서 `api-`로 다룬다.

## 스택 연결 값
SDD 방법론(`process.md`)의 단계에서 스택마다 달라지는 값이다.

| 항목 | 값 |
|---|---|
| **레이어** | Page → Hook → Lib / Data (아래 "레이어드 아키텍처"). PLAN "변경 파일"은 `src/types/`, `src/errors/`, `src/data/`, `src/lib/`, `src/hooks/`, `src/components/`, `src/pages/`, `src/App.tsx` / `src/main.tsx`, `scripts/` 순서로 적는다 |
| **에러 표현** | `ErrorCode` 항목 / 사용자에게 보이는 처리(에러 화면, 토스트, 재시도 버튼 등) (아래 "Error Handling") |
| **TASK 기본 순서** | T1 types 정의 → T2 data 접근, T3 `ErrorCode` 항목 추가 → T4 lib 순수 로직 + 테스트 → T5 hook(상태·흐름) + 테스트 → T6 components·pages 연결 + 컴포넌트 테스트, 브라우저에서 정상/에러 상태 확인, 문서 갱신 |
| **컴포넌트 구동 위치** | 빌드 타임 작업은 `scripts/`(`npm run <이름>`, `tsx`로 실행), 브라우저 백그라운드 작업은 Web Worker·Service Worker |
| **확인 명령** | `npm run lint`, `npm run format`, `npm run typecheck`, `npm test`, `npm run build` |
| **동작 확인 방법** | `npm run dev`로 띄워 브라우저에서 spec의 화면 상태·사용자 동작을 직접 재현한다. 데이터 요청은 DevTools Network 탭에서 확인 |
| **데이터 변경** | 정적 데이터 파일(`public/` 아래 JSON 등)의 구조, `localStorage`·`IndexedDB`의 키와 형식, 이미 저장된 데이터와의 호환(버전 키 등) |
| **엣지 케이스** | 탭 전환·백그라운드에서 타이머·애니메이션, 새로고침·뒤로가기 때 진행 상태, 언마운트 뒤 도착한 비동기 결과, 연타·중복 클릭, 느린 네트워크·오프라인, 360px 폭·키보드 조작. 코드에서는 effect cleanup(타이머·구독 해제), `AbortController`, 상태 전이를 reducer 한 곳에 모으는 방식으로 지킨다 |
| **README 갱신 대상** | README의 화면 표(경로, 설명) |
| **추가 완료 항목** | `npm run preview`로 빌드 결과 확인, 모바일 폭(360px)과 데스크톱에서 레이아웃 확인, 브라우저 콘솔에 에러·경고 없음 |

## TypeScript 규칙
- 패키지 관리·스크립트 실행은 `npm`만 쓴다(`yarn`/`pnpm` 혼용 금지). lint는 Vite 템플릿 기본 linter(지금은 oxlint), 포맷은 Prettier만 쓴다.
- `tsconfig`는 `strict: true`. `any`는 쓰지 않는다(불가피하면 `unknown` + 좁히기). `@ts-ignore` 금지, 꼭 필요하면 `@ts-expect-error <이유>`.
- export하는 함수는 반환 타입을 명시한다. 컴포넌트 props는 `<Name>Props` 타입으로 선언한다.
- 프로젝트에서 정의한 함수에 인자를 3개 이상 넘길 때는 객체 하나로 받는다(예: `buildChoices({ answer, pool, count })`). 위치만 보고 어느 값이 어느 인자인지 헷갈리지 않게 하기 위함이다.
- 검증 함수 이름: 틀리면 예외를 던지면 `validate<대상>`, 참/거짓만 돌려주면 `is<대상>`.
- 모든 export 함수·컴포넌트와 복잡한 로직에는 짧은 주석(JSDoc 한 줄)을 단다.
- 환경 변수는 `import.meta.env.VITE_*`만 쓰고, `src/data/`나 `src/config.ts` 한 곳에서 읽는다. 브라우저에 노출되므로 비밀 값은 넣지 않는다.

## 레이어드 아키텍처
화면 흐름은 **Page → Hook → Lib / Data** 순서를 따른다. 상태와 규칙을 컴포넌트 안에 직접 쓰지 않는다.

| 위치 | 역할 | 금지 |
|---|---|---|
| `src/pages/` | 화면(라우트) 단위: hook 하나를 호출하고 결과를 components로 조립 | 비즈니스 규칙, `data/` 직접 호출 |
| `src/components/` | 표시 전용: props를 받아 그리고 사용자 동작을 콜백으로 올린다. 열림/닫힘 같은 UI 지역 상태만 가진다 | `data/`·`hooks/`의 흐름 hook 호출, 비즈니스 규칙 |
| `src/hooks/` | 화면 상태와 흐름(`useReducer`, 타이머, 로딩·에러 상태). `lib/`의 규칙과 `data/`의 데이터를 연결 | JSX 반환 |
| `src/lib/` | 순수 도메인 로직(판정, 계산, 변환). 입력만으로 결과가 정해진다 | React·브라우저 API(`window`, `fetch`, `localStorage`) 사용 |
| `src/data/` | 데이터 접근: `fetch`, `localStorage`, 외부 SDK 래퍼. 결과를 `types/`의 모델로 바꿔 돌려준다 | `hooks/`·`components/` import |
| `src/types/` | 여러 레이어가 함께 쓰는 도메인 모델·타입 | |
| `src/errors/` | `AppError`, `ErrorCode` (아래 "Error Handling") | |
| `src/App.tsx`, `src/main.tsx` | 엔트리포인트, 라우팅, 최상위 Provider·ErrorBoundary 등록 | |
| `scripts/` | 빌드 타임 스크립트(데이터 생성 등). 생성 결과는 손으로 고치지 않는다 | `src/`의 React 코드 import |

- 상태는 `useState`·`useReducer`를 기본으로 한다. 여러 화면이 공유하는 상태가 생기면 Context나 상태 라이브러리 도입을 PLAN에서 결정한다.
- 외부 SDK(광고, 분석 등)는 `data/<name>Client.ts` 하나로 감싸고, 다른 곳은 그 모듈을 통해서만 쓴다.

**파일 이름**
| 위치 | 파일 이름 | 예 |
|---|---|---|
| `src/pages/` | `<Name>Page.tsx` | `QuizPage.tsx` |
| `src/components/` | `<Name>.tsx` (PascalCase) | `TimerBar.tsx` |
| `src/hooks/` | `use<Name>.ts` | `useQuizRound.ts` |
| `src/lib/` | `<대상>.ts` (camelCase) | `answerJudge.ts` |
| `src/data/` | `<대상>Repository.ts`, 외부 SDK는 `<name>Client.ts` | `quizRepository.ts`, `adsenseClient.ts` |
| 테스트 | 대상 파일 옆 `<대상 파일 이름>.test.ts(x)` | `answerJudge.test.ts` |

## 테스트
- Vitest로 작성하고 `npm test`로 실행한다.
- **lib 테스트가 핵심이다.** 비즈니스 규칙(판정, 점수, 제한 시간 등)마다 정상/에러 케이스를 하나 이상 둔다.
- hook은 `renderHook`으로 상태 전이를 확인한다. 시간에 따른 동작은 `vi.useFakeTimers()`로 돌린다. `data/`는 `vi.mock`이나 가짜 객체로 대체하고 실제 네트워크에 붙지 않는다.
- 컴포넌트는 React Testing Library로 사용자 관점(role, 보이는 텍스트, `userEvent`)에서만 확인한다. 내부 state·클래스 이름은 검사하지 않는다.

## Error Handling
- 예상한 에러는 `throw new AppError(ErrorCode.XXX)`로 던진다. `ErrorCode` 각 항목은 `{ code, message }`를 가지며 `message`는 사용자에게 보여 줄 문구다.
- `data/`가 네트워크·파싱 실패를 `AppError`로 바꾼다. hook은 이를 잡아 `error` 상태로 노출하고, page가 spec에 적힌 사용자 처리(에러 화면, 재시도 등)를 그린다.
- 예상하지 못한 렌더링 에러는 `App.tsx`의 최상위 ErrorBoundary가 받아 공통 에러 화면을 보여 준다. 컴포넌트마다 `try/catch`로 삼키지 않는다.
