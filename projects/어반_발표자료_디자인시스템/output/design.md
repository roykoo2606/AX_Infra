# Urban Data Lab Presentation Design System

> Version 1.0 · 2026-07-27  
> 상태: 실행 규격  
> 기준 캔버스: 1600×900 CSS px · 출력: 3200×1800 px  
> 언어 규칙: 설명은 한국어, 코드·토큰명·주석은 영어

## 0. 문서의 목적과 적용 범위

이 문서는 어반데이터랩의 발표자료를 HTML로 조립하고 PNG로 렌더하기 위한 상위 실행 규격이다. 표지, 사업 소개, 기술 설명, 의료·병리 데이터, KPI, 표, 프로세스, 아키텍처, 차트에 공통 적용한다.

에이전트는 다음 순서로 작업한다.

1. 발표 목적, 청중, 핵심 메시지, 슬라이드별 콘텐츠를 확정한다.
2. 이 문서의 토큰을 그대로 복사하고 `data-theme="dark"` 또는 `data-theme="light"`를 선택한다.
3. 슬라이드 유형을 선택하고 카탈로그의 컴포넌트를 조립한다.
4. 실사 이미지와 아이콘은 각각 §8, §7의 규칙으로 준비한다.
5. 1600×900 HTML을 Chromium에서 device scale factor 2로 렌더한다.
6. §13 체크리스트를 통과한 3200×1800 PNG만 PPTX에 삽입한다.

우선순위는 `웹사이트 현행 CI > MEDICUS IR Book > 2026 산업부 발표자료의 폰트·구조`이다. 산업부 자료의 골드와 명조 헤드라인은 전사 규격이 아니며 §14의 맥락 변형으로만 다룬다.

## 1. 근거와 결정 원칙

| ID | 출처 | 채택 범위 |
|---|---|---|
| `WEB` | `workspace/_근거/website_home.png`, `_logo_crop.png` | 최우선 브랜드 색, 로고의 쿨 스펙트럼 |
| `IR` | `source/IR_Book_260330.pdf`, `workspace/_근거/irbook/` | 딥네이비, 블루·시안·퍼플 보조색, 의료 AI 비주얼 |
| `RND` | `source/RS-2026-25618140_2세부_어반데이터랩_v3.3.pptx` | 16:9 구조, Paperlogy 위계, 정보 밀도 |
| `HTML` | `source/발표장표_HTML/*mode구동*.html` | 1600×900 캔버스, 안전 여백, mode 구동 방식 |

다음 값은 출처에서 직접 추출된 값이다.

- `#14DEAF`, `#33C3C6`, `#108CEB`, `#745CED`: 웹사이트 로고의 좌→우 그라디언트 `[WEB]`
- `#00FFCB`: 웹사이트 우상단 시그니처 액센트 `[WEB]`
- `#0A082B`: 웹사이트 딥 배경 `[WEB]`
- `#000050`, `#5080F0`, `#A050F0`, `#10B0E0`, `#90C0F0`: IR Book의 채도 상위 색 `[IR]`
- Paperlogy 4/5/6/7/8/9와 Freesentation: PPTX 폰트 집계 `[RND]`
- 1600×900, 좌 78px·우 70px·상 54px·하 46px: mode 구동 HTML의 공통 구조 `[HTML]`

그 외 간격·크기·투명도는 위 구조를 8px 기반으로 정규화한 이 문서의 규범값이다. 구현자가 임의 변경하지 않는다.

## 2. 캔버스와 안전 영역

```css
* { box-sizing: border-box; }

html,
body {
  width: 1600px;
  height: 900px;
  margin: 0;
  overflow: hidden;
}

.slide {
  position: relative;
  width: 1600px;
  height: 900px;
  padding: 54px 70px 46px 78px;
  overflow: hidden;
  isolation: isolate;
}

.safe-area {
  position: absolute;
  inset: 54px 70px 46px 78px;
  pointer-events: none;
}
```

| 항목 | 값 | 판정 |
|---|---:|---|
| 화면 비율 | 16:9 | 변경 금지 |
| 작업 캔버스 | 1600×900 CSS px | 변경 금지 |
| 최종 PNG | 3200×1800 px | device scale factor 2 |
| 안전 영역 | x=78~1530, y=54~854 | 본문·로고·페이지 번호가 안쪽에 있어야 함 |
| 풀블리드 허용 | 배경, 장식 그래픽, 마스크된 실사 이미지 | 텍스트에는 금지 |
| 최소 출력 여백 | 좌 156px, 우 140px, 상 108px, 하 92px | @2x 기준 |

## 3. 디자인 토큰

### 3.1 복사할 기준 CSS

