# ROADMAP: Urban_AX 포트폴리오 (2026-07-28)

> 지금까지의 어반데이터랩 AX 자료조사·준비 자산을 취합·구조화한 현황판.
> 갱신 규칙: 서브 프로젝트 상태 변화 시 이 표를 함께 갱신한다.

## 1. 서브 프로젝트 현황

| 서브 | 상태 | 다음 단계 | 병렬 담당(패널) |
|---|---|---|---|
| `urban-weekly-dashboard/` | 수집 완료(페이지 364·첨부 1,825·1.17GB), 대시보드 미착수 | ① 부서×주차 통합 색인 ② `부서_정규화.json` 확인필요 4건 해소 ③ 대시보드 v1 | claudex 설계 · agyx 파싱/색인 · codexx 대시보드 구현 |
| `rpb-ax/` | 파이프라인 가동 중(평일 08:30 rpb-daily, 9 proj/2,621 files) | ① 워커 전환 확인 ② Drive 스트리밍 Errno 11 해결 ③ output/ 흐름 검증 | watcher 자동화 + codexx 스크립트 보수 |
| `urban-ax-migration/` | 계약·툴체인 완료, 실데이터 이관 대기(T-20260707-02) | 온톨로지 시드 적재 방식 결정(Roy와 1건씩) 후 285md 순차 이관 | claudex + Roy (자동 일괄 금지) |

## 2. 기반 자산 인덱스 (취합 결과)

### 규약·계약 (루트 — 이동 금지)
- `CONSTITUTION.md` §9 작업무결성·§10 vault 규칙 — Urban_AX 전달킷에서 채택된 원칙
- `01_contract/` frontmatter v3·온톨로지 스키마·거버넌스 / `02_toolchain/` 린터·템플릿
- `03_ontology_seed/graph.json` / `04_manifest/` 이관 대상·금지 목록·체크리스트
- `vault/` PARA 골격 (실데이터 0건 — migration 서브가 채운다)

### rawdata 원천 (전부 읽기 전용)
| 원천 | 소비 서브 | 위치 |
|---|---|---|
| Confluence 주간보고 수집물 | weekly-dashboard | `urban-weekly-dashboard/data/` (pages 364 · attachments 1,825 · parsed · 색인 3종 JSON) |
| 연구기획 아카이브 미러 | rpb-ax | `inbox/연구기획_프로젝트_아카이브/` (project_master.csv·signals·대시보드 HTML 4종·CLI_MIGRATION.md·AX_INFRA_HANDOFF.md) |
| Google Drive 공유드라이브 U | rpb-ax | `Urban_AX_Workflow/연구기획_프로젝트_아카이브`(SSOT) · `2. R&D 사업/2-3. 수행중인 사업`(스캔 원천) |
| Urban_AX 지식볼트 원본 | migration | 전달킷 매니페스트 기준 (exclusion_list 절대 준수) |

### 재사용 가능한 검증 자산
- **대시보드 패턴**: rpb 대시보드(`index.html`+`dashboard.html`+`detail.html`+`data/*.json`+브리프 생성기) — weekly-dashboard가 그대로 참고하기로 확정
- **수집기**: `scripts/confluence-browser-sync.py` 3종 (브라우저 세션 기반)
- **자동화 체인**: `scripts/watcher.sh` supervisor + `rpb-daily.sh` — 새 정기 작업은 SERVICES 한 줄 추가로 확장
- **워커 전환 지시문 패턴**: `docs/agyx-rpb-switch.md`·`codexx-rpb-switch.md`

## 3. 병렬 운영 방식

```
uraxx           ← 마스터 관제(이 폴더). 포트폴리오 점검·서브 간 조율
uraxx weekly    ← 주간보고 대시보드 집중 작업
uraxx rpb       ← RPB 파이프라인 집중 작업
uraxx mig       ← vault 이관 집중 작업 (Roy 동석 필수)
```

- 동시 진행 원칙: 서브별 데이터가 분리돼 있으므로 서로 다른 패널·세션에서 병렬 진행 가능. 단 **TASKS.md 등록으로 중복 착수만 방지**한다
- 공용 자원 충돌 주의: Drive 스캔은 한 곳에서만(rpb-daily 체인), Confluence 수집은 브라우저 세션 1개 전제

## 4. 서브 프로젝트 후보 (보류 — 착수 시 RULES 신설 절차 적용)

- [주간보고-정기수집] weekly-dashboard 완료 조건의 "매주 자동 수집"을 watcher SERVICES로 승격
- [네이버웍스-알림] rpb 브리프의 naverworks_notify.py 활성화 여부 (T-20260708-06 잔여 결정)
- [부서-확장] 주간보고 외 부서 단위 AX 수요 발굴 (경영관리·마케팅 등) — Roy 지시 대기
