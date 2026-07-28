# GOAL: Urban_AX — 어반데이터랩 전사 AX 마스터

**하나의 목표**: 어반데이터랩의 부서·업무별 AX(AI Transformation)를 서브 프로젝트 포트폴리오로 구조화하고, 여러 패널(에이전트)에서 병렬로 진행·관제할 수 있는 단일 마스터 체계를 운영한다.

## 위치 규정

- 이 폴더가 **어반데이터랩 AX의 마스터**다. 회사 AX 관련 모든 서브 프로젝트는 이 아래에 둔다
- 채널 구분: `axx` = 범용 AX_Infra(인프라 자체) · `uraxx` = Urban_AX(이 마스터) · `beaxx` = B:Essential AX
- 서브 프로젝트는 구조가 유사할 수 있으나 **rawdata와 목적이 서로 다르다** — 데이터는 각 서브 폴더 안에서만 관리한다

## 서브 프로젝트 (현재)

| 폴더 | 목적 | rawdata 원천 |
|---|---|---|
| `urban-weekly-dashboard/` | 전 부서 주간업무보고 관제 대시보드 | Confluence(urbancorp.atlassian.net) 수집물 1.2GB |
| `rpb-ax/` | 연구기획사업부 R&D 관리 파이프라인(스캔→브리프→대시보드) | Google Drive `2-3. 수행중인 사업` + `inbox/연구기획_프로젝트_아카이브/` 미러 |
| `urban-ax-migration/` | 회사 지식볼트(Urban_AX 전달킷) → `vault/` 이관 | 전달킷(01_contract~04_manifest), Urban_AX 원본(읽기 전용) |

포트폴리오 상세·후보·병렬 운영 계획: `ROADMAP.md`

## 완료 조건

- [x] 마스터 구조 수립: 서브 3개 이관 + GOAL/RULES/ROADMAP + uraxx 채널 (2026-07-28)
- [ ] 서브 3개 각자의 GOAL 완료 조건 달성 (각 폴더 GOAL.md에서 추적)
- [ ] 신규 서브 프로젝트가 RULES.md의 신설 절차만으로 추가되는 흐름 1회 검증
- [ ] uraxx 관제에서 서브 프로젝트별 병렬 작업(패널 분담) 정착
