id: LET-0011
発行者: 司令塔マックス
宛先: ネオン
date: 2026-07-26
in_reply_to: LET-0007（Q1調査分担）／関連: DES-0009・LET-0010
status: accepted（口頭往復済みの事後正式化。ネオン回答はLET-0012に収録）

# LET-0011：Q1現物調査の受領と、DES-0009との突合整理

## 1. 受領

ネオン担当Q1「蠱毒の間へのauthoring／game-export追加可否」の読み取り専用
現物調査報告（2026-07-26・変更ゼロ）を受領した。判定B「小規模な基盤整理後に
追加可能」を確認。正本md／SQLite下書き／Git履歴／派生物再生成の保存思想は
DES-0009柵1と適合しており、大枠で衝突なし。報告全文は付録Aに恒久収録する。

## 2. 突合で確認した衝突2件と司令塔案（→ネオン採用済み・LET-0012）

### 衝突1：変換器の所在
Q1報告の game-export は「md→parser→lint→IR→event.json→共有フォルダ出力」
まで蠱毒側で担う構想だったが、DES-0009の受け渡し面は「現行書式md 1本・
event.json変換はWebUI既存アダプタ」。JSON生成を二軒で持つと DES-0001 仕様
追従が二重化し、WebUI取り込み経路（DES-0008根治済みの音声差分・lint・.bak）を
素通りする。

**確定**: event.json生成責務はゲーム制作WebUIへ一本化。蠱毒側の責務は
「脚本正本md管理／DES-0009受け渡し書式への整形／事前parser・lint／
出力前プレビュー／mdのatomic publish／内部記録（元コミット・本文ハッシュ・
出力履歴）」まで。漫画・動画向けの媒体別IRは、ゲームのevent.json契約とは
独立に蠱毒側へ将来追加してよい。

**改称**: 責務誤認防止のためネオン提案を採用し、本モジュールの呼称を
**game-handoff** とする（事前検証機能の内部名として preflight を使うのは自由）。
以後の文書はこの呼称に統一し、DES-0009はr2で反映する。

### 衝突2：行ID札
Q1報告は beat_id／line_id を新規発行しevent.jsonへ透過させる構想だったが、
DES-0009裁定1は「受け渡しmdに行ID札を書かない・行対応は内容ハッシュ突合」
（孤児札問題の実測が根拠）。

**確定**: beat_id／line_id は蠱毒内部の制作・履歴・proposal管理用として保持し、
ゲーム受け渡しmdへID札として記載しない。行対応は内容ハッシュ突合。
蠱毒内部の対応表（internal_line_id／exported_text_hash／source_commit／
export_revision）は内部派生データとし、受け渡し対象に含めない。

**beat_idの補足（認識合わせ・新規交渉ではない）**: DES-0009裁定5の
`## 舞台: 背景=xxx, ビート=B01` は契約内の**任意**フィールドである。
送らない運用も契約適合。送る場合はこの正書式一択とし、それ以外の
機械用札を受け渡し面へ出さないことを相互確認する。

## 3. 新裁定：chapter_id／episode_id（→ネオン裁定を採用）

chapter_idは新設しない。既存 episode_id（EP-xxxx）を project配下でsceneを
束ねる正式構造単位として継続使用する（project→episode→scene→beat→line）。
UI表示上「章／エピソード」の呼称は自由だが、保存・API・パス・連携上の
正式IDは episode_id に統一。上位単位が必要になった場合は part_id／arc_id／
volume_id 等を別裁定で追加し、chapter_idを別名併設しない。

**DES-0009への波及**: §4 frontmatterの `source_chapter_id` は
`source_episode_id` に改める（r2反映）。

## 4. 残る宿題（本レターでは閉じない）

LET-0010の3件——裁定3（写像は蠱毒側書き出し時に確定）・裁定4（心の声＝
speaker名方式）・裁定6（正本移転プロトコル）——への正式回答は未受領。
Q1報告の「authoringと既存sceneで正本を二重化しない」で方向一致は
見えているが、憲法（柵1）絡みのため推定で閉じず、返信レターを待つ。
終着をもってDES-0009をr2化し凍結申請する（r2差分：①source_episode_id
②game-handoff改称 ③裁定3/4/6のfinal化）。

## 5. Q1報告の「実装前に必要な裁定」6件の交通整理

