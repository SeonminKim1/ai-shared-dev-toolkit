---
name: fastapi-init
description: 빈 프로젝트에 FastAPI + Python(uv) 백엔드 뼈대와 SDD용 CLAUDE.md·README를 만든다. 새 FastAPI 프로젝트를 시작하거나 "템플릿대로 세팅해줘"라고 할 때, `/feat`로 첫 기능을 시작하기 전에 사용.
---

# /fastapi-init

새 FastAPI 프로젝트를 한 번 세팅하는 절차다. 평소 코드 규칙은 `.claude/stacks/fastapi.md`, SDD 진행은 `/feat`가 맡는다. 아래 단계를 순서대로 **모두** 수행한다(`CLAUDE.md`만 만들고 끝내지 않는다).

1. **확인**: `.claude/stacks/fastapi.md`와 `.claude/skills/feat/`가 있는지 본다. 없으면 `.claude` 서브모듈이 초기화되지 않은 것이므로 `git submodule update --init`을 안내하고 멈춘다. `src/`가 이미 있으면 덮어쓰지 말고 무엇을 할지 묻는다.
2. **질문 한 번에 하기**(AskUserQuestion): 서비스 한 줄 설명 / DB(MongoDB, PostgreSQL, 없음) / 연동할 외부 시스템(없음 가능) / 이슈 트래커: GitHub Project owner·Project 번호(없음 가능. 있으면 `gh project view <번호> --owner <owner>`로 제목 확인).
3. **uv 프로젝트 생성**
   - `uv init --bare --python 3.11` (이미 `pyproject.toml`이 있으면 생략)
   - `uv add fastapi uvicorn` / `uv add --dev ruff pytest pytest-asyncio httpx2` (최신 Starlette의 TestClient는 `httpx2`를 쓴다)
   - DB 드라이버: MongoDB → `uv add pymongo`, PostgreSQL → `uv add sqlalchemy asyncpg`
   - `pyproject.toml`에 추가:
     ```toml
     [tool.uv]
     package = false

     [tool.pytest.ini_options]
     pythonpath = ["."]
     testpaths = ["tests"]
     asyncio_mode = "auto"
     ```
4. **디렉터리 생성**: `.claude/stacks/fastapi.md` "레이어드 아키텍처" 표의 디렉터리를 만들고 각각 `__init__.py`를 둔다(`src/`, `src/core/db/`, `src/core/exception/` 포함). `tests/`도 만든다(`__init__.py` 없음).
5. **기본 코드**: 이 스킬의 `files/`를 복사한다.
   - `files/my_exception.py` → `src/core/exception/my_exception.py`
   - `files/main.py` → `src/main.py`
   - `files/test_main.py` → `tests/test_main.py` (스모크 테스트)
   - `src/core/db/<db>.py`: 선택한 DB의 연결 모듈. 접속 정보는 환경 변수에서 읽고 기본값은 localhost. DB가 없으면 생략.
   - 외부 시스템이 있으면 `src/services/<name>_service.py`에 빈 래퍼 클래스 하나.
6. **`.gitignore`**: `__pycache__/`, `*.py[oc]`, `.venv`, `.env`, `.ruff_cache/`, `.pytest_cache/`
7. **`CLAUDE.md`** (2번 답변으로 채운다)
   ```markdown
   # CLAUDE.md
   이 프로젝트에만 해당하는 내용만 둔다. 어느 FastAPI 프로젝트에도 맞는 규칙(레이어, 의존성 주입, 에러 처리, 테스트 등)은 아래 스택 파일에 있다.

   스택 규칙: @.claude/stacks/fastapi.md

   ## 프로젝트 개요
   <이 서비스가 무엇을 하는지 1~2줄>. 스택: FastAPI + <DB> + <외부 시스템>.

   ## 고유 모듈
   - <경로>: <역할 한 줄. 함께 고쳐야 하는 곳이 있으면 그것도>
   - 이슈 트래커: GitHub Project (`/feat`가 `.claude/skills/feat/github.md`로 연동, 비어 있으면 연동 안 함)
     - owner: `<owner>`
     - Project 번호: `<번호>`, 제목: `<제목>`
     (2번에서 "없음"이면 이 항목을 지운다)

   ## 서비스 요구사항
   - <서비스 전체에 걸친 비즈니스 규칙. 기능 단위 요구사항은 docs/<feature-name>/prd.md에 쓴다>
   ```
8. **`README.md`**
   ```markdown
   # <프로젝트 이름>
   <서비스 한 줄 설명>

   ## 요구 사항
   - Python 3.11+, uv, <DB>, <외부 시스템>

   ## 실행
   git submodule update --init   # .claude (ai-shared-dev-toolkit)
   uv sync
   uv run uvicorn src.main:app --reload
   → http://localhost:8000/docs

   ## 환경 변수
   | 이름 | 기본값 | 설명 |

   ## API
   | Method | Path | 설명 |
   (기능을 구현할 때마다 추가)

   ## 개발
   uv run ruff check . / uv run ruff format .
   uv run pytest
   - 코드 규칙: .claude/stacks/fastapi.md
   - 개발 프로세스(SDD): .claude/skills/feat/sdd-template.md
   ```
9. **확인**: `uv run ruff check .`, `uv run ruff format .`, `uv run pytest`가 모두 통과해야 한다.
10. **보고**: 만든 파일 목록과 다음 할 일("`/feat <기능 설명>`으로 첫 기능 시작")을 알려준다.
