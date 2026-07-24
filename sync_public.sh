#!/usr/bin/env bash
# public化前C検査＋public branchへの内容同期（履歴は持ち込まない）＋
# 検査合格・コミット後に origin へ push（public:main固定）
# 使い方: ./sync_public.sh [SOURCE_BRANCH（既定: master）]
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

SOURCE_BRANCH="${1:-master}"
PUBLIC_BRANCH="public"
ALLOWED_NAME="team-docs-keeper"
ALLOWED_EMAIL="keeper@team-docs.local"

FOUND=0

check() {
  local label="$1"; shift
  local hits
  hits="$(git grep -InE "$@" "$SOURCE_BRANCH" -- '*.md' 2>/dev/null || true)"
  if [ -n "$hits" ]; then
    echo "--- 検出: $label ---"
    echo "$hits"
    FOUND=1
  fi
}

# 金額/収益語＋数字の同一行共起のみを検出（語の単独マッチは除外）
# ★ git grep出力は「ref:path:line:content」形式のため、行番号自体が
#   数字判定に混入しないよう content部分だけを切り出して判定する
check_cooccur() {
  local label="$1" wordpat="$2"
  local hits=""
  local line content
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    content="$(printf '%s\n' "$line" | cut -d: -f4-)"
    if printf '%s\n' "$content" | grep -qE '[0-9]'; then
      hits="${hits}${line}"$'\n'
    fi
  done < <(git grep -InE "$wordpat" "$SOURCE_BRANCH" -- '*.md' 2>/dev/null || true)
  if [ -n "$hits" ]; then
    echo "--- 検出: $label ---"
    printf '%s' "$hits"
    FOUND=1
  fi
}

echo "=== C検査（public化前グレップ実測・対象branch: $SOURCE_BRANCH） ==="

check "ローカル実パス /mnt/c/"       '/mnt/c/'
check "ローカル実パス /home/kaos"    '/home/kaos'
check "ローカル実パス C:\\\\Users"   'C:\\Users'
check "ローカル実パス johnl"         'johnl'
check "WSLユーザー名 kaos"           '\<kaos\>'
check "メールアドレス"               '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}'
check "金額: 円/万円（実数値）"       '[0-9,]+ *(円|万円)'
check "金額: \$（実数値）"            '\$[0-9]'
check_cooccur "金額/収益: 売上・収益・利益と数字の同一行共起" '(売上|収益|利益)'

echo "=== git履歴の著者/コミッター識別チェック（全ref） ==="
BAD_IDENTITIES="$(git log --all --format='%an|%ae|%cn|%ce' \
  | tr '|' '\n' | sort -u \
  | grep -vxE "${ALLOWED_NAME}|${ALLOWED_EMAIL}" || true)"
if [ -n "$BAD_IDENTITIES" ]; then
  echo "--- 検出: 許可外の著者/コミッター識別 ---"
  echo "$BAD_IDENTITIES"
  FOUND=1
fi

if [ "$FOUND" -ne 0 ]; then
  echo ""
  echo "C検査NG：検出物あり。sync中止（pushは行われていません）。"
  exit 1
fi

echo "C検査OK：検出0件"
echo ""

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "作業ツリーに未コミット変更あり。sync中止。"
  exit 1
fi

ORIGINAL_BRANCH="$(git symbolic-ref --short HEAD)"

echo "=== public ブランチへ内容同期（$SOURCE_BRANCH の履歴は持ち込まない） ==="
git checkout "$PUBLIC_BRANCH"
git ls-files -z | xargs -0 -r rm -f
git checkout "$SOURCE_BRANCH" -- .
git add -A

SYNCED=0
if git diff --cached --quiet; then
  echo "差分なし。コミット不要。"
else
  git commit -m "sync: $(date +%Y-%m-%d) content sync from ${SOURCE_BRANCH} (no history import)"
  echo "public ブランチへコミット完了。"
  SYNCED=1
fi

echo "=== 検査合格・コミット後に origin へ push（public:main固定） ==="
if [ "$SYNCED" -eq 1 ]; then
  git push origin public:main
  echo "push完了：public -> origin/main"
else
  echo "コミットなし（差分なし）につきpushはスキップ。"
fi

git checkout "$ORIGINAL_BRANCH"
echo "=== 完了（${ORIGINAL_BRANCH} に復帰） ==="
