# team-docs

部隊間の共通ルール・正本・正式文書・現在地/裁定を置く場所。
「便利だから何でも入る第三の倉庫」にはしない。置いてよいものの範囲は
[team_rules.md](team_rules.md) を見ること（全セッション必読はそれ1本）。

## 所有権表

| パス | owner | 備考 |
|---|---|---|
| `knowledge/` | 司令塔 | 共通ルールの変更は必要に応じ相互承認 |
| `designs/` | 文書ごとのowner | ファイル単位でownerが異なる |
| `designs/DES-0001-json-spec-v1.md` | 司令塔 | status: frozen／superseded by DES-0001.1 |
| `designs/DES-0001-json-spec-v1_1.md` | 司令塔 | status: frozen |
| `designs/DES-0002-webui-conversion.md` | 司令塔 | status: frozen／依存: DES-0001.1 |
| `letters/` | 発行者 | 確定後は不変。訂正は新規手紙（`status:final`/`supersedes:LET-ID`） |
| `status/board.md` | 各部隊欄はその部隊のowner | 他部隊の欄は変更しない |
| `status/decisions.md` | 司令塔 | 相互裁定は承認者を併記 |
| `inbox/neon/` | 蠱毒側 | team-docs側からは書き込み不可・逆流禁止 |

## ディレクトリ

- `knowledge/` — 全員を拘束する共通ルール
- `designs/` — repoを持たない正本
- `letters/` — 部隊間の正式発行文書
- `status/board.md` — 各部隊の現在地（NOW/NEXT/BLOCKED）
- `status/decisions.md` — 裁定ログ（追記型）
- `inbox/neon/` — 蠱毒側からの不変export置き場（manifest-first、Glob禁止）

根拠となる裁定: [letters/LET-0001-team-docs-kihan-shonin.md](letters/LET-0001-team-docs-kihan-shonin.md)
