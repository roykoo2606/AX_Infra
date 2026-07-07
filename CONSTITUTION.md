# CONSTITUTION — AX_Infra 전체 규약 (v0.3)

> 모든 에이전트(Claude Code, Codex, Antigravity, 향후 로컬 LLM)에 적용되는 최상위 규약.
> 프로젝트별 지침(projects/*/RULES.md)은 이 규약을 위반할 수 없다.
> 구체적인 작업 절차는 `WORKFLOW.md`를 따른다.

## 1. 데이터 원칙

- 이 저장소(AX_Infra)가 **유일한 데이터 소스**다. 모든 산출물·기록·결정은 여기에 남긴다
- 저장 위치 규칙:
  - 규약·기획: 루트 (`CONSTITUTION.md`, `WORKFLOW.md`, `00_*.md`)
  - 프로젝트 작업물: `projects/<프로젝트>/` 내부 (산출물은 `projects/<프로젝트>/output/`)
  - 원격 지시: `inbox/`, 작업 기록: `logs/`, 참고 가이드: `docs/`
- 모든 문서는 마크다운(plain text). 단, 회사 제출용은 docx/xlsx/pptx 허용 (output/에 저장)
- Obsidian은 뷰어·자료 정리 용도일 뿐이다. Obsidian 전용 문법(dataview 등)에 의존하지 않는다
- 파일명: 문서는 한글 허용(`2026-07-05_주간보고.md`), 코드·스크립트는 영어 kebab-case

## 2. 언어

- 문서·규약·사용자 소통: **한국어**
- 코드·커밋 메시지·코드 관련 파일명: **영어**

## 3. 승인 규칙

기본은 자율 수행. 아래 3가지만 **사전 승인 필수**:

| 구분 | 예시 | 처리 |
|---|---|---|
| 시스템 파괴적 변경 | 시스템 파일·설정 삭제/변경, 앱 제거, launchd 수정 | 승인 요청 |
| 외부 전송 | 이메일 발송, 외부 API로 데이터 업로드, 공개 저장소 push, SNS 게시 | 승인 요청 |
| 비용 발생 | 유료 API 호출, 클라우드 자원 생성, 결제 | 승인 요청 |

자율 허용 (승인 불필요):

- 저장소 내 파일 생성·수정, 웹 검색·조회, 코드 실행(저장소 내), private 저장소 push(연동 완료 후)
- 일반 파일 삭제는 강제 삭제(rm) 대신 **휴지통 이동**. 저장소 내 파일은 git이 있으므로 삭제 가능
- 애매하면 물어본다. 승인 경계 조정 시 이 표를 갱신한다

## 4. 규약 계층과 읽기 순서

1. `CONSTITUTION.md` (이 문서) — 불변 원칙
2. `WORKFLOW.md` — 작업 절차와 템플릿
3. `projects/<프로젝트>/GOAL.md` → `RULES.md` — 해당 프로젝트 작업 시
- 하위 지침은 상위와 **다른 점만** 기술한다. 중복 금지
- 충돌 시 상위 문서가 이긴다

## 5. 심플함 원칙

- 새 도구·규칙·자동화 추가 전, 제거할 수 있는 기존 것이 없는지 먼저 검토한다
- 사용자에게 제시하는 설정·명령은 **가장 쉬운 방법 우선**, 3줄 이내 목표. 복잡한 대안은 '보류 항목'으로 분리
- 지침은 짧게. 한 문서가 두 화면을 넘으면 분리보다 삭제를 먼저 고려한다

## 6. 기록 (필수)

- 의미 있는 작업 완료 시 `logs/YYYY-MM-DD_<주제>.md`에 기록 (포맷은 WORKFLOW.md)
- 사용자와 합의한 **결정사항**은 기획문서(`00_*.md`)의 결정 목록에 즉시 반영
- 보류된 일은 기획문서 '보류 항목'에 키워드와 함께 기록 (예: `[GitHub-연동]`)

## 7. Git 규칙

- 커밋 단위: 하나의 논리적 작업 = 하나의 커밋. 메시지는 영어 명령형 (`Add weekly report template`)
- push 대상: `github.com/roykoo2606/AX_Infra` (private, 회사 계정)
- 민감정보(.env, 토큰, 비밀번호)는 절대 커밋하지 않는다 (.gitignore 준수). 문서에도 평문 기재 금지

## 8. 보안

- 자격증명은 macOS 키체인 또는 로컬 .env(git 제외)에만 보관
- 외부 서비스 연동 시 최소 권한 토큰 사용
- 회사 데이터가 포함된 파일은 개인 계정 저장소로 절대 push하지 않는다

## 9. 작업 무결성 (Urban_AX 계약 채택, 2026-07-07)

- **원본 불변**: raw-source(원본 자료)는 append-only. 무단 수정·삭제·이동 금지
- **Anti-Rollback**: 사용자의 수동 수정을 되돌리지 않는다. 작업 전 `git status --short`로 변경 확인
- **검증 기계화**: 규칙은 선언이 아니라 도구로 강제한다. vault/ 작업은 린터 ERROR 0이 완료 조건
- **Handoff**: 에이전트 간 작업 인계는 WORKFLOW §7 양식을 따른다

## 10. 지식 볼트 (vault/)

- `vault/`는 PARA 구조(00. Inbox ~ 04. Archive)의 지식 저장소. 운영 인프라(규약·TASKS·logs·scripts)와 분리한다
- vault/ 안의 문서는 **Frontmatter v3 표준**(`01_contract/frontmatter_standard_v3.md`) 필수. 운영 파일에는 적용하지 않는다
- 온톨로지 스키마: `01_contract/ontology_schema.md` | 검증: `python3 scripts/vault/vault_linter.py`
- 반입 금지 목록(`04_manifest/exclusion_list.md`)은 절대 규칙
- `01_contract/`~`04_manifest/`는 전달 킷 원본 — 수정하지 않는다 (이관 완료 후 아카이브)
