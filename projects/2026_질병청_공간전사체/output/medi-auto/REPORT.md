# MeDIAuto 내부 시스템 조사 보고서

- 대상: `https://bio.urbandatalab.co.kr/` (MeDIAuto®, ©2021-2026 URBAN DATALAB)
- 조사일: 2026-07-27
- 방법: cmux 브라우저 패널로 로그인(Roy 계정, 수동 인증) 후 읽기 전용 페이지 순회·캡처
- 증빙: `screens/` 스크린샷 16장, `pages/` 화면 텍스트·DOM 스냅샷 11건

> **조사 범위 제한(의도적)**: 어노테이션 편집기와 임상정보 입력 화면은 열지 않았습니다.
> 운영 시스템에서 슬라이드가 조사자 작업으로 배정되거나 상태가 변경될 수 있어, 조사 목적 대비 위험이 크다고 판단했습니다.
> 생성·수정 폼(`*Create`, `*DetailUpdate`), 회원가입, 로그아웃 경로도 제외했습니다.

---

## 1. 결론 요약

MeDIAuto는 어반데이터랩이 자체 운영하는 병리 어노테이션 플랫폼으로, 질병청 과제 계약상 제1세부 산출물인
**"병리데이터 저작도구"의 실체**입니다. 조사 결과 시스템은 정상 가동 중이나, **세 가지 확인이 필요한 사안**이 나왔습니다.

1. **시스템 실적과 중간보고서 수치가 일치하지 않습니다** — 전립선암 이미지 수, 난소암 리뷰 수 두 곳
2. **임상정보 연계(Data Linkage)가 892건 중 0건(0.00%)** 으로 미착수 상태입니다
3. **난소암(OVCA) 라벨셋에 전립선 전용 항목(Gleason 등급 등)이 포함**되어 있습니다

---

## 2. 시스템 개요

| 항목 | 내용 |
|---|---|
| 제품명 | MeDIAuto® (등록상표 표기) |
| 운영 주체 | URBAN DATALAB |
| 기술 스택 | 서버 렌더링 + jQuery / axios 기반 XHR (SPA 아님) |
| 인증 | `POST /auth/login`, 필드 `ssid`(입력 시 자동 대문자 변환) / `password` |
| 세션 | 6시간 타이머 + `extend` 연장 버튼 |
| 가입 | 자체 회원가입 없음 — 관리자 등록제 ("After registration as a member of the manager") |
| 접속 병원 | GH : 가천대학교 길병원 **단독** |

## 3. 메뉴·라우트 구조 (총 21개)

| 대메뉴 | 경로 | 상태 |
|---|---|---|
| Home (Dashboard) | `/` | 정상 |
| BBS — Notices | `/board/notice` | **게시물 0건** |
| BBS — Resources | `/board/dataLibrary` | **게시물 0건** |
| BBS — Wiki | `/board/wikiDetail` 등 | 진입점 없음(작성/상세 경로만 존재) |
| Data Linkage | `/datalinkage/clinicInformationSystem` | 정상 |
| Annotation | `/annotation/tumorList` → `/annotation/imageList` | 정상 |
| Annotation — Label Management | `/annotation/labels` | 정상 |
| My Page — Account | `/member/mypage` | 정상 |
| My Page — My Works | `/member/myWorkStatus` | 정상 |
| Site Maintenance — Users | `/maintenance/users` | 정상 |
| Site Maintenance — Profile | `/maintenance/profile` | **404 (깨진 링크)** |

나머지 10개는 생성·수정 폼(`noticeCreate`, `wikiCreate`, `dataLibraryDetailUpdate` 등)과 `signUp`, `auth/logout`입니다.

## 4. 어노테이션 실적 (시스템 실측, 2026-07-27)

| 코드 | 프로젝트 | Images | NAS Cached | Annotation | Review | Termination | 최종 활동 |
|---|---|---|---|---|---|---|---|
| OVCA | 난소암 | 1,529 | 556 | 1,527 | 1,523 | 802 | 2026-04-01 |
| PROP | 전립선암, 수술 | 5,353 | 149 | 5,347 | 852 | 0 | 2025-12-16 |
| STOP | 위암, 수술 | 890 | 10 | 886 | 192 | 0 | 2026-02-15 |
| STER | 위암, 내시경점막절제 | 143 | 2 | 135 | 13 | 0 | 2026-02-13 |
| STBX | 위암, 내시경생검 | 4 | 0 | 3 | 2 | 0 | 2025-07-07 |
| **합계** | | **7,919** | 717 | **7,898** | **2,582** | **802** | |

