---
name: how_to_reference
description: team-docs内の文書をID指定で参照する方法。team_rules.mdから逃がした詳細。
---

# how_to_reference（文書のID参照方法）

team-docs内の確定文書は、原則として「便宜表示」ではなく「ID」で指し示す。
`latest` やファイル名だけの参照は、設計書・裁定・手紙の本文では使わない。

## EXP-ID（`inbox/neon/`のexport）
- 蠱毒側が発行する不変exportの識別子。ディレクトリ名に含まれる
  （例: `inbox/neon/exports/team-docs/EXP-0007/`）。
- 必ず `manifest.yaml` を先に読み、そこに列挙されたファイルだけを読む。
  ディレクトリをGlobで走査しない。
- `latest`（あれば）は人間が最新を素早く見るための便宜リンクに過ぎない。
  文書内で他のexportを指すときは必ずEXP-IDで固定する。
- 同一文書の修正は新しいEXP-IDで来る。旧EXP-IDは上書きされない。

## LET-ID（`letters/`の手紙）
- ファイル名・frontmatterの `id:` で識別する（例: `LET-0001`）。
- 確定後は本文を書き換えない。訂正は新しい手紙を発行し、
  frontmatterに `status: final` と `supersedes: LET-ID`（訂正対象）を書く。
- 部隊間を拘束する内容の手紙は、相手の承認 or 訂正文書をもって
  `status/decisions.md` に合意を記録する。

## DEC-ID（`status/decisions.md`の裁定ログ）
- 1行1ID、追記型。過去の行は消さない。
- 裁定を覆すときは新しい行を追加し、`supersedes: DEC-ID` で
  どの裁定を覆すか明記する。過去の行が消えることはない。

## 参照の基本方針
- 設計書・裁定・手紙の本文でteam-docs内の文書を指すときは、
  「〜を見よ」ではなく「LET-0001を見よ」のようにID指定する。
- `latest` 表記はREADMEやboard.mdなど、人間が現在地を素早く掴むための
  補助表示にとどめる。
