# codexx 작업 지시: STATUS.md 자동 생성기 (Phase 6 대시보드 v1)

> 담당: codexx (Codex 워커) | 발주: Claude Code (오케스트레이터) | TASKS: T-20260705-06
> 목표: "어디서든 30초 안에 전체 상황 파악". 저장소 상태를 읽어 루트 `STATUS.md`를 자동 생성하는 셸 스크립트 하나.

## 산출물

`scripts/status.sh` 파일 하나만 만든다. (Discord 발송은 별도 단계 — 이 스크립트에 넣지 말 것)

## 요구사항 (계약)

- `#!/usr/bin/env bash` + `set -euo pipefail`
- 저장소 어디서 실행해도 동작: 스크립트 위치 기준으로 repo 루트를 구해 그 경로에서 동작
  (`REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"`)
- 루트의 `STATUS.md`를 **덮어쓴다** (append 아님)
- 코드 주석은 영어, 출력 문서 내용은 한국어
- 외부 네트워크 호출 없음. `tmux`/`ls`/`grep`/`awk` 등 표준 도구만
- 실행 후 마지막에 `echo "STATUS.md 생성 완료: $REPO/STATUS.md"`

## STATUS.md 출력 형식 (이 구조 그대로)

```markdown
# STATUS — AX_Infra
> 생성: YYYY-MM-DD HH:MM (scripts/status.sh 자동 생성)

## 서비스 (tmux ax)
- hermes: ● 가동 / ○ 중단
- watcher: ● 가동 / ○ 중단
(판정: `tmux ls`에 "ax:" 세션이 있으면 가동으로 본다. 세션 자체가 없으면 둘 다 ○ 중단)

## 작업 (TASKS.md 기준)
- 진행 중: N건
- 대기: M건
### 진행 중 목록
(TASKS.md '## 진행 중' 표의 각 행에서 ID·작업만 뽑아 `- <ID>: <작업>` 형태로. 없으면 "- (없음)")

## 최근 로그
(logs/ 아래 `*.md` 파일명을 날짜 역순으로 최근 5개, `- <파일명>`)

## 검증 대기
- 맥 재부팅 풀사이클
- bootstrap.sh 타머신 검증
```

## 파싱 힌트

- TASKS.md의 표 행은 `| ID | 작업 | ... |` 형식. 헤더행(`| ID |`)과 구분선(`|---|`)은 제외.
  '## 진행 중'과 '## 대기' 섹션 사이 / '## 대기'와 '## 완료' 사이의 표 행만 카운트.
- 날짜/시각은 `date '+%Y-%m-%d %H:%M'`.

## 완료 조건

1. `bash scripts/status.sh` 실행 → 에러 없이 `STATUS.md` 생성
2. 생성된 STATUS.md가 위 형식과 일치
3. 완료되면 실행 결과(STATUS.md 내용)를 보고

작업 전 `CONSTITUTION.md`(특히 §0 모델 원칙·§7 Git)·`WORKFLOW.md`를 준수한다. 커밋은 하지 말고 파일만 만들어 둘 것 — 검수·커밋은 오케스트레이터가 한다.
