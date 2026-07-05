# GitHub 이중 계정 운용 (roykoo83 개인 / roykoo2606 회사)

> 원칙: **"스위칭"하지 않는다.** 저장소마다 remote 주소가 계정을 결정하게 만들어, 실수로 잘못된 계정으로 push하는 일 자체를 없앤다. (SSH 호스트 별칭 방식)

## 구조

```
remote 주소                          → 사용 키          → 계정
git@github-work:roykoo2606/...     → id_ed25519_work  → roykoo2606
git@github-personal:roykoo83/...   → id_ed25519_pers  → roykoo83
```

## 1회 설정 (터미널에서 순서대로)

### 1) SSH 키 2개 생성 (이미 있으면 생략)

```bash
ssh-keygen -t ed25519 -C "roykoo2606-work" -f ~/.ssh/id_ed25519_work -N ""
ssh-keygen -t ed25519 -C "roykoo83-personal" -f ~/.ssh/id_ed25519_pers -N ""
```

### 2) 공개키를 각 계정에 등록

```bash
pbcopy < ~/.ssh/id_ed25519_work.pub   # → roykoo2606 로그인 → Settings > SSH keys > New
pbcopy < ~/.ssh/id_ed25519_pers.pub   # → roykoo83 로그인 → 동일
```

### 3) ~/.ssh/config 에 호스트 별칭 추가

```
# 회사 (roykoo2606)
Host github-work
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_work
  IdentitiesOnly yes

# 개인 (roykoo83)
Host github-personal
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_pers
  IdentitiesOnly yes
```

### 4) 커밋 이메일 자동 전환 (~/.gitconfig)

remote 주소를 보고 git이 스스로 이름/이메일을 고른다 (git 2.36+):

```
[user]
    name = Roy Koo
    email = roykoo83@users.noreply.github.com   # 기본값: 개인

[includeIf "hasconfig:remote.*.url:git@github-work:*/**"]
    path = ~/.gitconfig-work
```

`~/.gitconfig-work`:

```
[user]
    name = Roy Koo
    email = roykoo@urbancorp.co.kr
```

### 5) 확인

```bash
ssh -T git@github-work       # → "Hi roykoo2606!" 이 나오면 성공
ssh -T git@github-personal   # → "Hi roykoo83!" 이 나오면 성공
```

## 사용 규칙 (설정 후에는 이것만 기억)

- **회사 저장소 clone**: `git clone git@github-work:roykoo2606/<repo>.git`
- **개인 저장소 clone**: `git clone git@github-personal:roykoo83/<repo>.git`
- 계정 전환 명령 불필요 — remote 주소가 곧 계정이다

## 참고

- `gh` CLI는 별도: `gh auth login`을 계정별로 하고 `gh auth switch`로 전환 (gh 사용 시에만)
- AX_Infra의 remote는 `git@github-work:roykoo2606/AX_Infra.git`로 설정됨 (회사 계정)