```css
:root {
  /* Brand colors — WEB */
  --brand-mint: #14DEAF;
  --brand-teal: #33C3C6;
  --brand-blue: #108CEB;
  --brand-purple: #745CED;
  --brand-accent: #00FFCB;
  --brand-deep: #0A082B;

  /* MEDICUS colors — IR */
  --medicus-navy: #000050;
  --medicus-blue: #5080F0;
  --medicus-purple: #A050F0;
  --medicus-cyan: #10B0E0;
  --medicus-blue-soft: #90C0F0;

  /* Semantic colors */
  --positive: #14DEAF;
  --info: #108CEB;
  --highlight: #745CED;
  --focus: #00FFCB;

  /* Typography */
  --font-primary: "Paperlogy", "페이퍼로지", sans-serif;
  --font-secondary: "Freesentation", sans-serif;
  --weight-regular: 400;
  --weight-medium: 500;
  --weight-semibold: 600;
  --weight-bold: 700;
  --weight-extrabold: 800;
  --weight-black: 900;

  /* Spacing */
  --space-1: 8px;
  --space-2: 12px;
  --space-3: 16px;
  --space-4: 24px;
  --space-5: 32px;
  --space-6: 40px;
  --space-7: 48px;
  --space-8: 64px;
  --space-9: 80px;

  /* Geometry */
  --radius-sm: 8px;
  --radius-md: 14px;
  --radius-lg: 24px;
  --radius-pill: 999px;
  --stroke-hairline: 1px;
  --stroke-default: 2px;
  --stroke-emphasis: 4px;

  /* Brand gradients */
  --gradient-brand: linear-gradient(
    90deg,
    #14DEAF 0%,
    #33C3C6 34%,
    #108CEB 67%,
    #745CED 100%
  );
  --gradient-data: linear-gradient(135deg, #10B0E0 0%, #5080F0 52%, #A050F0 100%);

  /* Layering */
  --z-bg: 0;
  --z-decor: 10;
  --z-content: 20;
  --z-overlay: 30;
  --z-meta: 40;
}

:root,
[data-theme="dark"] {
  color-scheme: dark;
  --canvas: #0A082B;
  --surface-1: rgba(255, 255, 255, 0.06);
  --surface-2: rgba(255, 255, 255, 0.10);
  --text-primary: #FFFFFF;
  --text-secondary: rgba(255, 255, 255, 0.72);
  --text-tertiary: rgba(255, 255, 255, 0.52);
  --border: rgba(144, 192, 240, 0.24);
  --grid-line: rgba(144, 192, 240, 0.16);
  --scrim: rgba(10, 8, 43, 0.78);
  --shadow-card: 0 24px 56px -20px rgba(0, 0, 80, 0.72);
}

[data-theme="light"] {
  color-scheme: light;
  --canvas: #FFFFFF;
  --surface-1: rgba(10, 8, 43, 0.04);
  --surface-2: rgba(16, 140, 235, 0.08);
  --text-primary: #0A082B;
  --text-secondary: rgba(10, 8, 43, 0.72);
  --text-tertiary: rgba(10, 8, 43, 0.52);
  --border: rgba(10, 8, 43, 0.16);
  --grid-line: rgba(10, 8, 43, 0.10);
  --scrim: rgba(10, 8, 43, 0.68);
  --shadow-card: 0 24px 56px -20px rgba(0, 0, 80, 0.28);
}

body {
  background: var(--canvas);
  color: var(--text-primary);
  font-family: var(--font-primary);
  -webkit-font-smoothing: antialiased;
  text-rendering: geometricPrecision;
}
```

`#FFFFFF`은 웹사이트의 흰 배경 및 로고 워드마크 대비를 위한 무채색 기반값이다. 색조가 있는 신규 HEX를 임의 추가하지 않는다. 새로운 면 색은 위 브랜드색 또는 무채색의 alpha 조합으로 만든다.

### 3.2 모드 구동

하나의 HTML에서 `?theme=dark` 또는 `?theme=light`로 구동한다. 쿼리가 없으면 `dark`를 사용한다.

```html
<html lang="ko" data-theme="dark">
<body>
  <main class="slide">...</main>
  <script>
    const params = new URLSearchParams(location.search);
    const theme = params.get("theme");
    document.documentElement.dataset.theme =
      theme === "light" ? "light" : "dark";
  </script>
</body>
</html>
```

다크와 라이트는 구조, 간격, 타이포 크기가 동일해야 한다. 테마별 별도 HTML을 만들지 않는다.

### 3.3 색 사용 비율

한 장의 면적 기준으로 아래 범위를 지킨다.

| 역할 | 비율 |
|---|---:|
| `--canvas`와 무채색 면 | 72~88% |
| 브랜드 블루·퍼플 면 | 8~20% |
| 민트·틸 강조 | 2~8% |
| `--brand-accent` 단색 | 0.5~2% |

`--brand-accent`는 포커스 점, 선택 상태, 핵심 수치 밑줄에만 쓴다. 넓은 배경에는 쓰지 않는다.

## 4. 타이포그래피

### 4.1 폰트 정책

- HTML/CSS의 주력 스택은 `"Paperlogy", "페이퍼로지", sans-serif`이다.
- PowerPoint의 글꼴명은 영문 `Paperlogy`로 저장한다.
- 한글 이름 `페이퍼로지`는 CSS 로컬 폴백으로만 둔다.
- Freesentation은 영문 숫자, 조밀한 축 라벨, 보조 메타에만 허용한다.
- 금지: `AppleMyungjo`, `Songti SC`, `Apple SD Gothic Neo`, `Pretendard`.
- 이탤릭을 합성하지 않는다. 강조는 웨이트와 색으로 처리한다.

### 4.2 역할별 스케일

| 역할 | 크기 | 웨이트 | 행간 | 자간 | 최대 행 |
|---|---:|---:|---:|---:|---:|
| `display` | 82px | 900 | 1.08 | -0.035em | 3 |
| `h1` | 60px | 800 | 1.12 | -0.030em | 2 |
| `h2` | 40px | 700 | 1.20 | -0.025em | 2 |
| `h3` | 28px | 700 | 1.28 | -0.015em | 2 |
| `eyebrow` | 15px | 800 | 1.20 | 0.120em | 1 |
| `body-lg` | 22px | 500 | 1.55 | -0.010em | 5 |
| `body` | 18px | 400 | 1.60 | -0.010em | 7 |
| `caption` | 13px | 600 | 1.45 | 0.010em | 2 |
| `meta` | 12px | 500 | 1.45 | 0.050em | 2 |
| `kpi` | 56px | 900 | 1.00 | -0.030em | 1 |

```css
.t-display { font-size: 82px; font-weight: 900; line-height: 1.08; letter-spacing: -0.035em; }
.t-h1 { font-size: 60px; font-weight: 800; line-height: 1.12; letter-spacing: -0.03em; }
.t-h2 { font-size: 40px; font-weight: 700; line-height: 1.2; letter-spacing: -0.025em; }
.t-h3 { font-size: 28px; font-weight: 700; line-height: 1.28; letter-spacing: -0.015em; }
.t-eyebrow { font-size: 15px; font-weight: 800; line-height: 1.2; letter-spacing: 0.12em; }
.t-body-lg { font-size: 22px; font-weight: 500; line-height: 1.55; letter-spacing: -0.01em; }
.t-body { font-size: 18px; font-weight: 400; line-height: 1.6; letter-spacing: -0.01em; }
.t-caption { font-size: 13px; font-weight: 600; line-height: 1.45; letter-spacing: 0.01em; }
.t-meta { font-family: var(--font-secondary); font-size: 12px; font-weight: 500; line-height: 1.45; letter-spacing: 0.05em; }
.t-kpi { font-size: 56px; font-weight: 900; line-height: 1; letter-spacing: -0.03em; }
```

