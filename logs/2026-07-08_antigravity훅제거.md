# 2026-07-08 antigravity 훅 충돌·제거
- 지시: agyx "Tool call denied by pre-tool hook" 문제 해결 (출처: 대화)
- 결과: 원인 = cmux antigravity 훅의 PreToolUse feed bridge가 도구 실행마다 승인을 요구 → agyx yolo 모드와 충돌해 차단. 해결 = `cmux hooks antigravity uninstall -y` 후 agyx 재시작. claude/codex 훅은 세션 기록만 하므로 유지
- 최종 재개 구성: claude·codex = cmux 훅 자동 재개 / agyx = 재시작 시 수동 1줄 (훅 설치 금지)
- 산출물: docs/usage.md 갱신
