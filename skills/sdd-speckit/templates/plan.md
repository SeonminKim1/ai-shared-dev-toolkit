# 구현 계획: <기능 이름>

- **브랜치**: `NNN-<이름>` | **작성일**: YYYY-MM-DD | **spec**: [spec.md](spec.md)

## 요약 (Summary)
<spec의 핵심 요구사항 + research에서 정한 기술 방향, 두세 줄>

## 기술 맥락 (Technical Context)
<!-- 프로젝트·스택 파일로 답이 나오는 항목은 그대로 채운다. 모르는 것만 NEEDS CLARIFICATION → research.md에서 해결 -->
- **언어/버전**: 
- **주요 의존성**: 
- **저장소**: <DB, 컬렉션·테이블>
- **테스트**: <스택 연결 값의 확인 명령>
- **실행 환경**: 
- **유형**: <HTTP API | 백그라운드 컴포넌트 | 도메인 모델>
- **성능·제약**: <해당 없으면 "없음">

## Constitution Check
<!-- GATE: research 전에 통과해야 하고, 설계(data-model·contracts) 후 다시 확인한다. constitution.md 원칙과 CLAUDE.md 요구사항 중 이 기능에 걸리는 것만 -->
| 원칙·요구사항 | 이 기능에서 지키는 방법 | 결과 |
|---|---|---|
| II. 레이어 | | 통과 |
| IV. 에러 표현 | | 통과 |
| `CLAUDE.md`: <요구사항> | | 통과 |

## 프로젝트 구조 (Project Structure)

### 문서
```text
specs/NNN-<이름>/
├── spec.md, checklists/requirements.md   # specify
├── plan.md, research.md, data-model.md   # plan (이 문서)
├── contracts/, quickstart.md             # plan
├── tasks.md                              # tasks
└── implement.md                          # implement
```

### 변경 파일 (Source Code)
<!-- 스택 연결 값의 레이어 디렉터리 순서대로, 새 파일은 (신규) -->
- `<레이어 디렉터리>/<파일>`: <바뀌는 내용 한 줄>

### DB 변경
- 컬렉션·테이블 / 필드 / 인덱스·유니크 제약 / 기존 데이터 마이그레이션: (없으면 "없음")

### 외부 의존성
- 외부 API 호출, 새 패키지: (없으면 "없음")

## 복잡도 기록 (Complexity Tracking)
<!-- Constitution Check에 예외가 있거나 V. 단순함에 걸릴 때만 채운다. 없으면 섹션을 지운다 -->
| 예외·추가한 것 | 필요한 이유 | 더 단순한 대안을 버린 이유 |
|---|---|---|

## 리스크 / 확인 필요
- (없으면 섹션을 지운다)
