# 거버넌스 원칙 (포터블)

> AX_Infra 채택용. 원본: `_Policies/00_CONSTITUTION.md`에서 조직·프로젝트 고유값(경로, Drive ID, RFP명)을 제거한 이식용 원칙.
> AX_Infra는 이 원칙을 자기 저장소의 헌법(`_Policies/00_CONSTITUTION.md`)으로 채택하고, 도구별 지침(CLAUDE/AGENTS/GEMINI)은 얇은 어댑터로 둔다.

## 1. 단일 헌법 + 얇은 어댑터

- 전역 규범은 **하나의 헌법 파일**이 정본. 도구별 파일은 "헌법 요약 + 참조 + 도구 고유 규칙"만. 전역 규칙을 어댑터에 복제하지 않는다.
- 중복 발견 시 헌법으로 통합하고 어댑터에서 삭제.

## 2. SSOT 원칙

모든 모델 세션은 임시 메모리, SSOT는 저장소 파일.

```text
Context Pack → Task Envelope → Model Scratch → Handoff → 검증 → 승격
```

정본 문서 목록을 헌법에 명시하고, **경로가 바뀌면 즉시 갱신**한다(지침 자체가 stale해지는 것이 최대 리스크).

## 3. 비협상 규칙

1. **원본 불변**: Raw Sources는 append-only. 무단 수정·삭제·이동 금지.
2. **비밀정보**: `credentials.json`, `token*.json`, `*_token.json`, `.env`, `.auth/`, OAuth/API 키는 읽지·커밋·인용 금지. 저장소 밖에 보관.
3. **사용자 수정 최우선(Anti-Rollback)**: 사용자의 수동 수정을 되돌리지 않는다. 작업 전 `git status --short` 확인.
4. **승인 게이트**: 전략·구조 결정, 대량 삭제/이동, 대외 공유는 사람 승인 후.
5. **작업 종료**: 단위 작업마다 기계적 검증(린터)+커밋. 실패 3회 시 Human Escalation.

## 4. 검증의 기계화

- 선언만으로는 부족. **린터·secret gate로 규칙을 기계적으로 강제**한다.
- 신규 데이터는 도착 즉시 린터 통과(ERROR 0)를 조건으로 승격.

## 5. Handoff 규약

```markdown
# Handoff: <task_id>
## What was done / Files read / Files modified / Decisions made
## Risks / blockers / Required user approval / Recommended next step
```

## 6. 3계층 지식 구조 (PARA 채택 시)

Raw Sources(불변) → Wiki(LLM 관리 지식) → Schema(규칙). 목적(`collectionPurpose`) 우선, 출처 추적 필수, 점진 갱신.

## 7. 개정 절차

헌법 변경은 사람 승인 + 변경 로그(`log.md`) + 어댑터 정합 확인.
