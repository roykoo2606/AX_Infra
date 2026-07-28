# Chain Of Thought 정리_250430.pptx

- 원본 경로: `2457920/Chain Of Thought 정리_250430.pptx`
- 형식: `.pptx`  |  크기: 4,951,766 bytes
- 수정일: 2026-07-28 11:43
- 파싱 상태: `ok`

---
## 슬라이드 1

Chain Of Thought

AI연구소

## 슬라이드 2

목차

CoT 개념
CoT 발전 과정
비추론 모델과 추론 모델

**[발표자 노트]**
Resoning 강화 모델 학습 과정

## 슬라이드 3

CoT 개념

LLM이 복잡한 문제를 해결할 때, 중간 추론(사고) 단계를 명시적으로 표현하도록 유도하는 Prompting 기법
프롬프트에 한 개 이상의 단계적 예시(multi-step reasoning)를 제공함으로 절차적 사고 유도
모델 크기가 클 수록 효과가 증대

https://arxiv.labs.arxiv.org/html/2201.11903

CoT 프롬프트 예시

**[발표자 노트]**
2022년 1월

## 슬라이드 4

CoT 발전 과정

SELF-CONSISTENCY (2022.03)

주어진 텍스트에 대해 여러 개의 답변을 만들고, 가장 많이 나온 것을 최종 정답

https://arxiv.org/pdf/2203.11171

ChatGPT

**[발표자 노트]**
consistency 일관성

## 슬라이드 5

CoT 발전 과정

Large Language Models are Zero-Shot Reasoners (2022.05)

사전 학습된 LLM에 특정 작업에 대한 예시(샷)나 추가 파인튜닝 없이, 
단순히 "Let's think step by step" 같은 프롬프트를 추가해 추론 능력을 끌어내는 기법.

https://arxiv.org/pdf/2205.11916

## 슬라이드 6

CoT 발전 과정

REACT: Reasoning + Act (2022.10)

<생각(CoT) → 행동(“외부 도구/검색”) → 관찰 → 다시 생각 → 답변> 의 루프를 통해 복잡한 정보 조회나 계산을 수행하고, 최종적으로 정확한 답을 도출

Grok

**[발표자 노트]**
CoT와 도구를 이용해서 답변의 질을 향상 / 도구 중점
Q: 시르크 드 솔레유 쇼 미스터리를 공연하는 호텔에는 몇 개의 객실이 있나요?

## 슬라이드 7

CoT 발전 과정

Reflexion (2023.3)

LLM이 자신의 추론 과정을 검증하고, 오류를 식별하며, 
“자기 반성”을 통해 더 나은 답변을 생성하도록 유도

(시도 → 평가 → 반성 → 수정 → 다시 시도)

**[발표자 노트]**
언어 강화 학습을 통한 언어 에이전트
사람이 실수로부터 배우는 것처럼 언어적 피드백으로 인한 강화(자기 반성적 피드백)
trajectory - 궤도, 사고 흐름 / profession 직업
Actor를 이용해 문제를 풀고, Evaluator를 통해 결과를 확인하고, Self-reflection으로 반성

## 슬라이드 8

CoT 발전 과정

Tree of Thoughts (2023.05)

LLM이 중간 추론을 트리 구조로 탐색하며 여러 경로를 평가 및 선택해 
복잡한 문제를 효과적으로 해결하는 방법을 제안

너비 우선 탐색(BFS), 깊이 우선 탐색(DFS)

Decomposition문제 해결을 단계별로 나누기 
Thought Generation각 상태에서 가능한 여러 선택지를 생성 
Heuristic Evaluation선택지를 평가하는 기준 생성 
Search Algorithm어떤 탐색 알고리즘으로 답을 고를지 결정

**[발표자 노트]**
기존에는 미래를 예측하거나 과거로 돌아가서 수정하는 것이 불가능, 초기 한 번의 결정이 전체 결과에 지나치게 큰 영향을 줌

## 슬라이드 9

CoT 발전 과정

Question Decomposition(2023.07)

복잡한 질문을 분해하여 잘 이해하고 답변을 작성하는 전략
답변의 신뢰도는 상승했지만 질문 분해 과정에서 정보 손실로 정확도가 낮아짐

**[발표자 노트]**
https://www-cdn.anthropic.com/8154fb1d828cdc390dc1fa442d84034948679c47/question-decomposition-improves-the-faithfulness-of-model-generated-reasoning.pdf

## 슬라이드 10

CoT 발전 과정

Graph of Thoughts (2023.08)

https://arxiv.org/pdf/2308.09687

LLM이 그래프처럼 분기·병합하며 유연하게 추론하게 하는 방식으로
여러 아이디어를 자유롭게 결합하고 순환하며 복잡한 문제 해결을 시도

**[발표자 노트]**
Solving Elaborate Problems with Large Language Models 
대규모 언어 모델을 사용한 정교한 문제 해결


Chain-of-Thoughts: 단 하나의 추론 경로만 가짐. 정확한 추론 경로 보장 X
Self-consistency of Chanin of Thoughts (CoT-SC): 제일 잘 나온 애들 중에 voting. backtracking 같은 local exploration할 수 없음. (중간에 이게 잘못됐다고 해도, 다시 고려하는 과정이 X)
Tree of Thoughts: 추론 경로 단조롭고 유연하지 않음. 만들어지는 Thoughts 대부분 버려짐.

## 슬라이드 11

Resoning 강화 모델 학습 과정

**[발표자 노트]**
https://sebastianraschka.com/blog/2025/understanding-reasoning-llms.html.

## 슬라이드 12

비추론 모델과 추론 모델

Reasoning: 논리적 단계를 통한 결론 도출 과정
Inference: 모델의 사용/실행

https://www.donga.com/news/It/article/all/20250312/131193200/1

https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-reasoning-llms

**[발표자 노트]**
https://modulabs.co.kr/blog/reasoning-model-ai
주어진 정보(전제)를 바탕으로 논리적인 단계(logical steps)를 거쳐 새로운 결론이나 판단에 이르는 인지적인 과정 / 결과가 도출된 과정을 상세히 설명
인퍼런스는 사용하는 행위에 초점, 주어진 것만 가지고 논리적으로 결론을 내리는 것

## 슬라이드 13

비추론 모델과 추론 모델

GPT-4o

GPT-o4-mini

**[발표자 노트]**
GPT-o4-mini - ReAct 구조

## 슬라이드 14

비추론 모델과 추론 모델

## 슬라이드 15

비추론 모델과 추론 모델
