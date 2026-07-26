# DES-0010: Wan2GP i2v Discord線（スマホから動画生成）初弾設計書

- 版: r2（**frozen**・先輩承認2026-07-26。r1→r1.1: Eagle自動登録を初弾
  スコープへ昇格／r1.1→r2: 裁定案6件全承認・工程表承認により凍結）
- 起草: 司令塔マックス（fable）／2026-07-26
- 根拠: DEC-0014優先1後半／WAN-S0現物調査報告（クロB・2026-07-26）／
  まったりゆっくり氏マガジン偵察（v12.25更新情報・Plugins記事）
- 関連: DES-0005/0007（events_to_video・完結済み）

---

## §1. 目的とスコープ

**目的**: スマホのDiscordから指示を投げるだけで、ローカルのWan2GPが
i2v（画像→動画）を生成し、完成動画がDiscordに返ってくる一気通貫線を作る。

**初弾スコープ（やること）**:
- i2v専用（先輩裁定2026-07-26。t2vは使わない）
- 入口はDiscord（ビカラ）。開始画像＋プロンプト＋主要パラメータを受け取る
- Wan2GPはMCPサーバ常駐モードで背後稼働（GUI・ブラウザ不使用）
- 完成動画のファイルパス／本体をDiscordへ返却
- **完成動画をEagleへ自動登録**（先輩指示2026-07-26。生成物は流れて
  終わりでなく資産として蓄積する）

**やらないこと（初弾除外）**:
- t2v・動画後処理（アップスケール等はVideoProc続投・別工程のまま）
- 本格GPUオーケストレータ（排他は§5の最小の柵のみ）
- WebUI統合（将来玉）
- Gradio HTTP直叩き経路（WAN-S0で未確認✗。当てにしない）

## §2. 背骨アーキテクチャ

```
スマホ(Discord) → ビカラ(claude --channels / ~/generation-server/)
  → MCPクライアント(streamable-http)
  → Wan2GP MCPサーバ常駐 (127.0.0.1:7866)
  → i2v生成 → 出力ディレクトリ
  → ビカラが検知 → Eagle自動登録 ＋ Discordへ返却
```

- Wan2GP起動形態: `python wgp.py --mcp --mcp-transport streamable-http
  --mcp-host 127.0.0.1 --mcp-port 7866`
  （根拠: docs/API.md:352-397・warm session保持でモデル再ロードなし）
- 使用ツール: `wangp_generate` / `wangp_get_job` / `wangp_cancel_job` /
  `wangp_list_models`（根拠: docs/API.md:379-397）
- モデル: `i2v_2_2`（Wan2.2 Image2video 14B・現環境の直近使用モデル）
- ジョブ形式: settings dict（雛形はWebUI「Export Settings」またはMCP経由
  `get_default_settings("i2v_2_2")`で取得）。主要キー: model_type / prompt /
  image_prompt_type="S" / image_start / resolution / video_length /
  num_inference_steps / seed / repeat_generation

## §3. 裁定6件（先輩承認済み2026-07-26・全件確定）

1. **背骨**: MCP常駐＝正、CLI `--process queue.zip`＝保険経路（フェイルソフト）
2. **GPU排他**: 初弾は最小の柵——ビカラが投入前にnvidia-smiでVRAM使用を
   確認し、他エンジン（Forge/ComfyUI/EasyWan22）稼働中なら投入拒否＋
   Discord警告。本格オーケストレータは将来玉
3. **ポート**: MCP=7866明示固定。初弾はGradio(7860)を起動しない
   （Forge衝突は構造的に回避）
4. **完了検知**: `wangp_get_job`ポーリング＝正。jsonサイドカー方式
   （metadata_type変更）は保険選択肢として記載のみ・初弾では触らない
5. **出力先**: Discord返却用の専用ディレクトリへ分離（`output_dir=`指定）。
   共有Img2Vidフォルダに混ぜない
6. **v11.41版数主張**: 現物CHANGELOGで裏取れず・機能はv12.287で確認済み
   →実害なし・記録のみでクローズ

## §4. 工程表

**S0.5 点火試験（最初の実弾・最小）**
- MCPサーバ起動bat作成（ワンクリック起動・デスクトップOneDrive日本語パス）
- シエラ既存画像1枚でi2v 1本生成→`wangp_get_job`で完了検知→出力確認
- ここで16GB VRAMでのi2v 14B実行可否・実測速度・実VRAMを確定
  （WAN-S0の不明3件のうち2件を潰す）
- **S0.5が通らなければ設計ごと見直し**（先に安く転ぶ）

**S1 ビカラ結線（最小往復）**
- Discordチャンネルで「画像添付＋プロンプト」→ジョブ投入→進捗→完成通知
- **完了時にEagle自動登録**（ビカラの既存Eagle連携資産を再利用。実装・
  ポート・API呼び出しは既存コードを正とする。タグ付け＝生成日・キャラ名・
  seed・プロンプト要約を最低限。フォルダ振り分けの粒度はS1施工時に
  現物合わせで確定）
- 排他の柵（裁定案2）実装
- パラメータは既定値固定（resolution/長さ等はテンプレ埋め込み）

**S2 使い勝手パック**
- パラメータ指定（解像度・フレーム数・seed・LoRA）のDiscord記法
- 失敗時のエラー返却整形・`wangp_cancel_job`結線
- キャラテンプレ（シエラ/メルヴィナ）のプロンプト雛形登録

**検収基準（各工程共通）**: 先輩実機確認＝スマホから1往復成功。
commit-per-step・二段階承認プロトコル（実装はapproval-on始動→安全確認後に
skip宣言）は通常どおり非交渉。

## §5. 柵・禁止事項（チーム法典の適用）

- **candlelight系タグ恒久禁止**（プロンプト雛形・テンプレに焼き込み。
  夜の暖色はdim warm lighting/soft lamplight/moonlight等で代替）
- **成人ルール**: ネガティブ loli/young/child/minor/kid/small/short 維持
  （ポジティブのmature系は廃止済み・キャラテンプレ現行値を正とする）
- **GPU排他**: EasyWan22/Forge/ComfyUIとの同時起動不可を前提に運用
- MCPは127.0.0.1バインドのみ（外部公開しない）

## §6. 既知の罠（WAN-S0・偵察より）

- `process_queues_when_browser_unfocused`はヘッドレスではない
  （ブラウザ側JSパッチ。設計に使わない・使えない）
- File Gallery「Use Settings in Generator」はseedがそのまま戻る
  （-1でない）→再生成系を作る時の既知の罠
- FlashVSR系後処理は顔が変わる・重い→後処理はVideoProc続投
- Wan2GP側にGPU排他機構は無い（startup.lockはクラッシュ検知用）

## §7. 未確定・将来玉

- Gradio HTTP直叩き可否（未検証のまま・当てにしない前提）
- plugins/sample の Video Genトリガ実装詳細（プラグイン経路が
  必要になった時のみ再調査）
- WebUI統合・本格オーケストレータ・t2v
- Multi-Angle Prompt Helper / MSR白背景キャラシート活用
  （キャラ固定線の将来材料・isnet-anime資産と相性良）
