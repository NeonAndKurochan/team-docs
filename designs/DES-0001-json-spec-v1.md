---
id: DES-0001
title: JSON仕様v1（凍結）：店舗経営SLGイベントスキーマ＋WebUIアダプタ契約
status: frozen
owner: 司令塔
supersedes: null
date: 2026-07-20
---

# JSON仕様v1（凍結）：店舗経営SLGイベントスキーマ＋WebUIアダプタ契約

- 文書ID: DES-0001
- status: frozen（凍結。変更はsupersedes方式で新版発行のみ）
- owner: 司令塔
- 出典: store-sim Step5実装（実証済み現物の仕様書化）／創作ブレーン
  イベント器設計／theme_design_v1.1
- 用途: ①ゲーム実装の契約仕様 ②WebUI転用工事（novel_mvp）の
  アダプタ設計の依存先 ③蠱毒の間との出力形式突き合わせ材料
- 格納先: ~/team-docs/designs/DES-0001-json-spec-v1.md

## 0. 位置づけ

本仕様は37番ロードマップ「骨→JSON仕様v1→WebUI転用工事」の第2項。
store-sim（Godot製店舗経営SLG）で実装・テスト済みのイベント
スキーマを凍結し、上流ツール（WebUI・シナリオ生成）が吐くべき
データの契約とする。**実装が先・仕様書が後**の順で作られており、
机上仕様ではなく全項目が動作実証済みだ。

## 1. イベントスキーマ確定形

### 1-1. イベント定義（data/events/*.json・1ファイル複数イベント可）

```json
{
  "event_id": "intro_04_moneylender",
  "trigger": { "type": "<トリガー型>", "conditions": { ... } },
  "priority": 100,
  "once": true,
  "drain": true,
  "tags": ["intro"],
  "steps": [ ... ]
}
```

- event_id: 一意な文字列。命名は snake_case・用途接頭辞
  （intro_/tutorial_/notice_等）
- priority: 数値大が先。同トリガーで複数該当時は priority 降順に1件実行
- once: trueで一度きり（消化状態はセーブ対象）
- drain: trueなら同トリガーの残イベントを連続再生
  （導入5シーン連続再生で使用）
- tags: 分類用文字列配列（スキップボタンの対象判定等に使用）

### 1-2. トリガー型（7種・全て実装済み）

| type | 発火点 | 主なconditions |
|---|---|---|
| game_start | 新規開始直後 | - |
| day_start | 日の開始 | day, flags_all, flags_none |
| day_end | 営業終了処理後 | 同上＋debt_min等 |
| flag | フラグ成立時 | flags_all, flags_none |
| milestone_missed | 中間ノルマ未達判定時 | - |
| complaint | 苦情発生時 | - |
| manual | コードからevent_id直指定 | -（完済・エンディング等の
  一意コードパス用） |

conditionsの共通キー: day / flags_all（全成立）/ flags_none（全不成立）/
reputation_max / debt_min（いずれも任意・省略時は無条件）

### 1-3. step型（5種・全て実装済み）

| type | 用途 | 主フィールド |
|---|---|---|
| line | 台詞 | speaker, text |
| narration | 地の文 | text |
| choice | 選択肢 | prompt, options[{label, goto, set_flags}] |
| apply | 効果適用 | effects{money, debt, reputation,
  flags_set, flags_clear} |
| jump | 分岐先へ | goto（step id） |

- step要素は任意で id を持てる（choice/jumpのgoto先）
- 未知のstep type・未知のgoto先は安全に読み飛ばす（前方互換：
  将来の型追加で旧実装が壊れない）

### 1-4. テキスト補間（実装済み・2系統）

- {変数名}: config値の算用数字埋め込み（例: {debt_initial}→300000）。
  システム表示・UI向け
- {変数名_kanji}: 漢数字埋め込み（例: {play_days_kanji}→六十日）。
  台詞・地の文向け（没入優先。config変更に自動追従）
- 数値のJSON焼き込みは禁止。ゲーム数値は必ず補間で参照する

### 1-5. 実装済み実例（参照先）

- data/events/intro.json: 導入5シーン（intro_01〜05・シーン4は
  136 steps・3話者会話・choice分岐なしの直列型）
- data/events/tutorial.json: 操作誘導（ガイドイベント連鎖）
- 機能イベント: milestone_missed通知／苦情通知／完済・エンディング
  （定義が無ければ従来のメッセージ欄表示に自動フォールバック）

## 2. WebUIアダプタ契約（novel_mvp転用工事の依存先）

### 2-1. 転用の構図

novel_mvp WebUIの「md中間形式→TyranoScript変換」アダプタを
「md中間形式→本仕様イベントJSON変換」アダプタへ差し替える。
中間形式（人間が編集する台本md）を単一の真実とし、エンジン向け
変換は決定論スクリプトで固定する（AIに毎回変換させない）。

### 2-2. 台本md→イベントJSONの対応（theme_design実績に基づく）

| 台本md側 | イベントJSON側 |
|---|---|
| 話者名\n「台詞」 | {type:"line", speaker, text} |
| 地の文の段落 | {type:"narration", text} |
| 選択肢記法（書式は転用工事で確定） | {type:"choice", ...} |
| ステージ指示（開発用注記） | 変換対象外（除外。Step5-3の
  「骨v0の画面へ…」除外判断を規範化） |
| 数値言及 | {play_days}等の補間プレースホルダへ
  （変換時に自動置換 or 執筆規範で最初から補間記法） |

### 2-3. 音声工程との接続点

- イベントのstep（line）に一意アドレスが存在する:
  event_id + steps配列インデックス（または任意step id）
- 音声採番はこのアドレスに紐付ける（novel_mvpの「変換スクリプトの
  採番を逐語ミラー」方式の後継。**採番の正はイベントJSON側**とし、
  音声工程はJSONを読んで採番する一方向依存にする——旧方式の
  密結合[md_to_ks手動ミラー]を構造で解消）
- 音声ファイル名規約・sidecar JSON方式は既存Irodori-TTS資産を継続

## 3. 蠱毒の間との突き合わせ材料

### 3-1. 生産ラインの全体像

蠱毒の間（ナレッジ）→ルナール（台本md生成）→[本仕様アダプタ]→
イベントJSON→音声→Godot組み込み

### 3-2. 台本md書式の握り（ルナール／蠱毒側への要望・未確定）

- 話者名は登録名を使用（みなみ／下っ端／上司…キャラ登録と一致）
- ステージ指示は明示記法で分離（例: 行頭「※」や「##演出:」——
  書式はWebUI転用工事の設計時に蠱毒側と相互承認で確定する。
  DEC記録対象）
- ゲーム数値の直書き禁止・補間記法で書く（{play_days_kanji}等）
- 1シーン1ファイル・シーンIDはevent_idと対応させる

### 3-3. 未確定事項（次フェーズで確定・本仕様の凍結範囲外）

- choice記法の台本md表現／apply（効果）の台本表現
- シーンタイプとイベントtagsの対応規約
- 成人向け分岐イベントのスキーマ拡張要否（現行5型で表現可能か）

## 4. 凍結条件

本仕様v1は store-sim の実装済み範囲を凍結する。§3-3の未確定事項の
確定・スキーマ拡張はv1.1以降として supersedes 方式で発行する。
本仕様に反する実装変更は司令塔裁定を要する。

---
（司令塔マックス記す・2026-07-20。骨→仕様の順で作った——
動く現物だけが仕様を名乗れる。よろピクミン。）