한글 제목은 의미 단위로 수동 줄바꿈한다. 제목에 `word-break: keep-all`, 본문에 `overflow-wrap: break-word`를 적용한다. 본문을 18px 아래로 줄여 내용을 억지로 넣지 않는다.

## 5. 레이아웃 그리드와 계층

안전 영역 너비 1452px를 12컬럼, 간격 24px로 나눈다. 컬럼 한 칸의 계산값은 99px이다.

```css
.grid-12 {
  display: grid;
  grid-template-columns: repeat(12, minmax(0, 1fr));
  column-gap: 24px;
}

.span-3 { grid-column: span 3; }
.span-4 { grid-column: span 4; }
.span-5 { grid-column: span 5; }
.span-6 { grid-column: span 6; }
.span-7 { grid-column: span 7; }
.span-8 { grid-column: span 8; }
.span-12 { grid-column: 1 / -1; }
```

| 영역 | 규격 |
|---|---|
| Top meta bar | y=54px, 높이 24px |
| Title band | y=126~260px |
| Main content | y=286~782px |
| Footer | y=816~854px |
| 콘텐츠 간 기본 간격 | 24px |
| 큰 섹션 간격 | 40px |

레이어는 `background(0) → decoration(10) → content(20) → overlay(30) → meta(40)` 순서다. 텍스트 위에 장식이 올라오지 않도록 한다.

## 6. 컴포넌트 카탈로그

모든 스니펫은 §3 토큰 CSS가 먼저 로드됐다는 전제다.

### 6.1 표지 `cover`

용도: 프레젠테이션 첫 장. 제목 하나, 부제 하나, 메타 한 묶음, 대표 이미지 하나만 사용한다.

```html
<main class="slide cover">
  <div class="cover__glow" aria-hidden="true"></div>
  <header class="meta-bar">
    <span class="meta-bar__brand">URBAN DATA LAB</span>
    <span>2026 · COMPANY PRESENTATION</span>
  </header>
  <section class="cover__copy">
    <p class="t-eyebrow">AI × BIOMEDICAL DATA</p>
    <h1 class="t-display">데이터로 의료의<br><span>다음을 설계합니다</span></h1>
    <p class="t-body-lg">임상·오믹스 데이터와 AI를 연결하는 의료 데이터 기업</p>
  </section>
  <figure class="image-card cover__visual">
    <img src="hero.jpg" alt="의료 데이터 분석 장면">
    <figcaption>AI-assisted biomedical data analysis · Generated visual</figcaption>
  </figure>
  <footer class="footer-rule"><span>CONFIDENTIAL</span><span>01</span></footer>
</main>
```

```css
.cover { background: var(--canvas); }
.cover::before {
  content: "";
  position: absolute;
  inset: 0;
  z-index: var(--z-decor);
  background: radial-gradient(circle at 76% 38%, rgba(16, 140, 235, 0.24), transparent 34%);
}
.cover__copy { position: absolute; left: 78px; top: 214px; width: 680px; z-index: var(--z-content); }
.cover__copy .t-eyebrow { color: var(--brand-mint); margin: 0 0 24px; }
.cover__copy h1 { margin: 0; }
.cover__copy h1 span {
  background: var(--gradient-brand);
  color: transparent;
  -webkit-background-clip: text;
  background-clip: text;
}
.cover__copy .t-body-lg { width: 600px; margin: 32px 0 0; color: var(--text-secondary); }
.cover__visual { position: absolute; right: 70px; top: 150px; width: 650px; height: 520px; z-index: var(--z-content); }
```

사용 조건: 제목 22자 이내, 부제 45자 이내. 금지: 로고 그라디언트와 무관한 색, 콜라주 3개 이상, 제목 위 장식 배치.

### 6.2 섹션 구분 `section-divider`

용도: 큰 장 전환. 섹션 번호, 제목, 한 문장만 둔다.

```html
<main class="slide section-divider">
  <p class="section-divider__index">02</p>
  <div class="section-divider__rule"></div>
  <h1 class="t-display">Technology</h1>
  <p class="t-body-lg">의료 데이터를 제품 가치로 전환하는 핵심 기술</p>
</main>
```

```css
.section-divider {
  display: flex;
  flex-direction: column;
  justify-content: center;
  background:
    radial-gradient(circle at 82% 50%, rgba(116, 92, 237, 0.28), transparent 34%),
    var(--canvas);
}
.section-divider__index { margin: 0 0 16px; color: var(--brand-mint); font: 800 15px/1 var(--font-primary); letter-spacing: .12em; }
.section-divider__rule { width: 160px; height: 6px; margin-bottom: 32px; border-radius: 999px; background: var(--gradient-brand); }
.section-divider h1 { margin: 0; }
.section-divider .t-body-lg { width: 720px; margin: 32px 0 0; color: var(--text-secondary); }
```

사용 조건: 대분류 전환에만 사용. 금지: 표, 차트, KPI를 같은 장에 배치.

### 6.3 상단 메타바 `meta-bar`

```html
<header class="meta-bar">
  <span class="meta-bar__brand">URBAN DATA LAB · MEDICUS</span>
  <span>TECHNOLOGY / 02</span>
</header>
```

```css
.meta-bar {
  position: absolute;
  top: 54px;
  left: 78px;
  right: 70px;
  z-index: var(--z-meta);
  display: flex;
  align-items: center;
  justify-content: space-between;
  font: 600 12px/1.45 var(--font-secondary);
  letter-spacing: .05em;
  color: var(--text-tertiary);
}
.meta-bar__brand { color: var(--brand-mint); font-weight: 700; }
```

사용 조건: 표지를 포함한 모든 장에서 동일 위치. 금지: 본문 제목보다 강한 대비, 두 줄 메타.

### 6.4 카피블록 `copy-block`

```html
<section class="copy-block">
  <p class="t-eyebrow">CORE CAPABILITY</p>
  <h2 class="t-h1">멀티모달 데이터를<br>하나의 분석 흐름으로</h2>
  <p class="t-body-lg">임상, 영상, 병리, 오믹스 데이터를 표준화하고 AI-ready 데이터로 전환합니다.</p>
</section>
```

