# GOAL: 어반데이터랩 발표자료 디자인시스템

**하나의 목표**: 컨텍스트와 방향성만 입력하면 에이전트가 회사 아이덴티티에 맞는 장표를 그대로 생산하고,
사람은 마지막 마무리 터치만 하면 되는 상태를 만든다.

## 목표 워크플로우

```
컨텍스트·방향성 입력 → design.md 참조 → 컴포넌트 조립(HTML) → 렌더(PNG @2x) → 사람 마무리 터치
                                 ↑                    ↑
                       실사 이미지 생성 활용     아이콘 설계 규칙
```

## 확정 사항 (2026-07-27)

| 항목 | 결정 |
|---|---|
| 문서 성격 | AI 실행 스펙 (감상형 가이드 아님) |
| 아이덴티티 기준 | ① 웹사이트 urbandatalab.co.kr ② MEDICUS IR Book ③ 산자부 발표자료(폰트·구조만) |
| 주력 폰트 | **Paperlogy** (웨이트 1~9) |
| 보조 폰트 | **Freesentation** |
| 금지 | macOS 전용 서체 전면 배제 (AppleMyungjo, Songti SC, Apple SD Gothic Neo), Pretendard 제거 |
| 브랜드 색상축 | 165°~270° 쿨 스펙트럼 (민트 `#14DEAF` → 블루 `#108CEB` → 퍼플 `#745CED`), 액센트 `#00FFCB` |
| 실행 담당 | codexx (gpt-5.6-sol) — 브리프: `workspace/BRIEF_codexx.md` |

## 완료 조건

- [ ] `output/design.md` 작성 완료 (codexx)
- [ ] 모든 색·크기·간격이 확정값이며 근거 출처가 명시됨
- [ ] 컴포넌트마다 복사 가능한 HTML/CSS 스니펫 포함
- [ ] macOS 전용 폰트 의존 0건
- [ ] `infographic-builder`·`archify`·`dataviz` 스킬용 브랜드 컨텍스트 블록 포함
- [ ] claudex 검수 — 토큰값과 원본 렌더 대조
- [ ] 표지 1장을 design.md만 보고 재현하는 실증 테스트 통과
- [ ] Roy 최종 확인
