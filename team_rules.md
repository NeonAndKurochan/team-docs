---
name: team_rules
description: 全セッション必読。team-docs運用の最小ルール。詳細は各リンク先へ。
---

# team_rules（全セッション必読・このファイルだけ）

ここにはこの4種のみを置く。他は各repoの正本かコピーであり、ここには置かない。
所有権の詳細は [README.md](README.md) の所有権表を見ること。

1. **全員を拘束する共通ルール** → `knowledge/`
2. **repoを持たない正本** → `designs/`
3. **部隊間の正式発行文書（手紙）** → `letters/`
4. **現在地と裁定** → `status/board.md`, `status/decisions.md`

## inbox/neon/ を読むとき
- 必ず `manifest.yaml` を先に読み、そこに記載されたファイルだけを読む。
  Globでinbox全体を探索しない。
- `latest` は人間向け便宜表示のみ。裁定・設計書では必ず EXP-ID を指定する。
  ID参照の詳細は [how_to_reference.md](how_to_reference.md) を見ること。
- ここへは**書き込まない**。逆流禁止。export済み文書は上書きされない
  （修正は新EXP-IDで来る）。
- 詳細・根拠: [letters/LET-0001-team-docs-kihan-shonin.md](letters/LET-0001-team-docs-kihan-shonin.md) §1

## letters/ を書く・読むとき
- 確定版は発行者が単独で判定する。ただし部隊間を拘束する内容
  （リポジトリ間IF／正本所有権変更／共通プロトコル／全部隊拘束の掟／
  役割分担変更）は相互承認が必要（発行→承認 or 訂正→`status/decisions.md`に記録）。
- 確定後の手紙は書き換えない。訂正は新しい手紙を `status: final` /
  `supersedes: LET-ID` で発行する。
- 詳細: [letters/LET-0001-team-docs-kihan-shonin.md](letters/LET-0001-team-docs-kihan-shonin.md) §3

## status/board.md を更新するとき
- 手動更新。形式固定、これ以外の行を増やさない:
  ```
  ## 部隊名｜owner: 名｜updated: YYYY-MM-DD
  NOW: ...
  NEXT: ...
  BLOCKED: ...
  ```
- 自分の部隊欄だけ変更する。他部隊欄は触らない。
- board.mdは履歴を持たない（現在地のみ）。履歴はGitに任せる。

## status/decisions.md を書くとき
- 追記型。1行＝1ID＋責任者。過去行は消さない。
- 裁定を覆すときは `supersedes: DEC-ID` で新しい行を追加する。

## Git
- ローカルGitは履歴であってバックアップではない
  （WSL外のミラーは将来課題、`letters/LET-0001-...` §4-F参照）。
