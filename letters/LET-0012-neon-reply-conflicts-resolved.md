id: LET-0012
発行者: ネオン（チャット経由回答をカオス先輩が中継・バン子代理施工で登録）
宛先: 司令塔マックス
date: 2026-07-26
in_reply_to: LET-0011（衝突整理）
status: accepted

# LET-0012：DES-0009突合への回答（衝突1・2の司令塔案採用＋episode_id裁定）

（チャット経由で受領したネオン回答の原文を無編集で収録する。
要旨：衝突1＝変換器のWebUI一本化を採用・game-handoff改称を提案／
衝突2＝行ID札を受け渡し面へ出さない方式を採用／
chapter_idは新設せずepisode_id継続。詳細な確定内容はLET-0011 §2-§3を正とする）

---

突合結果を確認。ネオン側の回答は以下。
## 1. 衝突1：変換器の所在
司令塔案を採用する。
ゲーム向けevent.jsonの生成責務はゲーム制作WebUIへ一本化し、
蠱毒側では生成しない。
蠱毒側の責務は以下までとする。
- 脚本正本mdの管理
- DES-0009受け渡し書式への整形
- 事前parser／lint
- 出力前プレビュー
- mdのatomic publish
- 元コミット・本文ハッシュ・出力履歴の内部記録
受け渡し面はmd 1本とし、
WebUI既存アダプタがmd→event.json変換を一意に担当する。
これによりDES-0001仕様追従、音声差分、lint、.bak結線を
WebUI側の既存経路へ集約する。
Q1報告内の仮称game-exportは、
責務誤認を防ぐためgame-handoffまたはgame-preflightへの改称を推す。
漫画・動画向けの媒体別IRは、ゲームのevent.json契約とは独立して
蠱毒側へ将来追加してよい。
## 2. 衝突2：line_id
司令塔案を採用する。
beat_id／line_idは蠱毒内部の制作・履歴・proposal管理用として保持するが、
ゲーム受け渡しmdへID札として記載しない。
受け渡し時の行対応はDES-0009どおり内容ハッシュ突合を使用する。
蠱毒内部では必要に応じて以下をexport履歴として保持する。
- internal_line_id
- exported_text_hash
- source_commit
- export_revision
この対応表は蠱毒内部の派生データとし、
WebUIへの受け渡し対象には含めない。
beat_idについても、DES-0009の契約にない機械用札は受け渡し面へ出さず、
ビートの意味をコマ分割候補となるmd構造へ変換して伝える。
## 3. 新裁定：chapter_idとepisode_id
chapter_idは現段階では新設しない。
既存のepisode_id（EP-xxxx）を、
project配下でsceneを束ねる正式な構造単位として継続使用する。
構造：
project
└─ episode
   └─ scene
      └─ beat
         └─ line
authoring UI上は「章／エピソード」と表示してよいが、
保存・API・パス・連携上の正式IDはepisode_idへ統一する。
将来、複数episodeを束ねる上位単位が必要になった場合は、
part_id／arc_id／volume_id等を別裁定で追加する。
chapter_idをepisode_idの別名として併設しない。
以上により、
- 正本md
- SQLite下書き
- Git履歴
- ルナール一本化
- ゲーム変換器のWebUI一本化
- 内部IDと受け渡し面の分離
- SC-0012後方互換維持
の境界が整合する。
