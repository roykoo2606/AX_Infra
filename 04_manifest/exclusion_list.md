# 반입 금지 목록 (Exclusion List) — 절대 규칙

> AX_Infra 이관 중 아래는 **절대 반입하지 않는다**. `vault_linter.py`의 E4(비밀 파일)·E6(frontmatter 민감정보)가 기계적으로 차단하지만, 이관 담당자가 사전에 걸러야 한다. 헌법 §3-2 계승.

## 1. 비밀·인증 파일 (절대)

- `credentials.json`, `token*.json`, `*_token.json`, `oauth*.json`, `*.pem`, `id_rsa*`
- `.env`, `.env.*` (`.env.example` 제외)
- `.auth/` 디렉토리 전체 (토큰·재인증·sync 로그 포함)
- 기타 API 키·PAT·세션 토큰이 담긴 모든 파일

## 2. 민감 온톨로지 클래스 (frontmatter·그래프 반출 금지)

- `Credential` (시스템 접속 계정/비밀번호)
- `Card` (카드번호)
- `BankAccount` (계좌번호)
- → 원본은 지정 마스터 문서 **본문에만** 존재. 이관하더라도 frontmatter에 싣지 않고, graph.json에도 포함하지 않는다.

## 3. 개인정보 (반출 주의 — 정책 확인 후)

- 주민등록번호 앞자리(생년월일+성별) — `20_인력_마스터`의 해당 컬럼
- 국가연구자번호 원본 (businessKey로 쓰되 대외 반출 시 마스킹/정책 확인)
- 개인 연락처·개인 이메일·개인 주소

## 4. 대용량 원본 (이관 제외 원칙)

- `04. Archive/` (약 821MB) — 녹음(m4a), 압축(zip), 영상(mp4), 스캔 원본 등
- 원본은 Urban_AX에 동결 보관. AX_Infra에는 **정제된 지식(Wiki)만** 이관하고, 원본이 필요하면 참조 링크·경로만 남긴다.

## 5. 검증 게이트

이관 배치 전/후 반드시:

```bash
# 비밀 파일 스캔 (git 추적/스테이징)
{ git ls-files; git diff --cached --name-only; } | grep -EIi '(credentials|token|oauth).*\.json$|_token\.json$|\.pem$|(^|/)\.auth/'
# frontmatter/무결성
python3 vault_linter.py    # ERROR 0 확인
```

E4/E6가 하나라도 뜨면 이관 중단 → 원인 제거 후 재개.
