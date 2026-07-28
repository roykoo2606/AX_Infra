# UR/BE Shared Growth Model

> 결정일: 2026-07-13  
> 결정: 단일 Hermes gateway를 유지하고, UR/BE를 prefix와 작업 루트로 구분한다. 두 인프라는 독립 운영하되 좋은 개선점은 상호 이식한다.

## 1. 명칭

| 약칭 | 의미 | 루트 |
|---|---|---|
| UR | Urban / Urbandatalab / Urban_AX | `/Users/roysmac/Urban_AX` (2026-07-28 AX_Infra에서 독립 루트로 분리) |
| BE | B:Essential | `/Users/roysmac/BEssential/BE_AX_Infra` |
| (인프라) | 범용 AX_Infra — hermes·watcher·규약 등 인프라 자체 | `/Users/roysmac/Claude/Projects/AX_Infra` |

## 2. 운영 결정

현재 단계에서는 Hermes profile이나 Discord bot을 분리하지 않는다.

```text
단일 Hermes gateway
└─ Discord 지시
   ├─ UR) ... → UR 인프라에서 처리
   └─ BE) ... → BE 인프라에서 처리
```

이유:

- Roy의 공통 선호와 전략 문맥은 하나의 Hermes가 유지하는 편이 좋다.
- UR/BE는 서로 다른 회사 업무지만, AI-Native 인프라 관점에서는 함께 성장한다.
- 한쪽에서 검증된 workflow, script, template, watcher 구조를 다른 쪽으로 이식할 수 있다.
- profile/bot 분리는 운영 복잡도를 늘리므로 지금은 보류한다.

## 3. 작업 분리 원칙

작업 결과와 셀프 인프루브 기록은 반드시 각 repo에 남긴다.

```text
UR 개선 기록
- /Users/roysmac/Urban_AX/TASKS.md
- /Users/roysmac/Urban_AX/logs/
- /Users/roysmac/Urban_AX/docs/
- /Users/roysmac/Urban_AX/scripts/
(인프라 개선 기록은 /Users/roysmac/Claude/Projects/AX_Infra 에 남긴다)

BE 개선 기록
- /Users/roysmac/BEssential/BE_AX_Infra/TASKS.md
- /Users/roysmac/BEssential/BE_AX_Infra/logs/
- /Users/roysmac/BEssential/BE_AX_Infra/docs/
- /Users/roysmac/BEssential/BE_AX_Infra/scripts/
```

## 4. 상호 이식 원칙

UR 또는 BE에서 개선점이 생기면 바로 다른 쪽에 복사하지 않는다. 아래 절차를 따른다.

1. 개선점 발생 repo에 먼저 기록한다.
2. 범용화 가능 여부를 판단한다.
3. 다른 repo에 적용할 가치가 있으면 `TASKS.md`에 별도 이식 작업으로 등록한다.
4. 경로, 회사명, 승인 prefix, watcher 서비스명, 민감 규칙을 해당 회사에 맞게 치환한다.
5. 검증 후 logs에 기록한다.

## 5. prefix 규칙

권장 지시 형식:

```text
UR) <작업 지시>
BE) <작업 지시>
```

예:

```text
UR) BioHealth RFP 진행상황 요약해줘
BE) 교육 콘텐츠 제작 workflow 정리해줘
UR) watcher 로그 확인해줘
BE) TASKS 기준 다음 작업 추천해줘
```

## 6. 나중에 분리할 조건

아래 중 2개 이상 발생하면 profile/bot 분리를 재검토한다.

- UR/BE 메모리 충돌이 반복된다.
- Discord 채널/권한/알림 정책이 회사별로 달라진다.
- 회사별 cron/job이 많아져 단일 gateway 관리가 복잡해진다.
- BE 전용 skill이 UR에 섞이거나, UR 전용 RFP 규칙이 BE 작업에 섞이는 문제가 발생한다.
- 외부 팀원/권한 분리가 필요해진다.

그 전까지는 단일 Hermes gateway + UR/BE prefix 라우팅을 표준으로 한다.