1. episode_id／chapter_id → **本レター§3で確定**
2. 確定脚本正本のファイル名（human_revision.md か script.md か）→ 蠱毒内部の
   保存設計＝**ネオン裁量**（受け渡し面はDES-0009裁定3のscn_xxxx.mdで不変）
3. 複数proposalとai_output.mdの関係 → **ネオン裁量**（蠱毒内部）
4. beat／line ID規則 → 内部規則は**ネオン裁量**、受け渡し面は§2衝突2で確定
5. ルナール依頼／返却契約 → **要共同設計**（DEC-0017柵4の範囲内・
   DES-0009 §8-5のとおりQ1後の設計玉。次の設計往復で扱う）
6. game-handoff出力先・version・上書き規則 → 出力先は**DES-0009裁定7で確定**
   （<作品>/inbox_authoring/）。version・上書き規則は正本移転プロトコル
   （LET-0010）の終着と併せて確定する

---

## 付録A: ネオンQ1現物調査報告 全文（2026-07-26受領・原文恒久化）

（チャット経由で受領した原文を無編集で収録する）

# Q1現物調査完了報告
ネオン担当Q1「蠱毒の間へのauthoring／game-export追加可否」の
読み取り専用現物調査が完了した。
## 結論
判定はB：**小規模な基盤整理後に追加可能。**
既存の保存思想は今回の構想とよく適合している。
- Markdown／YAML：確定正本
- SQLite：下書き
- Git：履歴
- Context Pack／exports：再生成可能な派生物
脚本Markdownを正本とし、SQLiteを下書き・索引にする設計は
既存思想と衝突しない。
ただし現状コードには以下の固定箇所がある。
- recycle-shop
- EP-0024
- SC-0012
- MonacoモデルURI
- サンプル前提のシーン一覧
- scene_id単独主キーのDraft／EditLock
これらを先に汎用化する必要がある。
## authoring
独立モジュールとして追加可能。
流用可能：
- Monaco左右比較
- 下書き／正式保存UX
- Context Pack
- creative context
- provenance／knowledge_commit
- atomic write
- Git履歴
- edit lock
- 人間承認境界
先行整理：
- project／chapter／scene path resolver
- scene一覧の実データ化
- scene別Monaco URI
- authoring専用draft／lock
- 作品データGitの保存mutex
- commit対象のstage境界明確化
## game-export
Context Packとは分離した独立モジュールとして安全に追加可能。
想定：
脚本Markdown → parser → lint → IR → event.json → manifest付き共有フォルダ出力
正本repositoryは読み取り専用とし、
temp生成→schema検証→JSON再読込→SHA確認→atomic publishとする。
## ID
- project_id：既存slug方式を継承可能
- scene_id：既存形式を継承可能
- chapter_id：episode_idとの関係要裁定
- beat_id／line_id：新規
- 確定ID：型付き連番
- draft／proposal／export run：UUID
行番号をIDには使用しない。
正式保存前lintで、
ID欠落・重複・不正形式・既存ID変更・他scene ID混入を拒否する。
## 4コマ・複数媒体
authoringへ以下を追加すれば対応可能。
- format
- theme
- proposal_id
- proposal_status
- 採用理由
- 不採用理由
- 部分採用箇所
- beats
- setup／development／twist／punchline
ビートを媒体非依存にし、
コマは各export時の中間表現として生成する。
## 実装前に必要な裁定
1. episode_idとchapter_idの関係
2. 確定脚本正本をhuman_revision.mdにするかscript.mdにするか
3. 複数proposalとai_output.mdの関係
4. beat／line ID規則
5. ルナール依頼／返却契約
6. game-export出力先・version・上書き規則
## クロちゃん側Q2〜Q7への引き渡し
- chapter／episodeの意味関係を先に確定
- 確定IDは型付き連番、一時IDはUUID
- ルナールは唯一のAI生成経路
- game-exportは正本を変更しない
- event.jsonへsource scene／beat／line ID、source hash、
  repository commitを持たせる
- authoringと既存sceneで正本を二重化しない
- 作品データGitのcommit処理を直列化する
- SC-0012を後方互換fixtureとして維持する
調査中のファイル変更：0
Git操作による変更：0
DB変更：0
実装着工：していない

（付録A終わり。※付録A内の「event.jsonへsource beat／line IDを持たせる」等は
調査時点の構想であり、本文§2の確定内容が優先する）
