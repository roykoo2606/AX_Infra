# GOAL: Urban_AX 데이터 이관

**하나의 목표**: 회사 볼트(Urban_AX)의 지식 자산을 계약(스키마·온톨로지)에 맞춰 `vault/`로 무결하게 이관한다.

## 완료 조건 (04_manifest/migration_manifest.md 순서)

- [x] 계약 채택: CONSTITUTION v0.3 §9·10 + Frontmatter v3 (2026-07-07)
- [x] 툴체인 설치: scripts/vault/ 4종, 린터 vault/ 경로로 조정·통과 (2026-07-07)
- [ ] 온톨로지 시드 적재: graph.json → vault/ 반영 방식 결정 후 적재
- [ ] 온톨로지 마스터·Wiki 엔티티 이관 (02. Areas / 03. Resources/Wiki)
- [ ] 활성 프로젝트 8개 과제 순차 이관 (285md, 권장 순서: 바이오헬스 RFP부터)
- [ ] 전 과정: 노트 1건 단위 ingest_checklist 준수, 린터 ERROR 0 유지
