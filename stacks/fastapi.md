# FastAPI 스택 규칙

`.claude/skills/sdd-feat/process.md`(언어와 무관한 SDD 방법론)에 FastAPI + Python 규칙을 더한 스택 파일이다. 소비 프로젝트의 `CLAUDE.md`가 `@.claude/stacks/fastapi.md`로 import한다. **같은 스택의 어느 프로젝트에도 맞는 내용만** 둔다. 이 프로젝트에만 해당하는 모듈·요구사항은 `CLAUDE.md`에 둔다.

- **SDD**: 기능 추가·수정은 `/sdd-feat`(`.claude/skills/sdd-feat/process.md`의 단계)로 진행한다. spec 없이 구현하지 않고, spec·plan에 없는 상황은 추측하지 말고 묻는다.
- **새 프로젝트**: `src/`가 없으면 `/sdd-init-fastapi`으로 먼저 뼈대를 만든다.

## 스택 연결 값
`.claude/skills/sdd-feat/process.md`의 단계에서 스택마다 달라지는 값이다.

| 항목 | 값 |
|---|---|
| **레이어** | Router → Service → Repository (아래 "레이어드 아키텍처"). PLAN "변경 파일"은 `src/schemas/`, `src/models/`, `src/repository/`, `src/services/`, `src/routers/`, `src/core/` / `src/main.py` 순서로 적는다 |
| **에러 표현** | `ErrorEnum` 항목 / 상태 코드 (아래 "Error Handling") |
| **TASK 기본 순서** | T1 models/schemas 정의 → T2 repository 쿼리, T3 `ErrorEnum` 항목 추가 → T4 service 로직 + service 테스트 → T5 router 연결(컴포넌트는 lifespan 등록), 정상/에러 케이스 확인, 문서 갱신 |
| **컴포넌트 구동 위치** | FastAPI lifespan 백그라운드 태스크 |
| **확인 명령** | `uv run ruff check .`, `uv run ruff format .`, `uv run pytest` |
| **API 확인 방법** | 서버의 `/docs`(Swagger UI)에서 직접 호출, `/redoc`에서 문서 확인 |
| **추가 완료 항목** | `/redoc`에서 요청·응답 example이 실제 값으로 보이는지 확인 (아래 "API 문서 (OpenAPI)") |

## Python 규칙
- 패키지 관리·가상환경·스크립트 실행은 `uv`만 쓴다(`pip`/`venv` 금지).
- lint·포맷은 `ruff`만 쓴다(`black`/`flake8`/`isort` 금지).
- 타입 힌트 필수. 모든 public 함수는 return type을 명시한다.
- 함수/변수는 snake_case.
- 프로젝트에서 정의한 함수에 인자를 3개 이상 넘길 때는 키워드 인자로 쓴다(예: `service.list_jobs(owner_id=..., limit=..., cursor=..., status=...)`). 위치만 보고 어느 값이 어느 인자인지 헷갈리지 않게 하기 위함이다. 표준·외부 라이브러리 호출(`datetime(...)`, `monkeypatch.setattr(...)` 등)은 제외한다. 함수를 담는 dict·변수의 타입은 `Callable` 대신 인자 이름이 있는 `Protocol`로 둔다(`Callable`은 키워드 호출을 표현하지 못한다).
- 검증 함수 이름: 틀리면 예외를 던지는 함수는 `validate_<대상>`(예: `validate_user_id`), 참/거짓만 돌려주는 함수는 `is_<대상>`(예: `is_user_id`).
- 모든 함수와 복잡한 로직에는 짧지만 빠른 이해에 도움이 되는 주석을 단다.
- `models/`·`schemas/`의 Pydantic 필드에는 `Field(description=...)`로 설명을 단다(의미, 형식·제약, 누가 값을 정하는지). `schemas/`의 설명은 `/docs`에 그대로 노출된다.

## 테스트
- `pytest`로 작성하고 `uv run pytest`로 실행한다. 테스트 파일은 `tests/test_<대상>.py`.
- **service 테스트가 핵심이다.** 비즈니스 규칙(쿼터, 소유권, 상태 전이 등)마다 정상/에러 케이스를 하나 이상 둔다. repository·외부 클라이언트는 `monkeypatch`나 가짜 객체로 대체하고 실제 DB/외부 시스템에 붙지 않는다.
- router 테스트는 `fastapi.testclient.TestClient`로 상태 코드와 응답 형태만 확인한다.
- async 함수는 `async def test_...`로 그대로 쓴다(`asyncio_mode = "auto"`).

## 레이어드 아키텍처
요청 흐름은 반드시 **Router → Service → Repository** 순서를 따른다. "간단한" 엔드포인트라도 레이어를 건너뛰지 않는다.

| 위치 | 역할 | 금지 |
|---|---|---|
| `src/routers/` | HTTP 계층만: 요청 파싱 → `services/` 함수 하나 호출 → 결과 반환 | 비즈니스 로직, `repository/`·외부 클라이언트 직접 호출, raw dict·`models/` 객체 반환 |
| `src/schemas/` | 라우터의 요청/응답 Pydantic 모델. 리소스당 요청·응답 모듈을 나눈다(`routers/<name>_router.py` ↔ `schemas/<name>_request.py`·`schemas/<name>_response.py`). 여러 라우터가 함께 쓰는 것은 `common_request.py`(공통 헤더 등)·`error_response.py`(에러 응답). 모델만으로 검증할 수 없는 요청 파싱(예: 같은 쿼리 중복 지정 거절)은 그 요청 모듈에 dependency 함수로 두고, 결과를 요청 모델로 돌려준다 | 라우터가 참조하는 모델은 이것뿐 |
| `src/services/` | 비즈니스 로직(검증/변환). 영속화는 `repository/`로, 외부 클라이언트는 직접 호출. 도메인 객체 또는 완성된 응답 객체 반환 | `routers/` import |
| `src/repository/` | DB 접근(쿼리/CRUD)만 | `routers/`·`services/` 호출 |
| `src/models/` | 내부/도메인 모델, DB document 모델(`schemas/`와 구분). 도메인 하나의 모델은 `<도메인>_models.py`(아래 "파일 이름") | |
| `src/core/` | 공통 인프라: DB 연결(`core/db`), 예외(`core/exception`) 등 | |
| `src/core/dependencies.py` | service·repository·외부 래퍼의 실제 객체 조립(아래 "의존성 주입") | |
| `src/main.py` | 앱 엔트리포인트(`app = FastAPI()`), 라우터·예외 핸들러 등록 | |

