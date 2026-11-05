# Spring Boot 스택 규칙

`.claude/skills/sdd-feat/process.md`(언어와 무관한 SDD 방법론)에 Spring Boot + Java 규칙을 더한 스택 파일이다. 소비 프로젝트의 `CLAUDE.md`가 `@.claude/stacks/spring-boot.md`로 import한다. **같은 스택의 어느 프로젝트에도 맞는 내용만** 둔다.

> 가벼운 초안이다. Gradle(Kotlin DSL)·Spotless·springdoc-openapi 기준이며, 프로젝트가 다르면 "스택 연결 값"의 명령부터 맞춘다. 아직 `sdd-init-spring-boot` 스킬이 없으므로 새 프로젝트는 start.spring.io로 만들고, `CLAUDE.md`는 `sdd-init-fastapi`의 7번 틀에서 import 경로만 바꿔 쓴다.

- **SDD**: 기능 추가·수정은 `/sdd-feat`(`.claude/skills/sdd-feat/process.md`의 단계)로 진행한다. spec 없이 구현하지 않고, spec·plan에 없는 상황은 추측하지 말고 묻는다.

## 스택 연결 값
| 항목 | 값 |
|---|---|
| **레이어** | Controller → Service → Repository (아래 "레이어드 아키텍처"). PLAN "변경 파일"은 `dto/`, `domain/`, `repository/`, `service/`, `controller/`, `exception/` / `config/` 순서로 적는다(`src/main/java/<base-package>/` 아래) |
| **에러 표현** | `ErrorCode` 항목 / 상태 코드 (아래 "Error Handling") |
| **TASK 기본 순서** | T1 domain·dto 정의 → T2 repository, T3 `ErrorCode` 항목 추가 → T4 service 로직 + service 테스트 → T5 controller 연결(컴포넌트는 `@Scheduled`·`ApplicationRunner` 빈 등록), 정상/에러 케이스 확인, 문서 갱신 |
| **컴포넌트 구동 위치** | `@Scheduled` 메서드(주기 실행) 또는 `SmartLifecycle`/`ApplicationRunner` 빈(상시 실행) |
| **확인 명령** | `./gradlew spotlessCheck`, `./gradlew spotlessApply`, `./gradlew test` |
| **API 확인 방법** | `/swagger-ui.html`(springdoc)에서 직접 호출, `/v3/api-docs`에서 문서 확인 |
| **추가 완료 항목** | Swagger UI에서 요청·응답 example이 실제 값으로 보이는지 확인 |

## Java 규칙
- 빌드·의존성은 Gradle wrapper(`./gradlew`)만 쓴다. 포맷은 Spotless(google-java-format)만 쓴다.
- 요청·응답 DTO는 `record`로 만들고, 검증은 Bean Validation(`@NotBlank`, `@Size` 등)으로 한다. 엔티티를 응답으로 직접 반환하지 않는다.
- 검증 메서드 이름: 틀리면 예외를 던지면 `validate<대상>`, 참/거짓만 돌려주면 `is<대상>`.
- 모든 public 메서드와 복잡한 로직에는 짧은 주석(Javadoc 한 줄)을 단다.

## 레이어드 아키텍처
요청 흐름은 반드시 **Controller → Service → Repository** 순서를 따른다.

| 패키지 | 역할 | 금지 |
|---|---|---|
| `controller/` | HTTP 계층만: 요청 DTO 받기 → service 메서드 하나 호출 → 응답 DTO 반환 | 비즈니스 로직, repository 직접 호출, 엔티티 반환 |
| `dto/` | 요청·응답 `record`. `<Name>Request`, `<Name>Response` | |
| `service/` | 비즈니스 로직. `@Transactional` 경계는 여기 | controller 참조 |
| `repository/` | DB 접근(Spring Data 인터페이스)만 | service 호출 |
| `domain/` | 엔티티·도메인 모델·enum | |
| `exception/` | `ErrorCode`, `BusinessException`, `@RestControllerAdvice` | |
| `config/` | 설정 빈, 외부 클라이언트 빈 조립 | |

- 외부 시스템 클라이언트는 `<Name>Client` 클래스 하나로 감싸고, 다른 service는 그 클래스를 통해서만 호출한다.

## 의존성 주입
- 생성자 주입만 쓴다(`final` 필드). 필드 `@Autowired`는 쓰지 않는다.
- 외부 클라이언트·설정 객체는 `config/`의 `@Bean`으로 조립한다.
- 테스트는 가짜 객체를 생성자로 넣거나 Mockito `@Mock`을 쓴다.

## 테스트
- JUnit 5로 작성하고 `./gradlew test`로 실행한다. 테스트 클래스는 `<대상>Test`.
- **service 테스트가 핵심이다.** 비즈니스 규칙마다 정상/에러 케이스를 하나 이상 둔다. repository·외부 클라이언트는 Mockito로 대체하고 실제 DB·외부 시스템에 붙지 않는다.
- controller 테스트는 `@WebMvcTest` + `MockMvc`로 상태 코드와 응답 형태만 확인한다.

## Error Handling
- 모든 비즈니스 에러는 `throw new BusinessException(ErrorCode.XXX)`로 던진다. `ErrorCode` enum 각 항목은 `(code, HttpStatus, message)`를 가진다.
- `@RestControllerAdvice`에서 처리한다.
  - `BusinessException` → `{code, message}` JSON + `ErrorCode`의 상태 코드
  - `MethodArgumentNotValidException`(Bean Validation 실패) → 400
  - DB 예외(`DataAccessException`) → 500
  - 기타 `Exception` → 500 (`unknown_error`)