```css
.copy-block { max-width: 680px; }
.copy-block .t-eyebrow { margin: 0 0 16px; color: var(--brand-blue); }
.copy-block .t-h1 { margin: 0; word-break: keep-all; }
.copy-block .t-body-lg { margin: 24px 0 0; color: var(--text-secondary); word-break: keep-all; }
```

사용 조건: 한 블록에 주장 하나. 금지: 본문 5줄 초과, 서로 다른 강조색 3개 이상.

### 6.5 이미지 카드 `image-card`

```html
<figure class="image-card">
  <img src="pathology.jpg" alt="H&E 병리 슬라이드">
  <span class="pill image-card__tag">H&amp;E PATHOLOGY</span>
  <figcaption>신장암 H&amp;E 병리 이미지 · Source: 기관명, 2026</figcaption>
</figure>
```

```css
.image-card {
  position: relative;
  margin: 0;
  overflow: hidden;
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  background: var(--surface-1);
  box-shadow: var(--shadow-card);
}
.image-card img { width: 100%; height: 100%; display: block; object-fit: cover; }
.image-card::after {
  content: "";
  position: absolute;
  inset: auto 0 0;
  height: 28%;
  background: linear-gradient(transparent, var(--scrim));
}
.image-card__tag { position: absolute; top: 16px; right: 16px; z-index: 2; }
.image-card figcaption {
  position: absolute;
  left: 16px;
  right: 16px;
  bottom: 14px;
  z-index: 2;
  font: 600 13px/1.45 var(--font-primary);
  color: #FFFFFF;
}
```

사용 조건: 출처 또는 `Generated visual`을 반드시 표기. 금지: 원본 종횡비 왜곡, 캡션 없는 생성 이미지.

### 6.6 Pill 태그 `pill`

```html
<span class="pill">AI &amp; DATA</span>
<span class="pill pill--active">BIOMARKER</span>
```

```css
.pill {
  display: inline-flex;
  align-items: center;
  min-height: 30px;
  padding: 6px 14px;
  border: 1px solid var(--border);
  border-radius: var(--radius-pill);
  background: var(--surface-1);
  color: var(--text-secondary);
  font: 700 12px/1 var(--font-secondary);
  letter-spacing: .08em;
}
.pill--active { border-color: var(--brand-mint); color: var(--brand-mint); }
```

사용 조건: 분류·상태만 표현. 금지: 한 장 6개 초과, 문장형 콘텐츠, pill 내부 아이콘 남용.

### 6.7 KPI·수치 타일 `kpi-tile`

```html
<article class="kpi-tile">
  <p class="kpi-tile__label">AI-ready datasets</p>
  <p class="kpi-tile__value">98,000<span>+</span></p>
  <p class="kpi-tile__note">임상·병리·오믹스 통합 기준</p>
</article>
```

```css
.kpi-tile {
  min-height: 180px;
  padding: 24px;
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  background: var(--surface-1);
}
.kpi-tile__label { margin: 0 0 24px; color: var(--text-secondary); font: 600 13px/1.45 var(--font-secondary); }
.kpi-tile__value { margin: 0; color: var(--text-primary); font: 900 56px/1 var(--font-primary); letter-spacing: -.03em; }
.kpi-tile__value span { margin-left: 4px; color: var(--brand-mint); font-size: 28px; }
.kpi-tile__note { margin: 16px 0 0; color: var(--text-tertiary); font: 500 13px/1.45 var(--font-primary); }
```

사용 조건: 한 타일에 수치 하나, 단위와 기준일 명시. 금지: 출처 없는 숫자, 5개 이상의 KPI 타일.

### 6.8 표 `data-table`

```html
<table class="data-table">
  <thead><tr><th>구분</th><th>입력</th><th>처리</th><th>산출</th></tr></thead>
  <tbody>
    <tr><th>병리</th><td>WSI</td><td>세포 분할</td><td>정량 지표</td></tr>
    <tr><th>오믹스</th><td>RNA/Protein</td><td>표준화</td><td>바이오마커</td></tr>
  </tbody>
</table>
```

```css
.data-table { width: 100%; border-collapse: collapse; table-layout: fixed; font-size: 18px; }
.data-table th,
.data-table td { height: 64px; padding: 14px 16px; border-bottom: 1px solid var(--grid-line); text-align: left; vertical-align: middle; }
.data-table thead th { color: var(--brand-mint); font-weight: 700; background: var(--surface-2); }
.data-table tbody th { color: var(--text-primary); font-weight: 700; }
.data-table td { color: var(--text-secondary); font-weight: 400; }
```

사용 조건: 열 6개 이하, 행 7개 이하. 금지: 세로선 전부 표시, 16px 미만 글자, 셀 안 긴 문단.

### 6.9 프로세스·플로우 `process-flow`

```html
<ol class="process-flow">
  <li><span>01</span><strong>Collect</strong><small>임상·병리·오믹스</small></li>
  <li><span>02</span><strong>Standardize</strong><small>품질관리·비식별</small></li>
  <li><span>03</span><strong>Learn</strong><small>멀티모달 AI</small></li>
  <li><span>04</span><strong>Deploy</strong><small>SaMD·IVD</small></li>
</ol>
```

```css
.process-flow { display: grid; grid-template-columns: repeat(4, 1fr); gap: 24px; margin: 0; padding: 0; list-style: none; }
.process-flow li {
  position: relative;
  min-height: 190px;
  padding: 24px;
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  background: var(--surface-1);
}
.process-flow li:not(:last-child)::after {
  content: "→";
  position: absolute;
  right: -20px;
  top: 76px;
  z-index: 2;
  color: var(--brand-blue);
  font-size: 28px;
  font-weight: 700;
}
.process-flow span { display: block; color: var(--brand-mint); font: 700 13px/1 var(--font-secondary); }
.process-flow strong { display: block; margin-top: 32px; color: var(--text-primary); font-size: 24px; }
.process-flow small { display: block; margin-top: 12px; color: var(--text-secondary); font-size: 15px; line-height: 1.45; }
```

사용 조건: 순차 흐름 3~6단계. 금지: 이모지 아이콘, 교차 화살표, 역방향 흐름을 설명 없이 혼합.

### 6.10 하단 푸터 룰 `footer-rule`

