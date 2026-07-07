# TASKS — 공유 작업 보드

> **모든 에이전트 필수 규칙**: 작업 시작 전 이 파일을 읽는다. 새 작업은 등록 후 시작하고, 상태가 바뀌면 즉시 갱신한다. 이 파일이 전체 에이전트의 공유 상황판이다.
> ID 형식: `T-YYYYMMDD-nn` | 상태: 대기 → 진행 → 완료/중단

## 진행 중

| ID | 작업 | 담당 | 시작 | 최근 갱신 | 비고 |
|---|---|---|---|---|---|

## 대기

| ID | 작업 | 담당(예정) | 등록 | 비고 |
|---|---|---|---|---|
| T-20260707-02 | Urban_AX 데이터 이관 | Claude Code(CLI) + Roy | 2026-07-07 | Roy가 실데이터를 1건씩 분석하며 진행. 인계서: logs/handoff_T-20260707-02.md |
| T-20260705-04 | Phase 4: Hermes(Discord) 연동 | Claude+Roy | 2026-07-05 | 설치 상태 확인 필요. 주입용 지침 준비됨: docs/hermes-instructions.md |
| T-20260705-05 | Phase 5: GDrive 감시 에이전트 | Antigravity | 2026-07-05 | 감시 대상 폴더 미정 |
| T-20260705-06 | Phase 6: 대시보드 v1 (STATUS.md + Discord) | Claude | 2026-07-05 | |

## 완료 (최근 10건만 유지 — 상세는 logs/)

| ID | 작업 | 담당 | 완료일 |
|---|---|---|---|
| T-20260706-02 | AX_Infra 문서 목록 정리 | Hermes | 2026-07-06 |
| T-20260706-01 | Hermes 모바일 창구 스킬 설정 | Hermes | 2026-07-06 |
| T-20260705-01 | Phase 1: 공유 작업 보드(TASKS.md) 도입 | Claude (Cowork) | 2026-07-05 |
| T-20260705-02 | Phase 2: 표준 세션 스크립트(scripts/start.sh) | Claude (Cowork) | 2026-07-05 |
| T-20260705-07 | cmux 설치 | Roy | 2026-07-05 |
| T-20260705-03 | Phase 3: 자동 기동 — 맥 설치·검증 완료 | Claude+Roy | 2026-07-05 |
| T-20260705-04 | Phase 4: Hermes 연동 — 스킬 주입·실전 테스트 통과 | Hermes+Roy | 2026-07-06 |
| T-20260707-01 | Urban_AX 전달 킷 분석·통합 (CONSTITUTION v0.3, vault/, 툴체인) | Claude (Cowork) | 2026-07-07 |
| T-20260703-01 | [GitHub-연동] 로그인·초기 push (roykoo2606/AX_Infra) | Roy | 2026-07-05 |
