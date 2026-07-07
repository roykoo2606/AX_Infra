---
type: wiki-page
aliases:
  - <대체 이름>
description: "<English 1-2 sentence description of this entity>"
author:
  - Claude
date created: {{date}}
date modified: {{date}}
layer: entities
confidence: <high|medium|low>
entityClass: <Organization|Person|GovProject|SubProject|Consortium|System|Product|Dataset|Domain>
businessKey: "<org_id 사업자번호 10자리 | person_id 국가연구자번호/UDL-### | project_id 과제고유번호/GP-## — 미상이면 삭제>"
# 관계 키 — 00_온톨로지_스키마 §2의 도메인 방향으로만. 해당 없는 키는 삭제.
participatesIn:
  - "[[<GovProject>]]"
partnerOf:
  - "[[<Organization>]]"
fundedBy:
  - "[[<Agency/Organization>]]"
source: "[[<근거 문서>]]"
related:
  - "[[<함께 보기>]]"
tags:
  - wiki-page
  - entity
---

# <엔티티명>

<!-- 관계의 속성값(참여율·참여구분·기간)은 마스터 문서(20_인력_마스터, 60_관계_그래프)가 정본.
     Credential/Card/BankAccount 정보는 여기 싣지 않는다. -->

> [!info] Source
> <근거: 마스터 문서·원본>

## Related
- [[00_온톨로지_스키마]]
