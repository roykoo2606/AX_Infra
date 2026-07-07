# RULES: urban-ax-migration

- 이관 루프(README.md의 노트 1건 단위 절차)와 `04_manifest/ingest_checklist.md`를 따른다
- `04_manifest/exclusion_list.md` 대상은 어떤 이유로도 반입하지 않는다 (비밀·민감 클래스·821MB Archive)
- 매 배치 종료 시 `python3 scripts/vault/vault_linter.py` ERROR 0 확인 후 커밋
- 반복 이관 작업은 워커(Codex/Antigravity)에게 분배 가능 — 단 린터 검증과 커밋은 오케스트레이터가 수행
- Urban_AX 원본에는 절대 쓰지 않는다 (읽기 전용 소스)
