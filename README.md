# AX_Infra 전달 킷 (Transfer Kit)

> 발신: Urban_AX (연구기획사업팀 AI Workflow) · 수신: **AX_Infra** (클린 신규 환경)
> 작성일: 2026-07-05 · 작성: Claude (Roy 승인)

## 이 킷의 목적

AX_Infra는 클린한 상태에서 Urban_AX의 데이터를 **하나씩 이관**한다. 이때 데이터를 그냥 복사하면 규칙 없는 더미가 된다. 그래서 **데이터보다 "계약(스키마+온톨로지)"과 "검증 도구"를 먼저 이식**하고, 데이터는 그 계약에 맞춰 흘려보낸다.

핵심 원칙: **Contract first, data second. 도착 즉시 검증.**

## 전달 순서 (이 순서대로 AX_Infra에 세팅)

1. **`01_contract/`** — 거버넌스·스키마·온톨로지 계약. AX_Infra가 가장 먼저 읽고 채택.
   - `frontmatter_standard_v3.md` — 3계층 frontmatter 표준(Tier1 공통7키 / Tier2 type·status 통제어휘 / Tier3 워크플로우 / Tier4 온톨로지 바인딩)
   - `ontology_schema.md` — 클래스·관계·Business Key 정의(조직 고유값 제거된 포터블 버전)
   - `governance_principles.md` — SSOT·비협상 규칙·핸드오프 규약(포터블)
2. **`02_toolchain/`** — 계약을 기계적으로 강제하는 검증 도구 + 노트 템플릿.
   - `vault_linter.py` · `graph_export.py` · `frontmatter_backfill.py` · `frontmatter_migrate_v21.py`
   - `_Templates/` (raw-source · wiki-page · query-result · moc · project-index · entity)
3. **`03_ontology_seed/`** — 데이터가 앉을 그래프 골격.
   - `graph.json` — 엔티티·관계 결정적 스냅샷(민감 클래스 제외). 볼트/그래프DB 공통 적재 소스.
   - `graph_schema.md` — graph.json 필드 정의 + AGE/Neo4j 매핑 가이드
4. **`04_manifest/`** — 무엇을·어디로 옮기고 **무엇은 제외**하는가.
   - `migration_manifest.md` — 이관 대상 인벤토리 + 목적지 매핑
   - `exclusion_list.md` — **반입 금지**(비밀 파일·민감 클래스·대용량 원본)
   - `ingest_checklist.md` — 노트 1건을 이관할 때마다 실행하는 절차

## 이관 루프 (노트 1건 단위)

```text
Urban_AX 원본 선택
  → exclusion_list 대조(제외 대상이면 중단)
  → frontmatter를 v3 표준에 맞춤(backfill/migrate 도구 활용)
  → AX_Infra 대상 위치에 배치
  → vault_linter 실행(ERROR 0 확인)
  → graph_export 실행(dangling 확인 → 필요 엔티티 승격)
  → 이관 로그 기록
```

## 중립성 (AX_Infra 설계 미확정 대응)

이 킷은 AX_Infra가 **옵시디언 볼트든, 그래프 DB(AGE/Neo4j)든, 둘 다든** 수용하도록 설계됐다. 계약·온톨로지·시드는 표현 형식과 무관하며, `graph.json`은 두 경우 모두의 적재 소스가 된다.

## 보안 원칙 (필독)

- 이 킷에는 비밀정보(credentials/token/.env)·민감 클래스(Credential/Card/BankAccount)·주민번호앞자리·국가연구자번호 원본이 **포함되지 않는다**.
- 이관 중에도 `exclusion_list.md`를 절대 규칙으로 지킨다. 위반 시 `vault_linter`의 E4/E6가 차단한다.