- 증빙: `screens/05_annotation_tumorList.png`, `pages/05_annotation_tumorList.md`
- Termination(최종 확정) 단계까지 간 것은 **난소암 802건뿐**이며, 나머지 4개 프로젝트는 0건입니다.
- 전립선암은 **2025-12-16 이후 7개월간 활동이 없습니다.**

## 5. ★ 중간보고서와의 수치 불일치

`work/04_월간회의/7월_중간보고/공간바이오마커_중간보고회_v0.5_20260727.pptx`와 대조한 결과입니다.

| 항목 | 중간보고서 | 시스템 실측 | 차이 |
|---|---|---|---|
| 위암 이미지 | 1,037 | 1,037 (890+143+4) | 일치 ✅ |
| 난소암 이미지 | 1,529 | 1,529 | 일치 ✅ |
| **전립선암 이미지** | **3,556** | **5,353** | **+1,797** ❌ |
| 위암 리뷰 | 207 | 207 (192+13+2) | 일치 ✅ |
| 전립선암 리뷰 | 852 | 852 | 일치 ✅ |
| **난소암 리뷰** | **565** | **1,523** | **+958** ❌ |
| 전체 이미지 | 6,122 | 7,919 | +1,797 |
| 전체 리뷰 | 1,624 | 2,582 | +958 |

**주목할 점**: 위암·난소암 이미지와 위암·전립선 리뷰는 정확히 일치합니다. 즉 보고서가 전반적으로 부정확한 것이 아니라,
**딱 두 칸만 어긋나 있습니다.** 단순 집계 누락이나 갱신 시점 차이일 가능성이 높지만, 어느 쪽이든 검수 대응 전에
정정 또는 근거 정리가 필요합니다. 특히 전립선암은 보고서 기준 진척률 177.8%가 실측 기준으로는 **약 268%** 가 됩니다.

## 6. ★ 임상정보 연계(Data Linkage) — 미착수

| 프로젝트 | 등록 건수 | 연계 완료 | 완료율 |
|---|---|---|---|
| Ovary Cancer | 423 | 0 | 0.00% |
| Stomach Cancer, Operation | 216 | 0 | 0.00% |
| Prostate Cancer, Operation | 189 | 0 | 0.00% |
| Stomach, Endoscopic Resection | 61 | 0 | 0.00% |
| Stomach, Endoscopic Biopsy | 3 | 0 | 0.00% |
| **합계** | **892** | **0** | **0.00%** |

- 증빙: `screens/01_dashboard.png`, `screens/04_datalinkage.png`
- 샘플 ID는 등록되어 있으나(예: `OVCA-GH-08557`), Clinical Info 칼럼과 Last activity가 전부 비어 있습니다.
- 중간보고서의 "임상 데이터 매칭 세목·리스트업 완료, 7월부터 매칭 예정"과는 부합합니다.
- 다만 계약상 2차년도 요구사항인 **"연계 가능한 임상·역학 정보 수집·정제"** 영역이므로,
  연말 검수까지 남은 5개월 안에 892건을 처리해야 하는 일정 리스크입니다.

## 7. ★ 라벨 체계 — 난소암 라벨셋 이상

정의된 종양 코드는 6종이며, 라벨셋은 장기별로 구분되어 있습니다.

| 코드 | 라벨 구성 |
|---|---|
| STOP / STER / STBX (위) | Tumor, Inflammation, Normal_Epithelium, Normal_Muscle, Normal_Stroma, Normal_LN |
| PROP / PRBX (전립선) | Tumor, Normal_Prostate, Normal_Extra, Normal_LN, Gleason 3, Gleason 4, Gleason 5 |
| **OVCA (난소)** | **Tumor, Normal_Prostate(전립선), Normal_Extra(전립선 외부), Normal_LN, Gleason 3, Gleason 4, Gleason 5**, LN_malignant, TP_borderline, TP_malignant |

- 증빙: `screens/06a_labels_OVCA.png`, `screens/06b_labels_STOP.png`
- 난소암 라벨셋의 앞 7개 항목이 **전립선 라벨셋과 완전히 동일**합니다. Gleason 점수는 전립선암 등급체계이고
  `Normal_Prostate(전립선)`은 난소 조직에 해당하지 않습니다.
