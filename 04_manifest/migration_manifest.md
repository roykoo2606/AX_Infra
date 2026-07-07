# 이관 매니페스트 (Urban_AX → AX_Infra)

> 무엇을 어디로 옮기는가. 실측 기준 2026-07-05 (Urban_vault). 이관은 노트 1건 단위로 `ingest_checklist.md`를 따른다.

## 우선순위 (계약 먼저, 데이터는 가치 높은 순)

| 순번 | 대상 | 규모 | 목적지(AX_Infra) | 우선순위 |
|---|---|---|---|---|
| 0 | **계약**: `01_contract/` 3종 채택 | 3 md | `_Policies/`, 스키마 문서 | 최우선 (데이터보다 먼저) |
| 0 | **툴체인**: `02_toolchain/` | 스크립트 4 + 템플릿 6 | `.agents/scripts/`, `_Templates/` | 최우선 |
| 1 | **온톨로지 마스터** | `02. Areas/어반데이터랩_전사_온톨로지/` (스키마·조직·인력·정부사업·시스템·재무·관계그래프) | `02. Areas/` 온톨로지 | 높음 (단, 민감 마스터는 제외목록 참조) |
| 2 | **Wiki 엔티티** | 16 (Entities) + 개념·MOC·가이드 | `03. Resources/Wiki/` | 높음 (그래프 노드 실체) |
| 3 | **온톨로지 시드** | `03_ontology_seed/graph.json` | 그래프 DB 또는 볼트 `_graph/` | 높음 |
| 4 | **활성 프로젝트** | `01. Projects/` 285 md (8개 과제) | `01. Projects/` | 중간 (과제별 순차) |
| 5 | **Resources 지식** | `03. Resources/` 46 md | `03. Resources/` | 중간 |
| 6 | Inbox·Areas 기타 | 소량 | 대응 위치 | 낮음 |
| — | **04. Archive (821MB)** | 대용량 원본 | **이관 제외 원칙** (exclusion_list) | 제외 |

## 목적지 매핑 규칙

- 구조는 PARA를 그대로 계승(00.Inbox / 01.Projects / 02.Areas / 03.Resources / 04.Archive).
- 프로젝트는 표준 골격(`00_프로젝트_인덱스 / 01_원문_파싱 / 02_분석 / 03_원고 / 04_검증 / 09_회의`)으로 재배치.
- 엔티티는 `03. Resources/Wiki/22. Entities/`에 그대로.

## 과제 이관 순서 (권장 — 완결성 높은 순)

1. 2026 산업부 바이오헬스 RFP 제안 (엔티티·그래프 연결 가장 조밀)
2. 2026 자폐 발달장애 디지털의료기기 2차년도 (GovProject 엔티티 존재)
3. 2026 Business Key Data Foundry 구축 (온톨로지와 직접 연계)
4. 2026 의료AI 데이터 바우처(2차) → SSIS → AI바우처 → 연구중심병원 → 팁스연계

## 이관 상태 추적

각 항목 이관 완료 시 `ingest_log.md`(AX_Infra 측 신규)에 기록: 대상경로 → 목적지 → 린터결과 → 그래프 dangling → 날짜.
