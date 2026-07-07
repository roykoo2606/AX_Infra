# Frontmatter 표준 v3.0 (포터블)

> AX_Infra 채택용 포터블 버전. 원본: Urban_vault/CLAUDE.md §Frontmatter. 조직 고유 예시는 일반화했다.
> frontmatter는 지식 저장소의 **데이터베이스 스키마**다. 역할 4가지: ① LLM 검색 힌트, ② 기계 검증 계약(린터), ③ 지식 신뢰도 메타, ④ 목적·수명주기·온톨로지 추적.

## Tier 1 · 공통 필수 7키 (모든 .md)

| Property | Type | 설명 |
|----------|------|------|
| `type` | text | 통제 어휘 6종만 (아래) |
| `aliases` | list | 대체 이름 (검색·링크 도달성) |
| `description` | text | **영어** 1~2문장 (본문 미개봉 관련성 판단 힌트) |
| `author` | list | 작성자 (LLM이면 `Claude`, 백필이면 `backfill`) |
| `date created` | datetime | ISO 8601 |
| `date modified` | datetime | ISO 8601 |
| `tags` | list | 태그 |

## Tier 2 · 문서 유형 (통제 어휘)

`type` 6종 고정, 신규 발명 금지. 세분류는 `subtype`:

| type | 용도 |
|------|------|
| `raw-source` | 불변 원본 |
| `wiki-page` | LLM 관리 지식 |
| `query-result` | 산출물·분석·검증 결과 |
| `moc` | Map of Content |
| `system` | 스키마·정책·운영 문서 |
| `project-index` | 프로젝트 관제 문서 |

`subtype` 권장 어휘: `evaluation-report`, `validation-report`, `research-loop`, `evidence-matrix`, `design-spec`, `planning-brief`, `meeting-note`, `dashboard`, `reference`, `note`.

`status` 통제 어휘: `active` · `draft` · `review` · `final` · `superseded` · `archived` · (raw-source 전용) `ingested`. 버전은 status에 섞지 않고 `version: "v1.0"` 키로 분리.

Layer별 추가: raw-source(`source`,`date ingested`,`category`,`collectionPurpose`) / wiki-page(`source`,`related`,`confidence`,`layer`) / query-result(`query`,`source`,`reusableFor`) / moc(`topic`,`related`).

## Tier 3 · 워크플로우 (`project-index` 전용 필수)

포트폴리오 집계·대시보드가 읽는 기계 계약층.

| Property | 값 |
|----------|-----|
| `program` | 발주처/프로그램명 |
| `role` | `주관` / `참여` / `컨소시엄PM` (조직 실정에 맞게 조정) |
| `stage` | `공고` / `파싱` / `분석` / `원고` / `검증` / `제출` / `종료` |
| `owner` | 담당자 |
| `deadline` | YYYY-MM-DD |
| `priority` | `high` / `medium` / `low` |
| `consortium` | list (선택) |
| `projectId` | 과제고유번호 (온톨로지 GovProject 조인 키) |

> `stage`·`role` enum은 AX_Infra 도메인에 맞게 조정 가능하나, **린터의 통제 어휘 세트와 반드시 동기화**한다.

## Tier 4 · 온톨로지 바인딩 (데이터 연결성 계층)

온톨로지 정본은 `ontology_schema.md`. 이 계층이 index·그래프·포트폴리오의 연결 축.

**① `about`** (모든 문서 권장) — 이 문서가 다루는 엔티티를 wikilink로 선언.
```yaml
about:
  - "[[<엔티티>]]"
```

**② 엔티티 노트 전용** (`type: wiki-page` + `layer: entities`):

| Property | 값 |
|----------|-----|
| `entityClass` | 온톨로지 클래스 통제 어휘 (ontology_schema §1) |
| `businessKey` | 정규형 키 (org_id/person_id/project_id 등) |
| 관계 키 | ontology_schema §2의 관계만, **도메인 방향으로만** |

**③ 관계 규칙** — 역방향 엣지는 그래프 생성기가 도출. 관계 속성값(비율·기간)은 마스터 문서가 정본, frontmatter엔 엣지만. `related`는 "함께 보기"용.

**⑤ 민감 클래스 금지** — `Credential`/`Card`/`BankAccount`는 frontmatter·그래프 반출 금지. 지정 마스터 본문에만.

## 금지·정리 규칙
- 구형 키 `created`/`modified` 금지 → `date created`/`date modified`
- `title` 금지 → `aliases`에 편입
- 새 YAML 키는 camelCase
- 미정 값은 빈 문자열(`""`) — 린터 WARN을 채움 신호로

## 검증
`vault_linter.py`가 ERROR(누락·통제어휘 위반·민감정보·index 비동기화)와 WARN(부분 frontmatter·broken link·orphan·Tier3/4 미기입)로 계약을 상시 강제한다.
