# AX_Infra 일상 사용법 (확정 구조, 2026-07-07)

## 구조 한 장

```
launchd (ai.hermes.gateway)                    ← Discord 게이트웨이
 └─ hermes   keepalive + runatload — 크래시·로그인 시 자동 기동

tmux (ax 세션, 재부팅 시 launchd 자동 기동)     ← 무인 상시 서비스
 └─ watcher  이벤트 스크립트 supervisor (`scripts/watcher.sh`)
             ├─ rpb-daily:   연구기획 데일리 스캔/브리프
             └─ log-rotate:  6시간마다 상시 서비스 로그 회전

cmux (관제·작업 화면)                          ← 인터랙티브 에이전트
 ┌─────────────┬─────────────┐
 │   claudex   │    agyx     │   왼쪽: 오케스트레이터·메인
 │   (메인)     ├─────────────┤   우상: Antigravity 워커
 │             │   codexx    │   우하: Codex 워커
 └─────────────┴─────────────┘
```

## 평소에 할 일

| 상황 | 할 일 |
|---|---|
| cmux를 껐다 켰다 | 배치 복원 + 워커(codexx·agyx) 자동 재개. **메인 패널에서 `claudex -c` 한 줄**만 (claudex 래퍼는 cmux의 claude 자동재개와 매칭 안 됨 — 검증 2026-07-08) |
| 맥 재부팅 | **없음.** launchd가 tmux 서비스(hermes/watcher)를 자동 기동. cmux는 열면 위와 동일 |
| 제로 베이스(새 워크스페이스/새 맥) | cmux 빈 패인에서 `axx` — 분할부터 에이전트 실행까지 자동 |
| 모바일에서 지시 | Discord로 Hermes에게. 결과는 inbox/·TASKS.md·logs/에 기록됨 |
| 서비스 로그 보기 | `scripts/view.sh hermes` 또는 `scripts/view.sh watcher` (나올 땐 Ctrl+b d). watcher 로그는 `logs/system/watcher.log`, rpb-daily 로그는 `~/Urban_AX/logs/system/rpb-daily.log` |
| 연구기획 데일리 스캔 수동 실행 | `~/Urban_AX/scripts/rpb-daily.sh --once` — claudex가 Drive를 못 읽어도 watcher supervisor가 같은 호스트 권한으로 스캔·브리프 생성 |
| watcher에 새 이벤트 추가 | `scripts/watcher.sh`의 `SERVICES`에 `name|command|restart_delay` 한 줄 추가. 각 서비스는 자체 log/lock을 가져야 함 |

## 로그인

- claude/codex/agyx 인증은 설정 파일에 저장 — **재로그인 불필요**
- 대화 복원: Claude/Codex는 cmux 훅이 자동. 수동 필요 시 `claudex -c`(최근 대화 이어받기)

## 1회 설정 (새 맥 이식 시 bootstrap.sh 이후)

```bash
cmux hooks setup && cmux hooks setup codex           # 세션 자동 재개 훅 (claude·codex만)
echo "alias axx='~/Claude/Projects/AX_Infra/scripts/cmux-layout.sh'" >> ~/.zshrc
scripts/install-autostart.sh                         # 재부팅 자동 기동
```

- Settings 확인: **Resume Agent Sessions on Reopen** 켜짐
- 세션은 에이전트가 **한 번 활동한 뒤** 캡처됨 — 확인: `ls ~/.cmuxterm/` 에 claude·codex 세션 파일
- claudex/codexx 커스텀 래퍼로 실행해도 훅이 정상 작동함 (검증됨 2026-07-08)
- ⚠ **antigravity 훅은 설치 금지** — PreToolUse 훅이 agyx의 도구 실행을 차단함(yolo와 충돌).
  2026-07-08 확인 후 2026-07-27 v2 훅으로 재시도했으나 동일하게 "Tool call denied by pre-tool hook" 재현 — 금지 유지.
  (codex는 같은 feed 구조여도 정상 — agy 쪽 훅 해석 차이로 추정)
  잘못 설치했다면: `cmux hooks antigravity uninstall -y` 후 agyx 재시작. agyx는 그 패인에서 `agyx` 한 줄로 복귀