```html
<footer class="footer-rule">
  <span>© URBAN DATA LAB · INTERNAL</span>
  <span>12</span>
</footer>
```

```css
.footer-rule {
  position: absolute;
  left: 78px;
  right: 70px;
  bottom: 46px;
  z-index: var(--z-meta);
  display: flex;
  justify-content: space-between;
  padding-top: 14px;
  border-top: 1px solid var(--border);
  color: var(--text-tertiary);
  font: 500 12px/1 var(--font-secondary);
  letter-spacing: .05em;
}
.footer-rule::before {
  content: "";
  position: absolute;
  top: -1px;
  left: 0;
  width: 160px;
  height: 2px;
  background: var(--gradient-brand);
}
```

사용 조건: 표지의 페이지 번호는 생략 가능. 금지: 날짜·저작권·보안등급·페이지 번호를 3곳 이상 분산.

## 7. 아이콘 설계 규칙

### 7.1 규격

| 항목 | 값 |
|---|---|
| 기본 그리드 | 24×24 |
| 확대 그리드 | 48×48 |
| 스타일 | outline, round cap, round join |
| 24px 스트로크 | 2px |
| 48px 스트로크 | 3px |
| 내부 여백 | 2px |
| 모서리 반경 | 2px 또는 원형 |
| 기본색 | `currentColor` |
| 강조 | 아이콘 전체가 아니라 점·노드 1개에 `--brand-mint` |

```html
<span class="icon" aria-hidden="true">
  <svg viewBox="0 0 24 24" fill="none">
    <path d="M4 12h16M12 4v16" />
    <circle cx="12" cy="12" r="8" />
  </svg>
</span>
```

```css
.icon { display: inline-grid; width: 24px; height: 24px; color: var(--brand-blue); place-items: center; }
.icon svg { width: 100%; height: 100%; }
.icon path,
.icon circle { stroke: currentColor; stroke-width: 2; stroke-linecap: round; stroke-linejoin: round; vector-effect: non-scaling-stroke; }
```

금지: 이모지, 3D 아이콘, 서로 다른 라이브러리 혼합, 면적의 30%가 넘는 단색 채움, 광택·금속 질감.

### 7.2 아이콘 생성 프롬프트

```text
Create a single 24×24 SVG outline icon for [CONCEPT].
Use a 2px stroke, round caps, round joins, no fill, and a 2px safe inset.
Use currentColor for every stroke. Keep the silhouette legible at 24px.
No text, emoji, gradients, shadows, 3D, decorative background, or raster content.
Return only valid standalone SVG markup with viewBox="0 0 24 24".
```

생성 후 `viewBox`, `fill="none"`, 스트로크 수치, 24px 축소 가독성을 확인한다.

## 8. 실사 이미지 활용 규칙

### 8.1 사용 기준

실사는 다음 경우에만 사용한다.

- 의료진·연구자·실험실 등 실제 업무 맥락을 보여줄 때
- 병리 WSI, H&E, 공간전사체, 의료영상처럼 데이터 자체가 증거일 때
- 표지에서 기술의 인간적 의미를 전달할 때

추상 개념, 순서, 시스템 관계는 실사 대신 아이콘·다이어그램으로 표현한다.

### 8.2 프레이밍과 보정

- 카드 비율은 4:3, 3:2, 1:1 중 하나다.
- `object-fit: cover`를 사용하되 병변, 세포군, 인물 얼굴을 임의 절단하지 않는다.
- 다크 모드에서는 `#0A082B` 스크림 18~34%, 라이트 모드에서는 0~12%를 사용한다.
- 브랜드 그라디언트는 이미지 위 전체 필터가 아니라 테두리, 라이트 글로우, 구분선 중 한 곳에만 쓴다.
- 병리·의료영상의 진단 색은 변경하지 않는다. 장식용 색보정과 정량 분석 이미지를 혼동하지 않는다.
- 생성 이미지는 캡션 끝에 `Generated visual`을 표기한다.
- 실제 환자 데이터는 승인된 비식별 자료만 사용하고, 생성 프롬프트에 실명·식별자를 넣지 않는다.

```css
.image-tone--dark img { filter: saturate(.92) contrast(1.06) brightness(.88); }
.image-tone--dark::before {
  content: "";
  position: absolute;
  inset: 0;
  z-index: 1;
  background: rgba(10, 8, 43, .24);
  pointer-events: none;
}
.image-tone--clinical img { filter: none; }
```

### 8.3 일반 생성 프롬프트

```text
Editorial corporate photography for Urban Data Lab, [SUBJECT], biomedical AI and data context,
precise clinical environment, realistic materials and lighting, deep navy #0A082B atmosphere,
controlled cyan-blue accent lighting inspired by #14DEAF and #108CEB,
clean negative space for Korean presentation copy, 16:9 composition, high detail,
no visible logo, no readable UI text, no watermark, no neon cyberpunk, no stock-photo handshake.
```

### 8.4 의료·병리 생성 프롬프트

```text
Scientifically plausible editorial visualization of [PATHOLOGY OR MEDICAL DOMAIN],
clearly labeled as a generated conceptual visual, non-identifiable synthetic patient context,
accurate laboratory equipment and clinical workflow, natural tissue morphology,
deep navy #0A082B background with restrained cyan #10B0E0 and blue #5080F0 accents,
large clean negative space, 16:9, no diagnostic claim, no patient identifier,
no gore, no watermark, no fake institution logo, no illegible interface text.
```

진단 근거로 쓰는 병리 이미지는 생성하지 않는다. 생성 이미지는 개념 설명과 표지에만 사용한다.

## 9. 기존 스킬 연동

아래 블록은 각 스킬 호출 프롬프트의 앞부분에 그대로 붙인다. 스킬 자체를 복제하거나 수정하지 않는다.

### 9.1 공통 브랜드 컨텍스트 블록

