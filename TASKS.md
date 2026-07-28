# TASKS — 공유 작업 보드

> **모든 에이전트 필수 규칙**: 작업 시작 전 이 파일을 읽는다. 새 작업은 등록 후 시작하고, 상태가 바뀌면 즉시 갱신한다. 이 파일이 전체 에이전트의 공유 상황판이다.
> ID 형식: `T-YYYYMMDD-nn` | 상태: 대기 → 진행 → 완료/중단

## 진행 중

| ID | 작업 | 담당 | 시작 | 최근 갱신 | 비고 |
|---|---|---|---|---|---|
| T-20260728-01 | RPB(연구기획사업부) AX 프로젝트 폴더 신설 및 전 에이전트 작업 폴더 전환 | Claude Code + Roy | 2026-07-28 | 2026-07-28 | 폴더는 `projects/Urban_AX/rpb-ax/`로 이동됨(T-20260728-02). agyx·codexx 전환 지시문: `docs/agyx-rpb-switch.md`, `docs/codexx-rpb-switch.md` (Roy가 각 패인에 붙여넣기 — 새 경로 반영 완료) |
| T-20260709-01 | Roy·claudex 재작업 시작 인계 | Claude Code(claudex) + Roy | 2026-07-09 | 2026-07-09 | 인계서 `logs/handoff_T-20260709-01.md`. **cmux의 기존 claudex 세션에서 이어갈 것**; 별도 tmux/claudex 세션 시작 금지 |
| T-20260705-06 | Phase 6: 대시보드 v1 (STATUS.md 자동생성 + Discord) | Claude Code + codexx | 2026-07-08 | 2026-07-08 | STATUS.md 생성기(scripts/status.sh) 완료(codexx 구현·검수 통과). **잔여: Discord #status 발송**(Hermes 경유·채널/webhook 설정 필요) |
| T-20260705-05 | Phase 5: GDrive 공유드라이브 감시 | Hermes + tmux watcher | 2026-07-08 | 2026-07-08 | `scripts/watcher.sh` supervisor 구조로 확장. 현재 하위 서비스 rpb-daily 관리·재시작 검증 완료(PID kill 후 자동 재시작). 새 이벤트 스크립트는 SERVICES에 추가 |
| T-20260708-06 | 연구기획 파이프라인 Cowork→CLI 이전 (inbox CLI_MIGRATION.md) | Claude Code + Roy | 2026-07-08 | 2026-07-09 | **첫 정기 자동실행 검증 성공(07-09 08:30, 9 proj/3020 files)**. 결정: launchd plist 불필요(watcher 체인이 대체 — 이중실행 방지). 잔여: ①07-10 2회차 확인 후 Roy가 Cowork 스케줄 비활성화 ②네이버웍스 여부 결정(§3) |

## 대기

| ID | 작업 | 담당(예정) | 등록 | 비고 |
|---|---|---|---|---|
| T-20260707-02 | Urban_AX 데이터 이관 | Claude Code(CLI) + Roy | 2026-07-07 | Roy가 실데이터를 1건씩 분석하며 진행. 인계서: logs/handoff_T-20260707-02.md |

## 완료 (최근 10건만 유지 — 상세는 logs/)

| ID | 작업 | 담당 | 완료일 |
|---|---|---|---|
| T-20260728-02 | Urban_AX 마스터 프로젝트 구조화 (`projects/Urban_AX/` 신설, 서브 3개 이관, uraxx 채널 개편) | Claude Code | 2026-07-28 |
| T-20260708-05 | codexx·agyx 기본 모델 실제 설정 반영 및 새 세션 자동적용 설정 | agyx + Roy | 2026-07-27 |
| T-20260713-02 | 의료 관련 소프트웨어(SaMD/IVD/AI) 및 사업화/개발 절차 딥리서치 | agyx (Antigravity) | 2026-07-13 |
| T-20260713-03 | UR/BE Shared Growth Model 결정 반영 | Hermes | 2026-07-13 |
| T-20260713-01 | claudex 진행내용 파악 및 뼈대 이관 맥락 정리 | Hermes | 2026-07-13 |
| T-20260708-08 | cmux/tmux watcher 백그라운드 데일리 스크립트 반영 | Hermes | 2026-07-08 |
| T-20260708-07 | Claude 인계 확인 및 연구기획 파이프라인 스캔·브리프 검증 | Hermes | 2026-07-08 |
| T-20260708-01 | agyx 워커 전환 클리닝 (전역 오케스트레이션 제거) | agyx + Roy | 2026-07-08 |
| T-20260708-03 | 모델 효율 규약(CONSTITUTION §0) + 에이전트 기본 모델(WORKFLOW §5-1) | Claude Code | 2026-07-08 |
| T-20260708-02 | codexx 워커 전환 클리닝 | codexx + Roy | 2026-07-08 |
| T-20260706-02 | AX_Infra 문서 목록 정리 | Hermes | 2026-07-06 |
