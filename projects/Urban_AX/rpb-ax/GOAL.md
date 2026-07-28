# GOAL: RPB(연구기획사업부) AX

**하나의 목표**: 연구기획사업부의 진행중 R&D 프로젝트 관리 업무를 AX 파이프라인(스캔→브리프→대시보드)으로 안정 운영하고, 이 폴더를 RPB 관련 모든 작업의 단일 작업 폴더로 삼는다.

## 참조 경로 (읽기 전용 — 원본 수정 금지)

- 원본(SSOT): Google Drive `공유 드라이브/U/Urban_AX_Workflow/연구기획_프로젝트_아카이브`
- 로컬 미러: `inbox/연구기획_프로젝트_아카이브/`
- 스캔 원천: Google Drive `공유 드라이브/U/2. R&D 사업/2-3. 수행중인 사업`
- 자동화: `scripts/rpb-daily.sh` (평일 08:30, 로그 `logs/system/rpb-daily.log`)

## 완료 조건

- [x] 프로젝트 폴더 신설: GOAL.md·RULES.md 작성 (2026-07-28)
- [ ] agyx·codexx 작업 폴더 전환 완료 확인 (지시문: `docs/agyx-rpb-switch.md`, `docs/codexx-rpb-switch.md`)
- [ ] rpb-daily 검증 단계 Drive 스트리밍 읽기 오류(Errno 11) 해결 후 정상 실행 1회 확인
- [ ] RPB 산출물이 `projects/Urban_AX/rpb-ax/output/`으로 모이는 흐름 1회 검증
