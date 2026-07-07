# 전사 온톨로지 스키마 (포터블)

> AX_Infra 채택용 포터블 버전. 원본: Urban_vault/02. Areas/어반데이터랩_전사_온톨로지/00_온톨로지_스키마.md.
> 클래스·관계·Business Key는 조직 무관하게 재사용 가능하다. 예시의 실제 사업자번호·연구자번호는 형식만 남기고 값은 생략했다.

## 1. 클래스 (Entity Class)

| Class | 설명 | 대표 Business Key |
|---|---|---|
| `Organization` | 법인·기관(내부 법인, 파트너, 전담기관, 병원, 회계법인) | `org_id` = 사업자번호(10자리 정규형) |
| `Person` | 임직원·연구자·외부 담당자 | `person_id` = 국가연구자번호(없으면 내부 일련번호 `<접두>-###`) |
| `GovProject` | 정부지원사업/정부과제 | `project_id` = 과제고유번호(없으면 `GP-##`) |
| `Consortium` / `SubProject` | 컨소시엄·세부과제 | `consortium_id` |
| `System` | 전산·관리 시스템 | `system_id` = 시스템명 |
| `Agency` | 부처·전담기관·회계법인 (Organization의 역할) | `org_id` |
| `Product` / `Dataset` / `Domain` | 산출물·데이터셋·도메인 | — |
| `Credential` / `Card` / `BankAccount` | **민감 클래스 — frontmatter·그래프 반출 금지** | (지정 마스터 본문에만) |

## 2. 관계 (Relation) — 그래프 엣지

| Relation | Domain → Range | 의미 |
|---|---|---|
| `employedBy` | Person → Organization | 소속 |
| `allocatedTo` | Person → GovProject | 과제 참여(참여율은 마스터 정본) |
| `managesProject` | Person → GovProject | 총괄PM/실무총괄 |
| `hasPI` | Organization → Person | 기관 책임자 |
| `hasContact` | Organization → Person | 실무 담당자 |
| `participatesIn` | Organization → GovProject/SubProject | 사업 참여 |
| `fundedBy` | GovProject → Agency | 부처·전담기관 |
| `settledBy` | GovProject → Agency(회계법인) | 정산 |
| `usesSystem` | GovProject → System | 사용 시스템 |
| `partnerOf` | Organization → Organization | 컨소시엄 파트너 |

> 민감 관계(`hasCredential`/`paysWith`/`depositsTo`/`hasNationalResearcherId`)는 그래프 반출 대상에서 제외한다.
> frontmatter에는 **도메인 방향의 엣지만** 기재하고, 역방향은 `graph_export.py`가 자동 도출한다.

## 3. Business Key 규칙

- `org_id`: 사업자번호 하이픈 제거 10자리 정규형. 매칭은 정규형, 표기는 하이픈 허용.
- `person_id`: 국가연구자번호. 없으면 `<조직접두>-###`. **국가연구자번호 원본은 대외 반출 주의 — AX_Infra 이관 시 정책 확인.**
- `project_id`: 과제고유번호. 없으면 `GP-##`.
- 오표기·유사명 정규화 규칙을 조직별로 1개 문서로 유지.

## 4. enum

- 재직 상태: `active` · `resigned` · `planned-exit` · `leave`
- 참여구분: `주관` · `공동개발기관` · `위탁` · `용역` · `총괄` · `단독`

## 5. Frontmatter 바인딩

이 온톨로지는 노트 frontmatter로 실체화된다(규격: `frontmatter_standard_v3.md` Tier 4). 엔티티 노트가 노드, `about`+관계키가 엣지. `graph_export.py`가 frontmatter → `graph.json`으로 결정적 변환한다 = 그래프 DB(AGE/Neo4j) 적재 소스.