- agyx 자동 재기동(2026-07-27): `~/.zshrc`가 `scripts/agyx-autoboot.sh`를 소싱 — cmux 재시작으로 패널이 새 셸로 복원되면,
  해당 surface의 resume 바인딩이 `kind=antigravity`일 때 agyx를 자동 실행. 바인딩(표식)은 아래 명령으로 관리:
  `cmux surface resume set --surface <agyx-surface> --kind antigravity --name agyx --cwd ~/Claude/Projects/AX_Infra -- ~/.local/bin/agyx`
  (패널 위치를 바꾸면 새 surface에 위 명령을 다시 실행. 해제: `cmux surface resume clear`)

## 문제 해결

- 서비스 상태: `tmux ls` → "ax: 1 windows"(watcher). hermes는 `hermes gateway status`로 별도 확인
- 서비스 재시작: `tmux kill-session -t ax && scripts/start.sh`
- 화면이 꼬임: 워크스페이스 닫고 새로 만들어 `axx`
- ⚠ **재기동 시 에이전트가 자동 복원 안 됨**: cmux Settings의 **Claude Code hooks** 토글이 꺼진 경우
  (2026-07-27 발생). 확인: `defaults read com.cmuxterm.app claudeCodeHooksEnabled` → `1`이어야 함.
  꺼져 있으면 패널에 `CMUX_CLAUDE_HOOKS_DISABLED=1`이 내려가 세션 추적이 중단됨
  (`~/.cmuxterm/claude-hook-sessions.json` mtime이 갱신 안 되는 것으로 판별).
  설정을 켠 뒤에는 **새 패널부터** 적용되므로 cmux 재시작 후 claudex 재실행 필요

## 프로젝트별 관제 채널

| 명령 | 프로젝트 | 구성 |
|---|---|---|
| `axx` | 범용 AX_Infra (인프라 자체) | claudex · agyx · codexx |
| `uraxx` | **Urban_AX 독립 루트** (`~/Urban_AX/`) — 어반데이터랩 전사 AX 마스터 | claudex(조율) · agyx(수집·파싱) · codexx(구현) |
| `uraxx weekly` / `uraxx rpb` / `uraxx mig` | Urban_AX 서브(주간보고 대시보드 / RPB / vault 이관)로 경로만 변경 | 동일 3분할 |
| `beaxx` | B:Essential AX_Infra (`~/BEssential/BE_AX_Infra`) | 별도 레이아웃 |

빈 패인에서 명령만 치면 해당 프로젝트 경로로 3분할 관제 화면이 구성된다.
Urban_AX 포트폴리오·병렬 운영 계획은 `~/Urban_AX/ROADMAP.md` 참조.

## Hermes 게이트웨이 (2026-07-29 구조 정정)

- **launchd가 단독 관리**한다 (`ai.hermes.gateway`, `keepalive | runatload`).
  tmux에서 중복 실행하면 "Gateway already running"으로 5초마다 실패하며 로그만 채운다 —
  2026-07-29에 `start.sh`에서 hermes 창을 제거했다.
- 상태 확인: `hermes gateway status` · 재시작: `hermes gateway restart`
- 재시작 시 CLI가 "launchd cannot manage… exit 5"를 출력할 수 있으나 **오탐**이다.
  `launchctl print gui/$(id -u)/ai.hermes.gateway`로 `state = running`과 keepalive를 확인할 것.
- **Discord 연결이 끊기면 프로세스는 살아 있어도 무응답이다.** 프로세스 확인만으로는 부족하다.
  판별: `~/.hermes/logs/gateway.log`의 마지막 `✓ discord connected` 시각과
  `gateway.error.log`의 `ClientConnectorDNSError` 누적 여부. 복구는 `hermes gateway restart`.
