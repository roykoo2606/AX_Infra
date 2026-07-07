# graph.json 스키마 + 적재 가이드

> `graph.json`은 `graph_export.py`가 볼트 frontmatter에서 결정적으로 추출한 온톨로지 스냅샷이다. 볼트/그래프 DB 공통 적재 소스.

## 파일 구조

```json
{
  "generated": "2026-07-05",
  "nodes": [
    { "id": "어반데이터랩", "class": "Organization", "businessKey": "8648601386", "path": "03. Resources/Wiki/22. Entities/어반데이터랩.md" }
  ],
  "edges": [
    { "from": "어반데이터랩", "to": "딥노이드", "rel": "partnerOf" }
  ]
}
```

## 필드 정의

노드: `id`(엔티티명=노트 stem, 고유) · `class`(온톨로지 클래스) · `businessKey`(정규형 키, 없으면 빈 문자열) · `path`(볼트 상대경로, 출처 추적).
엣지: `from`(출발 노드 id) · `to`(도착 엔티티명) · `rel`(관계 통제 어휘 또는 `about`).

## 불변식 (AX_Infra 검증 조건)

- 모든 노드 `id`는 고유.
- 모든 엣지의 `from`은 노드 집합에 존재. `to`는 노드에 없을 수 있음(dangling) → 엔티티 승격 후보.
- `class`·`rel`은 `ontology_schema.md` 통제 어휘 내.
- 민감 클래스(Credential/Card/BankAccount)·민감 관계는 **부재**해야 정상(반출 금지).

## 그래프 DB 적재 매핑

**Neo4j (Cypher)**
```cypher
// 노드
UNWIND $nodes AS n
MERGE (x {id: n.id}) SET x.class = n.class, x.businessKey = n.businessKey, x.path = n.path;
// 엣지 (rel은 관계 타입으로)
UNWIND $edges AS e
MATCH (a {id: e.from}) MERGE (b {id: e.to})
CALL apoc.merge.relationship(a, e.rel, {}, {}, b) YIELD rel RETURN count(rel);
```

**Apache AGE (PostgreSQL/Cypher)**
- 노드는 `class`를 라벨로: `CREATE (:Organization {id:'...', businessKey:'...'})`
- 엣지는 `rel`을 관계 라벨로. `businessKey`를 유니크 제약으로 두면 이관 중 중복 병합이 안정적.

## 재생성

노트 frontmatter를 고친 뒤 `python3 graph_export.py --write`. Urban_AX에서는 하네스(harness_test_runner)가 린터 통과 후 자동 재생성한다. AX_Infra도 동일 훅 권장.