- 난소 고유 라벨로 보이는 것은 뒤의 3개(`LN_malignant`, `TP_borderline`, `TP_malignant`)뿐입니다.
- **추정**: 전립선 라벨셋을 복제해 난소 항목을 추가하면서 원본 항목을 정리하지 않은 것으로 보입니다.
- **확인 필요**: 난소암 1,527건 어노테이션에 전립선 라벨이 실제로 사용된 사례가 있는지.
  사용됐다면 GT 품질 문제로 직결되고, 사용되지 않았다면 라벨 목록 정리만으로 해결됩니다.

## 8. 사용자·권한 현황

| No | Member ID | Nickname | 소속 | 등록일 | 권한 | 비밀번호 상태 |
|---|---|---|---|---|---|---|
| 1 | UB101 | — | URBANDATALAB | 2025-09-03 | PP | **Temporary** |
| 2 | UB102 | 어반 | URBANDATALAB | 2025-11-24 | PP | Certification |
| 3 | URBANDATALAB | URBANDATALAB | URBANDATALAB | 2026-01-26 | PP | Certification |

- 조회 범위는 URBANDATALAB 소속 3계정입니다(로그인 계정 소속 기준으로 보임).
- **UB101이 2025-09-03 등록 이후 약 11개월간 `Temporary` 비밀번호 상태로 남아 있습니다.** 미사용 계정이면 비활성화가 안전합니다.
- 길병원 병리 전문의 리뷰어 계정은 이 목록에 보이지 않습니다 — 별도 소속으로 관리되는지 확인이 필요합니다.

## 9. 기타 관찰

- **BBS(공지사항·자료실)가 전부 비어 있습니다.** 다기관 협업 과제임에도 시스템 내 공지·자료 공유 기능이 사용되지 않고 있습니다.
- **My Works**: Clinical Info 0건 / Annotation Info 1건 (조사 계정 기준).
- **PRBX(전립선 생검)** 는 종양 코드와 라벨셋이 정의돼 있으나 어노테이션 프로젝트 목록에는 없습니다 — 정의만 되고 미사용.
- **NAS 캐시 비율이 낮습니다**: 전체 7,919건 중 717건(9.1%)만 캐시. 전립선암은 5,353건 중 149건(2.8%).
  작업 시 원본 로딩 지연 요인이 될 수 있습니다.
- 조사 후반부에 어노테이션 목록 테이블이 반복적으로 렌더링되지 않는 현상이 있었습니다(세션은 유지, JS 오류 없음).
  자동화 요청 빈도 때문일 수 있어 단정하지 않으나, 목록 조회 API 응답 안정성은 별도 점검 대상입니다.

## 10. 조치 제안 (우선순위)

| 순위 | 항목 | 사유 |
|---|---|---|
| 1 | 중간보고서 수치 정정 또는 근거 정리 | 검수 시 시스템 대조하면 즉시 드러남. 전립선 이미지·난소 리뷰 2개 항목 |
| 2 | 임상정보 연계 892건 착수 계획 확정 | 0% 상태, 계약 요구사항, 잔여 5개월 |
| 3 | OVCA 라벨셋의 전립선 항목 사용 이력 점검 | 사용됐다면 GT 품질 이슈, 아니면 목록 정리 |
| 4 | 전립선암 리뷰 재개 | 2025-12-16 이후 활동 없음, 리뷰 852/5,347 (15.9%) |
| 5 | UB101 계정 정리 | 11개월간 Temporary 비밀번호 |
| 6 | `/maintenance/profile` 404 수정 | 메뉴에 노출되는 깨진 링크 |

---

## 부록: 증빙 파일

| 파일 | 내용 |
|---|---|
| `screens/00_login.png` | 로그인 화면 |
| `screens/01_dashboard.png` | 대시보드 — 전체 작업 현황 |
| `screens/02_notice.png`, `03_dataLibrary.png` | BBS (공란) |
| `screens/04_datalinkage.png` | 임상정보 연계 목록 |
| `screens/05_annotation_tumorList.png` | 프로젝트별 어노테이션 실적 |
| `screens/05a_imagelist_OVCA.png`, `05b_imagelist_PROP.png` | WSI 단위 목록 |
| `screens/06_annotation_labels.png`, `06a_labels_OVCA.png`, `06b_labels_STOP.png` | 라벨 체계 |
| `screens/07_mypage.png`, `08_myWorkStatus.png` | 계정·작업 현황 |
| `screens/09_maintenance_users.png` | 사용자 관리 |
| `screens/10_maintenance_profile.png` | 404 화면 |
| `pages/*.md` | 각 화면의 텍스트·조작요소·내부링크 스냅샷 |
