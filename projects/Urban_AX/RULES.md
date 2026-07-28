# RULES: Urban_AX (마스터 + 서브 공통)

전체 규약(CONSTITUTION·WORKFLOW)을 그대로 따른다. 추가 규칙:

## 읽기 순서

서브 프로젝트 작업 시: 이 폴더의 `GOAL.md`·`RULES.md` → 해당 서브의 `GOAL.md` → `RULES.md`.
서브 RULES는 이 문서와 다른 점만 기술한다.

## 데이터 경계

- **rawdata는 서브 프로젝트 폴더 안에서만 관리한다.** 서브 간 원자료 직접 참조·수정 금지 — 필요하면 산출물(`output/`)을 통해 주고받는다
- 원본(Confluence·Google Drive·전달킷)은 전부 **읽기 전용**. 각 서브 RULES의 취급 규칙을 따른다
- 마스터 루트에는 문서(GOAL/RULES/ROADMAP)와 `scripts/`만 둔다. 데이터·산출물을 마스터 루트에 두지 않는다

## 서브 프로젝트 신설 절차

1. `projects/Urban_AX/<kebab-name>/` 생성 + WORKFLOW §3의 GOAL.md·RULES.md 작성
2. rawdata 원천과 읽기/쓰기 경계를 GOAL.md에 명시
3. `ROADMAP.md` 포트폴리오 표와 `GOAL.md` 서브 표에 한 줄 추가
4. TASKS.md에 등록 후 시작. 종료 시 서브 폴더를 `projects/_archive/`로 이동

## 관제 채널

- `uraxx` = 마스터 기준 3분할(claudex·agyx·codexx). 서브 지정: `uraxx weekly` / `uraxx rpb` / `uraxx mig`
- 서브별 워커 전환은 `docs/<agent>-rpb-switch.md` 방식(붙여넣기 지시문)을 표준으로 한다
