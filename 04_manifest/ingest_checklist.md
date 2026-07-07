# Ingest 체크리스트 — 노트 1건 이관 절차

> Urban_AX 노트 1건을 AX_Infra로 옮길 때마다 이 순서를 실행한다. 자동화 전에는 수동, 이후 스크립트화.

## 사전 (AX_Infra 최초 1회)

- [ ] `01_contract/` 3종을 헌법·스키마로 채택
- [ ] `02_toolchain/`의 스크립트·`_Templates/` 배치, 경로에 맞게 `vault_linter.py`·`graph_export.py`의 `VAULT_NAME`/루트 확인
- [ ] `03_ontology_seed/graph.json`으로 그래프 골격 세팅(그래프 DB면 graph_schema의 적재 매핑 실행)
- [ ] secret gate(pre_flight 상당) 설치

## 노트 단위 루프

1. [ ] **선택**: 이관할 원본 1건 지정
2. [ ] **제외 대조**: `exclusion_list.md`에 걸리면 중단(비밀·민감 클래스·대용량·개인정보)
3. [ ] **분류**: `type`(6종) 결정, 위치 결정(PARA)
4. [ ] **frontmatter 정합**: v3 표준 7키 + 유형별 키. 없으면 `frontmatter_backfill.py`, 구형이면 `frontmatter_migrate_v21.py`
5. [ ] **온톨로지 바인딩**: 엔티티면 `entityClass`·`businessKey`·관계키(도메인 방향). 일반 문서면 `about` 추가
6. [ ] **배치**: 목적지에 파일 생성/이동
7. [ ] **린트**: `python3 vault_linter.py` → **ERROR 0** 확인 (아니면 수정 후 재실행)
8. [ ] **그래프**: `python3 graph_export.py` → dangling 확인. 참조되나 노드 없는 엔티티는 승격
9. [ ] **로그**: `ingest_log.md`에 1줄(원본→목적지, 린터결과, 날짜)
10. [ ] **커밋**: 단위 작업 종료 시 커밋(헌법 §3-5)

## 완료 판정 (과제/폴더 단위)

- [ ] 해당 과제 전 노트 린터 ERROR 0
- [ ] graph_export dangling 0 또는 승격 후보 문서화
- [ ] `00_프로젝트_인덱스` Tier3 필드(program·stage·deadline 등) 채움
- [ ] 원본은 Urban_AX에 동결 표시(이중 편집 방지)

## 품질 목표

계약 위반 0, 비밀 유출 0, 그래프 연결성 유지. "빨리 많이"보다 "규칙대로 하나씩".