```text
[URBAN DATA LAB BRAND CONTEXT]
Canvas: 1600×900 CSS px; render 3200×1800 at deviceScaleFactor 2.
Safe area: top 54px, right 70px, bottom 46px, left 78px.
Default theme: dark.
Primary font: Paperlogy; CSS fallback: "페이퍼로지", sans-serif.
Secondary font: Freesentation, used only for compact Latin numerals and metadata.
Brand gradient: #14DEAF → #33C3C6 → #108CEB → #745CED.
Accent: #00FFCB, limited to 0.5–2% of slide area.
Dark canvas: #0A082B. Light canvas: #FFFFFF.
MEDICUS support colors: #000050, #5080F0, #A050F0, #10B0E0, #90C0F0.
Use 12 columns with 24px gutters. Card radius 14px. Default stroke 2px.
Use exact numeric values; do not invent additional colored HEX values.
No AppleMyungjo, Songti SC, Apple SD Gothic Neo, Pretendard, emoji, 3D icons, or gold.
All text must stay inside the safe area. Korean headings use word-break: keep-all.
```

### 9.2 `infographic-builder`

```text
[INFOGRAPHIC-BUILDER OVERRIDE]
Apply the URBAN DATA LAB BRAND CONTEXT.
Use the design tokens and components named meta-bar, copy-block, pill, kpi-tile,
data-table, process-flow, image-card, and footer-rule.
Build a self-contained 1600×900 HTML file with one data-theme attribute.
Represent hierarchy with size and spacing before color. Maximum 5 KPI tiles,
6 table columns, 7 table rows, or 6 process steps per slide.
Render with Chromium at deviceScaleFactor 2 and verify a 3200×1800 PNG.
```

### 9.3 `archify`

```text
[ARCHIFY OVERRIDE]
Apply the URBAN DATA LAB BRAND CONTEXT.
Diagram canvas is transparent over the slide canvas.
Node fill: var(--surface-1); node border: 2px var(--border); radius: 14px.
Primary path: 3px #108CEB. Secondary path: 2px rgba(144,192,240,.52).
Selected node: 2px #14DEAF. Terminal/result node: 2px #745CED.
Arrowheads are 8px, solid, and match their path color.
Node labels use Paperlogy 600 at 18px; metadata uses Freesentation 500 at 12px.
Use left-to-right flow by default. Avoid crossing paths; use swimlanes for ownership.
Keep all labels horizontal. Do not use gold, emoji, 3D, or free-floating decorative nodes.
```

### 9.4 `dataviz`

```text
[DATAVIZ OVERRIDE]
Apply the URBAN DATA LAB BRAND CONTEXT.
Categorical series order:
1 #108CEB, 2 #14DEAF, 3 #745CED, 4 #10B0E0, 5 #A050F0, 6 #90C0F0.
Sequential scale: #90C0F0 → #5080F0 → #000050.
Diverging comparison: #14DEAF for positive, #745CED for negative, #90C0F0 for neutral.
Chart background is transparent. Axis and grid use var(--grid-line).
Axis labels: Freesentation 500 at 12px. Data labels: Paperlogy 600 at 13px.
Direct-label up to 4 series; otherwise use a top-aligned legend.
Start bar-chart quantitative axes at zero. State units, period, sample size, and source.
Do not use 3D, pie charts with more than 4 slices, rainbow palettes, or gold.
```

## 10. 슬라이드 유형별 템플릿

| 유형 | 구조 | 콘텐츠 제한 |
|---|---|---|
| 표지 | meta + 5컬럼 카피 + 7컬럼 실사 + footer | 제목 3행, 이미지 1개 |
| 목차 | 제목 + 2열 또는 3열 섹션 목록 | 6개 섹션 이하 |
| 본문 | meta + 제목 + 5:7 또는 6:6 콘텐츠 + footer | 주장 1개 |
| 다이어그램 | meta + 제목 + 12컬럼 diagram + footer | 노드 9개 이하 |
| 데이터 | meta + 제목 + 차트 8컬럼 + insight 4컬럼 + footer | 차트 1개, 결론 1개 |
| 마무리 | 중앙 카피 + CTA/연락처 + footer | 문장 2개, 연락처 3개 이하 |

### 10.1 공통 본문 골격

```html
<main class="slide" data-slide-type="content">
  <header class="meta-bar"><span class="meta-bar__brand">URBAN DATA LAB</span><span>SECTION / 03</span></header>
  <section class="slide-title">
    <p class="t-eyebrow">CAPABILITY</p>
    <h1 class="t-h2">슬라이드의 결론을 제목으로 씁니다</h1>
  </section>
  <section class="slide-content grid-12">
    <div class="span-5">...</div>
    <div class="span-7">...</div>
  </section>
  <footer class="footer-rule"><span>© URBAN DATA LAB</span><span>03</span></footer>
</main>
```

```css
.slide-title { position: absolute; left: 78px; right: 70px; top: 126px; }
.slide-title .t-eyebrow { margin: 0 0 12px; color: var(--brand-blue); }
.slide-title .t-h2 { margin: 0; }
.slide-content { position: absolute; left: 78px; right: 70px; top: 286px; bottom: 118px; }
```

### 10.2 목차

```html
<section class="agenda grid-12">
  <article class="agenda__item span-4"><span>01</span><h2>Company</h2><p>기업과 미션</p></article>
  <article class="agenda__item span-4"><span>02</span><h2>Technology</h2><p>데이터와 AI</p></article>
  <article class="agenda__item span-4"><span>03</span><h2>Business</h2><p>제품과 시장</p></article>
</section>
```

```css
.agenda__item { min-height: 260px; padding: 32px; border-top: 4px solid var(--brand-blue); background: var(--surface-1); }
.agenda__item span { color: var(--brand-mint); font: 700 13px/1 var(--font-secondary); }
.agenda__item h2 { margin: 48px 0 12px; font-size: 28px; }
.agenda__item p { margin: 0; color: var(--text-secondary); font-size: 18px; }
```

### 10.3 데이터

```html
<section class="data-layout grid-12">
  <figure class="chart-panel span-8" aria-label="월별 데이터 처리량 차트">[CHART SVG]</figure>
  <aside class="insight-panel span-4"><p class="t-eyebrow">INSIGHT</p><p class="t-h3">핵심 수치가 전년 대비 32% 증가했습니다.</p></aside>
</section>
```

```css
.chart-panel,
.insight-panel { margin: 0; min-height: 420px; padding: 24px; border: 1px solid var(--border); border-radius: var(--radius-md); background: var(--surface-1); }
.insight-panel .t-eyebrow { color: var(--brand-mint); }
.insight-panel .t-h3 { margin-top: 80px; }
```

