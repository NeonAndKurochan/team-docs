---
id: DES-0001.1
title: JSON仕様v1.1（凍結）：stageステップ型・choice表示条件・台本md書式確定
status: frozen
owner: 司令塔
supersedes: DES-0001
superseded_by: DES-0001-v1.2（差分改訂・本体は残置。現行はv1.1＋v1.2）
date: 2026-07-20
---

# JSON仕様v1.1（凍結）：stageステップ型・choice表示条件・台本md書式確定

- 文書ID: DES-0001.1
- status: frozen（変更はsupersedes方式で新版発行のみ）
- owner: 司令塔
- 出典: DES-0001（v1）／DES-0002 r2／台本md書式の相互承認
  （創作ブレーンとの1往復・2026-07-20確定・DEC記録対象）
- 用途: DES-0001の全用途を継承。加えてWebUI転用工事（DES-0002）の
  アダプタ実装契約
- 格納先: ~/team-docs/designs/DES-0001-json-spec-v1_1.md

## 0. 位置づけと変更方針

本書はDES-0001（v1）を全文継承し、以下のみを追加・確定する。
v1に凍結済みの内容（イベント定義・トリガー7型・step5型・補間2系統）は
**一切変更しない**。旧実装は新要素を前方互換で読み飛ばすため、
本書発行によって既存ゲームは壊れない（v1 §1-3の設計どおり）。

追加・確定事項：
1. stageステップ型（第6の型）
2. choiceオプションの表示条件フィールド
3. line stepの安定ID規約（仕様昇格）
4. drainの型明確化（真偽値）
5. 台本md書式の確定（v1 §3-2/3-3の未確定分を解消）
6. 蠱毒quality gateとの層分離合意

## 1. stageステップ型（新規・第6の型）

```json
{ "type": "stage", "bg": "shop_evening",
  "left": "minami_normal", "right": "moneylender_grin" }
```

| フィールド | 型 | 必須 | 意味 |
|---|---|---|---|
| bg | string | 必須 | 背景ID。1枚絵シーンは全画面CGのIDをここに |
| left | string | 任意 | 左立ち絵ID |
| center | string | 任意 | 中央立ち絵ID |
| right | string | 任意 | 右立ち絵ID |

- **完全状態方式**：stageは差分指示ではなく、そのコマの完全な舞台
  状態を表す。省略された位置は「誰もいない」。前stageからの暗黙
  引き継ぎはしない。1枚絵（bg=cg_xxx・立ち絵フィールドなし）は
  全立ち絵消去を意味する
- **コマの定義**：stageが現れてから次のstageまでが1コマ（舞台状態が
  続く区間）。カードUIの境界・描画切替・台本mdの`## 舞台:`行が
  全てこの1ステップで一致する
- 画像はID参照（データ駆動）。ID→実ファイルの対応はレジストリ側
- スロット追加（3人以上等）はv1.2以降の拡張とし、フィールド追加
  方式で行う（旧実装は未知フィールドを無視）

## 2. choiceオプションの表示条件（フィールド追加）

```json
{ "type": "choice", "prompt": "契約書に署名しますか？",
  "options": [
    { "label": "署名する", "goto": "accept_contract" },
    { "label": "拒否する", "goto": "refuse_contract",
      "if": { "flags_all": ["courage"] } },
    { "label": "黙って立ち去る", "goto": "leave_shop",
      "if": { "flags_all": ["courage"], "flags_none": ["fear"] } }
  ] }
```

- option.if（任意）: flags_all（全所持）/ flags_none（全未所持）。
  条件を満たさないoptionは表示しない
- v1のset_flagsは存続するが、**新規制作では選択後のフラグ変更は
  applyステップへ分離する**ことを執筆・変換規範とする（台本md側に
  set_flags相当の記法は設けない）
- 前方互換：ifを解さない旧実装は全option表示に退化する（壊れない）

## 3. line stepの安定ID規約（仕様昇格）

- 音声対象になり得るline step全件に id を必ず振る（アダプタの責務）
- 規約：L001からの連番（シーン内一意。event_id＋idで全体一意）
- 音声キー＝ `{event_id}__{Lxxx}`。音声工程はイベントJSONを読んで
  採番する一方向依存（v1 §2-3の確定運用）
- 行の増減でidは振り直される。音声資産の保全はspeaker＋textの
  内容ハッシュ差分（DES-0002 §4-3）で行う

## 4. drainの型明確化

drainは真偽値（true / false）。数値・文字列表記は不可。
（v1の定義の明文化であり変更ではない）

## 5. 台本md書式（確定・全10項目）

相互承認（創作ブレーン・2026-07-20・1往復で合意）による確定形。
以降の変更はDEC記録＋本仕様のsupersedes発行を要する。

