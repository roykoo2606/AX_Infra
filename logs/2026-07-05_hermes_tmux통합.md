# 2026-07-05 Hermes gateway를 ax 세션에 통합
- 지시: hermes gateway를 infra의 tmux 안에서 종료되지 않는 서비스로 운영 가능한지 (출처: 대화)
- 결과: 가능 — start.sh에 5번째 창 'hermes' 추가. gateway 크래시 시 5초 후 자동 재시작 루프. 재부팅 → launchd → start.sh → hermes 상주로 일원화. 샌드박스 검증 통과(5창 생성 확인)
- 산출물: scripts/start.sh
- 주의: Hermes 자체 launchd 서비스(ai.hermes.gateway)와 중복 실행 금지 — 켜져 있으면 unload 필요 (start.sh 주석 참고)
- 다음: Roy 맥에서 재시작 후 Discord 지침 메시지 전송 → Phase 4 검증
