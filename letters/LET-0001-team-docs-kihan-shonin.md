---
id: LET-0001
title: 承認裁定：team-docs構想（2/2・創作ブレーン発行・司令塔が要点転記）
from: 司令塔
status: final
supersedes: null
date: 2026-07-20
---

# 承認裁定：team-docs構想（2/2・創作ブレーン発行・司令塔が要点転記）

構想は追認。着工してよし。ただし「便利だから何でも入る第三の倉庫」
になる事故を最初に潰す。以下が条件だ。

## 1. inbox/neon/方式：採用（不変export＋manifest-first）
- 蠱毒側は exports/team-docs/ に EXP-ID付きディレクトリ
  （manifest.yaml＋document.md）で確定文書を出す
- export済み文書は上書きしない。修正は新export ID発行
- team-docs側から蠱毒側へ書き戻さない（逆流禁止）
- Claude Codeは最初にmanifest.yamlを読み、記載ファイルのみ読む。
  Globでinbox全体を探索しない
- latestは人間向け便宜表示のみ。設計書・裁定ではexport IDを指定
- シンボリックリンク自体に読み取り専用の効力はない。事故防止は
  ①蠱毒側ディレクトリ権限②Claude Code側の書き込み禁止ルール
  ③逆流処理を作らない、の三段で担保

## 2. board.md更新：手動開始
- 形式固定：「## 部隊名｜owner: 名｜updated: 日付」＋
  NOW／NEXT／BLOCKED の3行のみ
- 将来ポチで転記自動化しても、diff承認とGitコミット確定は人間

## 3. letters/：発行者が確定判定者
- 「確定版」＝発行者が正式に発行した文書（相手の同意は不要）
- ただし部隊間を拘束する内容（リポジトリ間IF・正本所有権変更・
  共通プロトコル・全部隊拘束の掟・役割分担変更）は相互承認：
  正式文書発行→相手が承認or訂正文書→合意をdecisions.mdへ記録
- 確定後の手紙は書き換えない。訂正は新しい手紙で
  status: final / supersedes: LET-ID 方式

## 4. 追加条件
A. team-docsに置くのは4種のみ：全員を拘束する共通ルール／
   repoを持たない正本／部隊間の正式発行文書／現在地と裁定。
   各repoに正本がある文書のコピー配置は禁止
B. 全セッション必読はteam_rules.mdの1ファイルだけ。巨大化したら
   負け。詳細は別文書へ逃がしてリンク
C. 所有権表（README.mdに置く）：
   knowledge/=司令塔（共通ルール変更は必要に応じ相互承認）／
   designs/=文書ごとのowner／letters/=発行者・確定後不変／
   status/board.md=各部隊欄のowner・他部隊の欄を変更しない／
   status/decisions.md=司令塔・相互裁定は承認者併記／
   inbox/neon/=書き込み不可（蠱毒側が所有）
D. decisions.mdは追記型。IDと責任者入り1行形式。裁定を覆す時も
   過去行を消さず supersedes で新裁定を追加
E. board.mdは履歴を持たない。現在地のみ。履歴はGitに任せる。
   更新者と更新日は初日から入れる
F. ローカルGitは履歴であってバックアップではない。運用安定後に
   Windows側bareミラー等、WSLとは別の保存場所を1つ持つこと
   （30分工事には含めない・将来課題）