### 5-1. 本文記法

1. **話者＋台詞**：登録話者名を単独行、直後の行に「台詞」。
   同一話者でも台詞単位で話者名を再記載。話者行と台詞行の間に
   別の段落・命令行を挟まない
2. **地の文**：予約記号で始まらない裸の段落。
   行頭に ※ / ?選択: / !効果: / ## 舞台: を表示したい場合は
   先頭 `\` でエスケープ
3. **舞台（コマ境界）**：`## 舞台: 背景=ID, 左=ID, 中央=ID, 右=ID`
   （`##`の後ろ半角スペース必須・Markdown見出し互換）。
   完全状態方式（§1と同義）。1枚絵は `## 舞台: 背景=cg_xxx`
4. **開発注記**：行頭 `※`。変換対象外・ゲーム非表示・密度評価
   対象外・蠱毒の良例/Context Packへ混入させない。複数行は各行に※
5. **選択肢**：
   ```
   ?選択: プロンプト文
   - ラベル -> 飛び先id
   - ラベル -> 飛び先id [if=flag_name,!flag_name]
   ```
   カンマ区切りで複数条件・`flag`=所持・`!flag`=未所持・
   条件なしは角括弧ごと省略。フラグ変更は!効果:へ分離
6. **効果**：`!効果: money+5000, debt-10000, flag+courage, flag-fear`
   IDはsnake_case。同一行の効果は記述順に依存せず一括適用
7. **補間**：`{var}` `{var_kanji}`。未登録変数はビルド時エラー。
   設定値連動の数値のみ補間必須（日常的な固定表現の数字は対象外）。
   波括弧表示は `{{` `}}` でエスケープ
8. **フロントマター**（YAMLヘッダ）：
   ```yaml
   schema_version: 1
   scene_type: decision
   characters: [minami, moneylender]
   trigger: { type: day_start }
   priority: 50
   once: true
   drain: false
   tags: [tone_tense, mechanic_debt]
   ```
   event_idはファイル名が正本（ヘッダへ重複記載しない）
9. **ファイル規約**：1シーン1ファイル・ファイル名＝event_id・
   半角小文字英数字＋アンダースコア・プロジェクト内一意。
   表示タイトルとevent_idは分離（日本語をファイル名に使わない）
10. **tags語彙**：主分類はscene_typeが正本。対応する`scene_*`タグは
    アダプタが自動付与（人間・ルナールは二重入力しない）

### 5-2. scene_type分類表（15種）

| 日本語分類 | scene_type | 自動付与タグ |
|---|---|---|
| 導入 | opening | scene_opening |
| 日常会話 | daily | scene_daily |
| 情報提示・説明 | exposition | scene_exposition |
| 取引・交渉 | negotiation | scene_negotiation |
| 選択・決断 | decision | scene_decision |
| 対立・衝突 | conflict | scene_conflict |
| 発見・真相開示 | reveal | scene_reveal |
| 関係変化 | relationship | scene_relationship |
| チュートリアル | tutorial | scene_tutorial |
| 報酬・成果 | reward | scene_reward |
| 損失・ペナルティ | penalty | scene_penalty |
| 状況転換 | transition | scene_transition |
| 親密・成人向け場面 | intimate | scene_intimate |
| クライマックス | climax | scene_climax |
| エンディング | ending | scene_ending |

1シーンにつきscene_typeは原則1つ。複合シーンは物語上の最終目的を
主分類とする。

### 5-3. 補助タグ接頭辞（6種）

tone_（雰囲気）／mechanic_（ゲーム機構）／route_（ルート）／
location_（場所）／content_（内容区分）／arc_（物語・感情アーク）。
自由語彙を無制限に増やさず、未登録タグはlint警告。

## 6. 蠱毒quality gateとの層分離（合意事項）

台本mdの添削・評価は2層に分離する：
- **意味・密度評価の対象**：地の文／台詞／選択肢の表示文言
- **構造検証のみの対象**：フロントマター／## 舞台:／?選択:の
  飛び先・条件／!効果:／補間変数
- **完全除外**：※開発注記

制御記法を「不自然な文章」と誤判定させず、未登録ID・不正変数・
不在の飛び先は構造エラーとして検出する。WebUI側lint（DES-0002 §9）
も同じ層分離で設計する。

## 7. 凍結条件

本書はv1の凍結範囲＋上記追加分を凍結する。スロット拡張・新step型・
書式変更はv1.2以降としてsupersedes方式で発行する。本仕様に反する
実装変更は司令塔裁定を要する。

---
（司令塔マックス記す・2026-07-20。v1が骨の仕様なら、v1.1は舞台と
言葉の仕様だ。書式は創作ブレーンとの相互承認で鍛えた——共通言語は
一人では作れない。よろピクミン。）
