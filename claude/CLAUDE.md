# CLAUDE.md - Claude Code グローバル設定

## 全般

- 常に日本語で会話すること
- 横に長過ぎるコメントやMarkdown文書は避ける。大体1行88文字くらいを目安とする
- Markdownで見出しと本文の間は常に1行改行を入れること
- プロジェクトで採用しているツールが既にあるのであれば、ここで使用を推薦しているツールより優先すること
- 最大限の効率を追求するために、複数の独立した処理を実行しなければならない場合は、
  それらのツールを順番に呼び出すのではなく、同時に起動する。
- 仕様に疑問があれば必ず立ち止まってユーザに質問すること

## 開発哲学

### 開発の進め方

#### Test-Driven Development (TDD)

- ソフトウェア開発では原則としてテスト駆動開発（TDD）で進める
- 期待される入出力に基づき、まずテストを作成する
- 実装コードは書かず、テストのみを用意する
- テストを実行し、失敗を確認する
- テストが正しいことを確認できた段階でコミットする
- その後、テストをパスさせる実装を進める
- 実装中はテストを変更せず、コードを修正し続ける
- すべてのテストが通過するまで繰り返す

### テストについての考え方

テストについての基本的な考え方を以下に記載する。

- 良いテストとは、以下を備えるもの
  - 退行（regression）に対する保護
  - リファクタリングへの耐性
  - 迅速なフィードバック
  - 保守のしやすさ
- テストで検証するのは、外部から観察可能な振る舞いのみとする
- 価値をもたらさないテストケースは追加しない
- Mockは、外部依存(DBや外部API)やそのためのアダプタ、時間設定等に対し適用可能とし、それ以外には使用しない

## Python開発

### ドキュメント

- docstringはGoogleスタイルにする

## Java開発

### Test

#### テストフレームワーク

- JUnit5

#### テスト作成方針

- ケースが多い場合などはParameterized Testを使用する

#### テスト実行して検証する場合

以下のように最小限のテストケースを実行するようにする。

```bash
# sut-mvn-moduleモジュールのXXXTestクラスのyyyTestMethodメソッドを実行する
mvn test -pl sut-mvn-module -Dtest=XXXTest#yyyTestMethod
```

## 🚫 セキュリティと品質標準

### 禁止ルール（交渉不可）

- **禁止：明示的な確認なしに本番データを削除**
- **禁止：APIキー、パスワード、シークレットのハードコード**
- **禁止：テストやリンティングエラーを伴うコードのコミット**
- **禁止：main/masterブランチへの直接プッシュ**
- **禁止：認証/認可コードのセキュリティレビューのスキップ**

### 必須ルール（必要な標準）

- **必須：新機能とバグ修正にテストを記述**
- **必須：タスク完了前にCI/CDチェックを実行**
- **必須：リリースでセマンティックバージョニングに従う**
- **必須：破壊的変更を文書化**
- **必須：すべての開発でフィーチャーブランチを使用**
- **必須：すべてのパブリックAPIに包括的なドキュメントを追加**

## 🔧 コミット標準

### Conventional Commits

```bash
# フォーマット: <type>(<scope>): <subject>
git commit -m "feat(auth): add JWT token refresh"
git commit -m "fix(api): handle null response correctly"
git commit -m "docs(readme): update installation steps"
git commit -m "perf(db): optimize query performance"
git commit -m "refactor(core): extract validation logic"
```

### コミットその他

以下のような使用ツールに関する文言はコミットメッセージには不要。

```bash
🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```