### 10.4 다이어그램

```html
<section class="diagram-layout" aria-label="의료 데이터 처리 구조">
  <div class="diagram-lane">
    <p class="t-caption">DATA SOURCES</p>
    <div class="diagram-node">Clinical</div>
    <div class="diagram-node">Pathology</div>
    <div class="diagram-node">Omics</div>
  </div>
  <div class="diagram-path" aria-hidden="true">→</div>
  <div class="diagram-lane diagram-lane--focus">
    <p class="t-caption">URBAN DATA LAB</p>
    <div class="diagram-node">Standardization</div>
    <div class="diagram-node">Multimodal AI</div>
  </div>
  <div class="diagram-path" aria-hidden="true">→</div>
  <div class="diagram-lane">
    <p class="t-caption">PRODUCTS</p>
    <div class="diagram-node">SaMD</div>
    <div class="diagram-node">IVD</div>
  </div>
</section>
```

```css
.diagram-layout { display: grid; grid-template-columns: 1fr 56px 1fr 56px 1fr; gap: 16px; align-items: stretch; }
.diagram-lane { display: grid; gap: 16px; align-content: start; padding: 24px; border: 1px solid var(--border); border-radius: var(--radius-md); background: var(--surface-1); }
.diagram-lane--focus { border-color: var(--brand-mint); }
.diagram-lane .t-caption { margin: 0 0 8px; color: var(--text-tertiary); }
.diagram-node { min-height: 64px; display: grid; place-items: center; padding: 16px; border: 2px solid var(--border); border-radius: var(--radius-md); color: var(--text-primary); font: 600 18px/1.3 var(--font-primary); }
.diagram-lane--focus .diagram-node { border-color: var(--brand-blue); }
.diagram-path { display: grid; place-items: center; color: var(--brand-blue); font-size: 28px; font-weight: 700; }
```

노드가 9개를 넘거나 선이 교차하면 `archify`로 분리 제작한다. 장식용 노드, 의미 없는 연결선, 세로·가로 흐름 혼합은 금지한다.

### 10.5 마무리

```html
<main class="slide closing">
  <p class="t-eyebrow">URBAN DATA LAB</p>
  <h1 class="t-display">Build Evidence.<br><span>Deliver Better Care.</span></h1>
  <p class="t-body-lg">contact@urbandatalab.co.kr · urbandatalab.co.kr</p>
</main>
```

```css
.closing { display: flex; flex-direction: column; justify-content: center; background: var(--canvas); }
.closing .t-eyebrow { margin: 0 0 24px; color: var(--brand-mint); }
.closing h1 { margin: 0; }
.closing h1 span { background: var(--gradient-brand); color: transparent; -webkit-background-clip: text; background-clip: text; }
.closing .t-body-lg { margin: 40px 0 0; color: var(--text-secondary); }
```

## 11. 안티패턴

### 11.1 금지 색과 폰트

```css
/* Wrong */
.title { font-family: "AppleMyungjo"; color: #E0B357; }

/* Correct */
.title { font-family: var(--font-primary); font-weight: 800; color: var(--text-primary); }
```

골드 `#E0B357`은 산업부 R&D 맥락 변형이며 전사 슬라이드에서 금지한다.

### 11.2 색 이름으로 지시

```css
/* Wrong */
.badge { color: teal; background: navy; }

/* Correct */
.badge { color: var(--brand-mint); background: var(--brand-deep); }
```

### 11.3 작은 글자로 과밀 해결

```css
/* Wrong */
.body { font-size: 12px; }

/* Correct */
.body { font-size: 18px; line-height: 1.6; }
```

18px에 들어가지 않는 내용은 슬라이드를 분리한다.

### 11.4 장식 남용

- 한 장에 그라디언트 면은 2개 이하.
- glow는 한 장에 1개, 불투명도 28% 이하.
- 카드 그림자는 `--shadow-card` 하나만 사용.
- 서로 다른 radius를 한 장에서 3개 이상 혼합하지 않는다.
- 이모지, 스티커, 3D 원형 차트, 유리광택 버튼을 쓰지 않는다.

### 11.5 의료 표현 오류

- 생성 병리 이미지를 실제 연구 결과처럼 제시하지 않는다.
- AI 성능 수치에는 데이터셋, 표본수, 기준일, 평가 지표를 함께 쓴다.
- 환자·검체 식별정보가 보이는 캡처를 사용하지 않는다.
- 청진기·DNA·뇌 이미지를 근거 없이 장식 아이콘으로 반복하지 않는다.

## 12. 산출 파이프라인

### 12.1 HTML 준비

각 HTML은 외부 네트워크 없이 열려야 한다. 이미지, SVG, 폰트는 로컬에서 해결하고 `document.fonts.ready` 이후 렌더한다.

### 12.2 Chromium PNG @2x 렌더

다음 스크립트를 `render-slide.mjs`로 저장해 사용한다.

```js
import { chromium } from "playwright";
import { pathToFileURL } from "node:url";
import { resolve } from "node:path";

const [input, output, theme = "dark"] = process.argv.slice(2);
if (!input || !output) {
  throw new Error("Usage: node render-slide.mjs input.html output.png [dark|light]");
}

const browser = await chromium.launch({ headless: true });
const context = await browser.newContext({
  viewport: { width: 1600, height: 900 },
  deviceScaleFactor: 2,
  colorScheme: theme === "light" ? "light" : "dark",
});
const page = await context.newPage();
const url = `${pathToFileURL(resolve(input)).href}?theme=${theme}`;
await page.goto(url, { waitUntil: "networkidle" });
await page.evaluate(() => document.fonts.ready);
await page.screenshot({
  path: output,
  type: "png",
  fullPage: false,
  animations: "disabled",
});
await browser.close();
```

실제 명령:

```bash
npm install --save-dev playwright
npx playwright install chromium
node render-slide.mjs slide.html slide-dark.png dark
node render-slide.mjs slide.html slide-light.png light
sips -g pixelWidth -g pixelHeight slide-dark.png
```

마지막 명령의 결과는 `pixelWidth: 3200`, `pixelHeight: 1800`이어야 한다.

### 12.3 PNG를 PPTX에 삽입