**파일 이름**: 파일 이름만 보고 레이어와 역할을 알 수 있게 접미사를 붙인다. `<name>`은 snake_case 단수(예: `job`, `user_job`).

| 위치 | 파일 이름 | 예 |
|---|---|---|
| `src/routers/` | `<name>_router.py` | `job_router.py` |
| `src/schemas/` | `<name>_request.py`, `<name>_response.py` | `job_request.py`, `job_response.py` |
| `src/services/` | `<name>_service.py` (비즈니스 로직 클래스, 외부 시스템 래퍼) | `user_job_service.py`, `k8s_service.py` |
| `src/repository/` | `<name>_repository.py` | `user_job_repository.py` |
| `src/models/` | `<도메인>_models.py`: DB document 모델과 그 도메인에 딸린 모델(입력 템플릿, 페이지 등)을 함께 둔다. 도메인 이름은 컬렉션 이름의 단수 | `user_job_models.py` (컬렉션 `user_jobs`) |
| `tests/` | `test_<대상 모듈 이름>.py` | `test_user_job_models.py` |

- 접미사 규칙의 예외: 여러 도메인이 함께 쓰는 정의는 내용으로 이름 짓는다(`models/enums.py`, `models/k8s_names.py`). 클래스·주입 없이 import하는 순수 함수 모듈은 `<대상>_<역할>.py`로 짓는다(`services/job_templates.py`, `services/job_cursor.py`). 이 경우 `_service`를 붙이지 않는다(주입하는 service 클래스와 구분).

- 외부 시스템 클라이언트는 `services/<name>_service.py`의 클래스 하나로 감싸고, 다른 service는 그 클래스를 통해서만 호출한다.
- 라우터가 없는 백그라운드 컴포넌트(watch, 스케줄러 등)도 DB는 `repository/`, 외부 시스템은 래퍼 클래스를 통해서만 접근한다.

## 의존성 주입
- service·repository·외부 시스템 래퍼는 클래스로 만들고 의존 객체를 생성자로 받는다. 다른 클래스를 안에서 직접 만들지 않는다.
- 실제 객체는 `src/core/dependencies.py`에서만 조립한다. API는 FastAPI `Depends`로, 백그라운드 컴포넌트는 lifespan에서 받는다.
- 테스트는 가짜 객체를 생성자로 주입한다.
- 예외: DB·외부 시스템 의존이 없고 입력만으로 결과가 정해지는 순수 함수 모듈은 클래스·주입 없이 직접 import한다(가짜로 바꿀 이유가 없으므로).

## API 문서 (OpenAPI)
`/docs`(Swagger UI)와 `/redoc`(ReDoc)에서 요청·응답이 실제 값으로 보이게 한다. 스키마만 두면 ReDoc이 `"string"`, `0` 같은 의미 없는 샘플을 만든다.
- **요청 body**: `Body(openapi_examples={...})`로 대표 입력을 이름 붙여 둔다(예: 필수 필드만, 모든 필드).
- **헤더·쿼리 파라미터**: `Header(...)`·`Query(...)`에도 `openapi_examples`를 둔다.
- **정상 응답**: `responses={<상태 코드>: {"content": {"application/json": {"example": ...}}}}`.
- **에러 응답**: 엔드포인트마다 나열하지 않는다. `schemas/error_response.py`에 400·500(필요하면 404) 응답 문서(`ErrorResponse` 모양 + 대표 example 하나)를 두고 `APIRouter(responses=...)`로 라우터마다 한 번만 붙인다.
  - 엔드포인트별 에러 code 목록의 기준은 `docs/<feature-name>/spec.md`의 에러 표다. `/docs`에는 엔드포인트 `description`에 그 경로만 적는다(같은 목록을 코드·테스트에 다시 쓰지 않는다).
  - 전역 핸들러의 500 본문은 핸들러와 문서가 같은 상수를 쓴다.
- example 값은 해당 schema 모듈(요청 example은 `schemas/<name>_request.py`, 응답 example은 `schemas/<name>_response.py`)에 상수로 두고 라우터가 연결만 한다.
- **테스트로 어긋남을 막는다**: 요청 example을 실제로 보내 정상 응답이 나는지, 응답 example이 응답 schema로 검증되는지 확인한다.

## Error Handling
- 모든 비즈니스 에러는 `MyApiError(ErrorEnum.XXX)`로 던진다. `ErrorEnum` 각 항목은 `(code, status_code, message)`를 가진다.
- 예외 핸들러는 `main.py`에 등록한다.
  - `MyApiError` → `{code, message}` JSON + enum에 지정된 상태 코드
  - DB 에러 → 500
  - 기타 `Exception` → 500 (`unknown_error`)
- 500은 전역 예외 핸들러만 응답한다. 기본 코드는 `.claude/skills/sdd-init-fastapi/files/`.
