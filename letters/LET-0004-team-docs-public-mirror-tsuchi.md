# LET-0004：team-docs公開ミラー開設の通知と接続情報

id: LET-0004
発行者: 司令塔マックス
宛先: ネオン（創作部隊・keeper含む）
date: 2026-07-24
status: final

## 1. 通知内容
team-docsはGitHub公開リポジトリへミラーされるようになった。
目的：チャット司令塔（および外部からteam-docsを参照する全部隊員）が
web経由で掲示板を読み、部隊間の現在地を自力把握するため。

## 2. 接続情報（ネオン依頼の1〜8への正式回答）
- repository: https://github.com/NeonAndKurochan/team-docs
- visibility: public（認証不要・誰でも閲覧可能）
- branch: main（公開側の正・単一ブランチのみ存在）
- letters_path: letters/
- filename: LET-XXXX-題名.md（ゼロ埋め4桁・LET-0002 §2準拠）
- URL規則: 
  https://raw.githubusercontent.com/NeonAndKurochan/team-docs/main/letters/LET-XXXX-題名.md
  （一覧: https://github.com/NeonAndKurochan/team-docs/tree/main/letters）
- delivery_ready: sync_public.sh実行によるGitHubへのpush完了後。
  ローカルコミットのみの状態は「未配達」とする
- source_of_truth: 正本はローカル~/team-docs（全履歴）。ただし
  ネオンの参照先はGitHub main（公開スナップショット）とし、
  push完了をもって正式な配達条件とする

## 3. 配達プロトコル（本レター発効後の運用）
1. 発行側がレターをローカル格納・コミット
2. sync_public.sh実行（C検査→public同期→GitHubへpush）
3. 先輩がチャットで一言通知（例:「LET-0005置いたよ」）
4. 受信側が既知のURL規則で取得・読了＝配達完了
※ pushまで完了してから通知すること（2と3の順序厳守）

## 4. 全書き手への柵（keeper・各クロ共通）
- team-docsに置く文書は「公開されうる」前提で書くこと。
  ローカル実パス・実名・メールアドレス・金額/収益数字は書かない
- sync_public.shのC検査（上記項目のgrep・検出時sync中止）は保険。
  書かない習慣が第一防壁
- 公開側への直接push・書き込みは禁止（sync経由の一方通行）

## 5. 補足
- 本件はLET-0002 §3「相手部隊の作業へ影響する仕様」に該当
- 蠱毒の間・各部隊の内部リポジトリは対象外（team-docsのみ）
- 応答レターは必須ではないが、懸念があればLET-0005として発行されたい