이미지는 16:9 슬라이드 전체를 덮는다. PowerPoint 슬라이드 크기는 13.333×7.5in이다.

```python
from pptx import Presentation

prs = Presentation()
prs.slide_width = 12192000
prs.slide_height = 6858000
slide = prs.slides.add_slide(prs.slide_layouts[6])
slide.shapes.add_picture(
    "slide-dark.png",
    0,
    0,
    width=prs.slide_width,
    height=prs.slide_height,
)
prs.save("presentation.pptx")
```

PPTX에서 재편집해야 하는 텍스트·차트는 PNG 위에 중복 배치하지 않는다. “완전 래스터 장표”와 “네이티브 편집 장표” 중 하나를 슬라이드 단위로 선택한다.

## 13. 검수 체크리스트

### 13.1 자동 검사

- [ ] HTML viewport가 정확히 1600×900이다.
- [ ] PNG가 정확히 3200×1800이다.
- [ ] `document.fonts.check('18px Paperlogy')`가 `true`다.
- [ ] `document.fonts.check('12px Freesentation')`가 `true`다.
- [ ] 금지 폰트 문자열이 0건이다.
- [ ] 금지 골드 `#E0B357`, `#B0862E`, `#E2B24C`가 전사 장표에서 0건이다.
- [ ] 텍스트 요소의 bounding box가 안전 영역을 벗어나지 않는다.
- [ ] overflow된 요소가 0건이다.
- [ ] 본문 computed font size가 18px 이상이다.
- [ ] 모든 `<img>`에 `alt`, 모든 실사 카드에 캡션이 있다.
- [ ] 외부 네트워크 요청이 0건이다.

브라우저 콘솔용 검사:

```js
const forbidden = ["AppleMyungjo", "Songti SC", "Apple SD Gothic Neo", "Pretendard"];
const nodes = [...document.querySelectorAll("*")];
const fontViolations = nodes.filter((el) =>
  forbidden.some((name) => getComputedStyle(el).fontFamily.includes(name))
);
const overflowViolations = nodes.filter((el) =>
  el.scrollWidth > el.clientWidth + 1 || el.scrollHeight > el.clientHeight + 1
);
const safe = { left: 78, top: 54, right: 1530, bottom: 854 };
const textViolations = nodes.filter((el) => {
  if (!el.textContent.trim() || el.children.length) return false;
  const r = el.getBoundingClientRect();
  return r.left < safe.left || r.top < safe.top || r.right > safe.right || r.bottom > safe.bottom;
});
console.table({
  fontViolations: fontViolations.length,
  overflowViolations: overflowViolations.length,
  textViolations: textViolations.length,
  paperlogyLoaded: document.fonts.check("18px Paperlogy"),
  freesentationLoaded: document.fonts.check("12px Freesentation"),
});
```

### 13.2 시각 검사

- [ ] 한 장에 핵심 주장 하나만 보인다.
- [ ] 제목만 읽어도 발표의 논리 흐름이 이어진다.
- [ ] 강조색은 의미를 갖고 있으며 장식용으로 반복되지 않는다.
- [ ] 로고를 재조합하거나 그라디언트 순서를 바꾸지 않았다.
- [ ] 다크·라이트 전환 후 정보 위계와 대비가 유지된다.
- [ ] 차트의 단위·기간·표본수·출처가 있다.
- [ ] 병리·의료영상의 진단 색이 변형되지 않았다.
- [ ] 생성 이미지가 실제 임상 증거처럼 보이게 표기되지 않았다.
- [ ] 아이콘의 스트로크, 라운드, 색 적용이 통일됐다.
- [ ] 페이지 번호, 보안등급, 출처 표기가 잘리지 않는다.

## 14. 맥락 변형

산업부·정부 R&D 제출물에서 발주기관의 기존 형식을 반드시 이어야 할 때만 아래 변형을 허용한다.

```css
[data-variant="government-rnd"] {
  --context-gold: #E0B357;
}
```

- `--context-gold`는 기관·과제 메타, 1px 구분선, 작은 상태 태그에만 사용한다.
- 제목, KPI, 차트 시리즈, 브랜드 로고에는 사용하지 않는다.
- 명조 헤드라인은 변형에서도 금지한다. Paperlogy 800 또는 900을 유지한다.
- 변형을 쓴 슬라이드는 HTML 루트에 `data-variant="government-rnd"`를 명시한다.

## 15. 확인 필요

### 15.1 기본 테마

- 현재 실행 기본값: `dark`
- 근거: MEDICUS IR Book의 최다 배경색이 `#000050`이고, 웹사이트의 시그니처 딥 배경 `#0A082B`와 일치하는 다크 축을 형성한다.
- 확인 주체: Roy
- 확인 내용: 전사 기본을 다크로 확정할지, 청중·매체에 따라 라이트를 기본으로 둘지.

확정 전에도 구현은 다크 기본으로 진행하되 모든 컴포넌트는 라이트 모드를 통과해야 한다.

### 15.2 한글 폰트명 폴백

- 현재 실행값: CSS에 `"Paperlogy", "페이퍼로지", sans-serif`, PowerPoint에는 `Paperlogy`
- 근거: 원본 PPTX에서 영문·한글 글꼴명이 혼용됐으며 로컬에는 전 웨이트가 설치돼 있다.
- 확인 주체: Windows PowerPoint 검수자
- 확인 내용: 대상 Windows 환경에서 영문 `Paperlogy` 이름으로 한글 글리프가 정상 연결되는지.

검수 실패 시 CSS 스택은 유지하고 PPTX 네이티브 텍스트에만 설치된 실제 Windows 글꼴명을 적용한다. macOS 전용 폰트와 Pretendard로 대체하지 않는다.

### 15.3 정부 R&D 골드

- 현재 실행값: 전사 토큰 승격 금지, `government-rnd` 변형에만 `#E0B357`
- 근거: 웹사이트와 IR Book의 165°~270° 쿨 스펙트럼 밖에 있는 40° 색이며 산업부 발표자료에서만 확인됐다.
- 확인 주체: Roy
- 확인 내용: 정부 R&D 외의 투자·파트너 발표에서 해당 변형을 허용할지.

확정 전에는 정부 R&D 제출 맥락 밖에서 사용하지 않는다.
