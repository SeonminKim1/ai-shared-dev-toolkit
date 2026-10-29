---
name: tistory-post
description: 소재(.md/PDF)로 "잉여개발자" 티스토리 블로그 문체에 맞춘 붙여넣기용 글을 생성/갱신한다. topics/ 소재를 주거나 "글 써줘", "포스팅 만들어줘", "소재 추가"라고 할 때 사용.
argument-hint: <slug>
---

# 티스토리 글 생성 (잉여개발자 스타일)

## 작성 원칙 (사용자 지시, 모든 규칙·샘플보다 우선)
1. **요약 위주.** 리스트 항목 1줄(길어도 2줄), 서술은 섹션당 1~2문장. 반복 금지, 소재가 길어도 핵심만.
2. **이모지 금지** (h2, ⭐️, 👉, 📘, 📁 등 전부). 강조는 `<b>`만.
3. **정보는 리스트로.** 리스트 앞에 `<p><b>소제목</b></p>`.
4. **중첩 리스트 금지.** ul/ol 안에 ul/ol, li 안 `<br />- ` 줄 모두 금지. 세부는 별도 `<b>소제목</b>` + 평평한 리스트로 나누거나 한 줄로 합친다 (`A: 설명 (예: …)`).
- 문체·서식 기준은 **최근 글(370번 이후)**. 옛 글의 습관(이모지 라벨, `<p>- ` 줄 나열, 존댓말·반말 혼용, 긴 서술)은 따르지 않고, 구성(섹션 흐름)만 참고한다.

## 파일 구조
작업 폴더(현재 디렉터리) 기준. `topics/`, `posts/`가 없으면 만든다. 이 문서의 `types/`, `templates/`, `samples/`, `reference/`, `scripts/`는 스킬 디렉터리 기준 경로.
```
topics/<slug>/01.md, 02.md, *.pdf  ← 소재 (topics/<slug>.md 단일 파일도 가능)
topics/<slug>/_digest.md           ← PDF 핵심 정리 (Claude가 작성)
posts/<slug>/post.html             ← 본문 HTML
posts/<slug>/preview.html          ← 미리보기 + 복사 버튼 (preview.sh가 생성, 직접 수정 X)
posts/<slug>/meta.md               ← 제목, 카테고리, 태그, 이미지/TODO 체크리스트
```
- slug는 소재 파일/폴더 이름. 내용만 붙여넣으면 짧은 영문 kebab-case slug로 `topics/<slug>/01.md`에 저장 후 진행.

## 워크플로우
### 1) 첫 생성
1. 소재를 전부 읽는다 (파일명순). PDF가 있으면 `reference/pdf.md`를 따른다.
2. **쓰기 전에 항상 유형을 묻는다** (AskUserQuestion, 소재에 `유형:`이 있으면 생략). 아래 유형 판단표로 후보 2~3개, 1순위에 `(추천)`, 선택지마다 "소재의 어떤 신호 때문인지"와 "h2 흐름"을 한 줄씩. 카테고리·제목 후보도 같이 물어도 된다 (질문 최대 3개).
3. 정해진 유형의 `types/<type>.md`와 `templates/<type>.html`을 읽고 `post.html`, `meta.md`를 쓴다. 샘플은 구성이 애매할 때만 1개 읽는다.
4. 작업 폴더에서 `<스킬 디렉터리>/scripts/preview.sh <slug>`로 미리보기를 연다. **클립보드 자동 복사 금지.** "복사해줘"라고 하면 `<스킬 디렉터리>/scripts/copy.sh <slug>`.
5. 응답은 유형+근거 한 줄, 제목/카테고리, 파일 경로, TODO, "미리보기 열림 (복사 버튼)"만. 본문을 채팅에 다시 출력하지 않는다.

### 2) 소재 추가
- 기존 post.html을 읽고 **그 위에 통합**한다 (재작성 X, 유형 재질문 X). 사용자가 직접 고친 부분은 유지.
- 기존 섹션 보강이면 그 섹션에, 새 주제면 h2 추가 후 번호 재정렬.
- meta.md 변경 이력에 "NN.md 반영: 무엇을 어디에" 한 줄. preview.sh 재실행.

### 3) 사실성
- 소재에 없는 **개인 경험·수치·날짜·회사명은 지어내지 않는다.** 빈 곳은 본문에 `[TODO: 필요한 것]`, meta.md에도 기록.
- 개념/실습 글은 일반 기술 지식으로 설명·예시·코드 보강 가능. 버전·명령어가 불확실하면 TODO.
- 링크는 소재에 있는 것과 공식 문서처럼 확실한 것만.

## 블로그 정보
- 잉여개발자 (https://yubi5050.tistory.com). 카테고리는 meta.md에 `상위 / 하위`로 적는다.
  - 회고 & 기록: 프로젝트 경험기, 기타 경험 & 트러블슈팅
  - 개념 정리: 개발 인사이트, 개발 지식 정리, DB 지식, 기술 면접 대비
  - 실습 기록: Django, DRF / FastAPI, Ninja / Python Advanced / DB / JavaScript
  - 클라우드 & 데브옵스: Kubernetes & Docker / Cloud-Native / AWS / CI & CD
  - 기타: 시사, 경제 / 창고

## 제목 규칙
- 기본형 `[키워드] 제목`. 키워드는 기술명(`[Nginx] Nginx 에서 CORS 처리하기`), 글 성격(`[트러블슈팅]`, `[프로젝트 회고]`, `[자격증]`, `[경제]`, `[Utils]`, `[SW 개발]`), 연재명 중 하나.
- 기존 연재명은 주제가 맞으면 재사용: `[좋은 DB 설계하기]`, `[좋은 API 설계하기]`, `[리팩토링]`, `[디자인패턴] 분류 - 이름 (English)`, `[MSA 경험기] 프로젝트명 (N) 주제 (by. 기술)`
- 연재 번호: `(1)`, `(5-1)`, `1. 업로드 (Presigned URL)`, `Operating System 4 - …`. 기존 연재와 이어지면 다음 번호를 제안.
- 트러블슈팅/개선기는 문장형 (`~로 인해 CI가 멈춘 문제`, `~전환과 배포 환경 개선기`).
- 출처/도구는 괄호로: `(by. X)`, `(with. X)`, `(feat. X)`. 비교형은 `A와 B (ft. X/Y/Z)`도 가능.
- meta.md에 후보 2~3개 (1순위 표시).

## 유형 판단
형식은 소재 성격으로, 카테고리는 주제로 따로 고른다 (1:1 아님).

| 소재 신호 | 유형 → 파일 |
|---|---|
| 회사·프로젝트 전체, 몇 개월 기간, 단계별 한 일, 팀, 소회 / 프로젝트 연재, KPT | C. 프로젝트 회고 → `project-retro` |
| 시스템·환경을 바꾼 일 (기존 → 문제 → 변경 → 전후 비교) / 리팩토링 전후 코드 / 설계안 1안·2안 비교 | D. 개선기·적용기 → `improvement` |
| 에러·장애 하나 (증상 → 원인 → 해결) / 같은 주제 이슈 모음 / 짧은 실무 메모 / 실무 팁 몇 가지 | E. 트러블슈팅 → `troubleshooting` |
| 자격증·시험 응시 | F. 자격증 후기 → `review` |
| 컨퍼런스·세미나·전시회 참관 | G. 세미나 후기 → `seminar` |
| 영상·책·아티클 내용 정리, 비개발 주제(경제 등) | H. 요약 → `summary` |
| 발표 자료 목록, 좋은 글·링크 모음 | I. 자료 공유 → `archive` |
| 코드가 절반 이상, "예제", "따라하기", 설치·설정 단계 | B. 실습 기록 → `practice` |
| 개념 정의, A vs B, 설계 기준, 도구 선택 과정, 연재 개념(디자인 패턴) | A. 개념 정리 → `concept` |

- 우선순위: 사용자 명시 > F/G/H/I 신호 > 경험 범위(C 전체 / D 변경 하나 / E 이슈 하나) > B vs A.
- 카테고리: 장기 프로젝트·시스템 개선은 `회고 & 기록 / 프로젝트 경험기`, 단일 이슈·세미나·자격증은 `기타 경험 & 트러블슈팅`. 실무 판단은 `개념 정리 / 개발 인사이트`, 일반 지식·디자인 패턴은 `개발 지식 정리`, DB는 `DB 지식`. 인프라 예제는 `클라우드 & 데브옵스 / *`(Jenkins·브랜치 전략은 CI & CD), 프레임워크 예제는 `실습 기록 / *`(370번 이후엔 거의 안 씀). 개인 세팅 메모는 `기타 / 창고`.

## 공통 문체
- **개조식 명사형 종결** 기본: `~함`, `~됨`, `~필요`, `~가능`, `~임`, 마침표 자주 생략.
- 서술 문단: 개요는 존댓말, 회고·배경·마치며는 반말 평서체 (유형 파일에 따로 있으면 그것을 따른다).
- 용어 병기: `멱등성(Idempotency)`. 예시는 괄호로 구체 상황: `(예시: 결제 금액을 10,000원에서 100원으로 조작해서 …)`
- 자주 쓰는 표기: `ex)`, `→`/`->`, `A > B`, `결론 :` 한 줄, `(with. X)`. 의견은 `개인적으로는 ~ 싶다`처럼 짧게. Q&A는 `<b>Q.1 질문</b>` + 답은 인용구.
- 관련 이전 글은 도입에 링크 한 줄 (URL은 소재에 있거나 사용자가 준 것만).
- AI 문체("~에 대해 알아보겠습니다", "결론적으로 ~라고 할 수 있습니다", 과장 수식어)와 인사말 금지. 바로 본론.

## HTML 서식 (티스토리 기본모드 붙여넣기)
post.html은 **본문 조각만** (`<html>/<head>/<body>` 없이). 복사 버튼이 rich text로 복사하고 사용자가 기본모드에 Cmd+V 한다. 깨지는 요소를 사용자가 알려주면 이 섹션에 대체 방법을 기록한다.
- 확인됨 (26.10.29): 기본모드 붙여넣기 시 h2 인라인 스타일이 제거되지만 **그대로 쓴다** (사용자가 에디터에서 처리, 따로 안내 X). `copy.sh --html`은 요청 시에만.

정확히 아래 스니펫을 쓴다:
```html
<h2 style="box-sizing: border-box; border-right-width: 0px; border-top-width: 0px; border-left: #43587F 6px solid; border-bottom: #e0e0e0 2px solid; line-height: 1.5; margin-right: 0px; padding: 3px 5px 3px 10px;" data-ke-size="size26">1. 제목</h2>
<h3 data-ke-size="size23">1. 단계명</h3>
<h4 data-ke-size="size20">1. 단계명</h4>
<p data-ke-size="size16">내용</p>
<p data-ke-size="size16">&nbsp;</p>
<p data-ke-size="size16"><b>1) 소제목</b></p>
<ul style="list-style-type: disc;" data-ke-list-type="disc">
<li><b>키워드 :</b> 설명</li>
</ul>
<ol style="list-style-type: decimal;" data-ke-list-type="decimal">
<li><b>키워드</b>: 설명</li>
</ol>
<hr contenteditable="false" data-ke-type="horizontalRule" data-ke-style="style2" /><!-- 회고 단계 사이 -->
<hr contenteditable="false" data-ke-type="horizontalRule" data-ke-style="style1" /><!-- 해결 뒤 부가 섹션 앞 -->
<table style="border-collapse: collapse; width: 100%;" border="1" data-ke-align="alignLeft" data-ke-style="style12">
<tbody>
<tr><td><b>구분</b></td><td><b>설명</b></td></tr>
<tr><td>A</td><td>설명</td></tr>
</tbody>
</table>
<pre class="python" data-ke-language="python" data-ke-type="codeblock"><code>print("hello")</code></pre>
<blockquote data-ke-style="style2">
<p data-ke-size="size16">핵심 한 문장</p>
</blockquote>
<code>alembic upgrade head</code>
<a href="https://..." target="_blank" rel="noopener">링크 텍스트</a>
<p data-ke-size="size16">[이미지: 무엇을 보여줄지 / 캡션]</p>
```
- 코드블록 내용은 HTML 이스케이프 (`&lt; &gt; &amp;`), 줄바꿈·들여쓰기 유지. language는 python, bash, yaml, json, java, javascript, sql, plaintext(폴더 트리) 중 하나.
- h2 앞과 블록(소제목+리스트) 사이에 `&nbsp;` 빈 문단 하나.
- 인라인 스타일은 h2 외에 넣지 않는다.

## meta.md 형식
```markdown
# 제목
1. [키워드] 제목 ← 추천
2. ...

- 유형: A. 개념 정리 (근거 한 줄)
- 카테고리: 개념 정리 / 개발 지식 정리
- 태그: 태그1, 태그2, ... (5~10개, 한글/영문 혼용)

## 이미지 체크리스트
- [ ] 섹션 2: 흐름도

## TODO (확인 필요)
- [ ] 회고 2단계 기간 정보 없음

## 변경 이력
- 01.md: 초안 생성
```

## 참고 자료
- `types/<type>.md`: 유형별 구성·변형·대표 샘플 번호 (작성 시 해당 유형 1개만 읽음)
- `samples/<번호>_<유형>_<키워드>.txt`: 유형별 대표 글 11개. 평소엔 읽지 않는다.
- 샘플이 없는 변형은 유형 파일에 적힌 원문 번호를 `https://yubi5050.tistory.com/<번호>`에서 본다.
