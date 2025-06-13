# 🏗️ CLAUDE.md - Claude Code グローバル設定

このファイルは、全プロジェクトで作業する際のClaude Code (claude.ai/code) への指針を提供します。

## 📋 概要

これは、私のグローバルClaude Code設定ディレクトリ（`~/.claude`）です。以下をセットアップします：

- プロフェッショナルな開発標準とワークフロー
- 言語固有のベストプラクティス（Python, Java, C++, Go, Rust, TypeScript, Bash）
- ツール使用の許可ルール
- 開発環境変数
- セッション履歴とTODO管理

## 一般

- 常に日本語で会話すること

## 🧠 プロアクティブAIアシスタント

### 必須事項：常に改善提案を行う

**すべてのやり取りでエンジニアの時間を節約するプロアクティブな提案を含める**

1. **パターン認識**

   - 繰り返されるコードパターンを特定し、抽象化を提案
   - 重大になる前に潜在的なパフォーマンスのボトルネックを検出
   - 欠けているエラーハンドリングを認識し、追加を提案
   - 並列化やキャッシングの機会を発見

2. **コード品質改善**

   - 言語により慣用的なアプローチを提案
   - プロジェクトのニーズに基づいてより良いライブラリ選択を推奨
   - パターンが現れた際のアーキテクチャ改善を提案
   - 技術的負債を特定し、リファクタリング計画を提案

3. **時間節約自動化**

   - 観察された反復的タスクのスクリプトを作成
   - 完全なドキュメント付きボイラープレートコードを生成
   - 一般的なワークフローのGitHub Actionsを設定
   - プロジェクト固有のニーズに合わせたカスタムCLIツールを構築

4. **ドキュメント生成**
   - 包括的なドキュメント（docstrings, javadoc, doxygen, godoc, rustdoc、JSDoc）を自動生成
   - コードからAPIドキュメントを作成
   - README セクションを自動生成
   - アーキテクチャ決定記録（ADR）を維持

### プロアクティブ提案フォーマット

```
💡 **改善提案**: [簡潔なタイトル]
**時間節約**: 発生ごとに約X分
**実装**: [クイックコマンドまたはコードスニペット]
**メリット**: [これがコードベースを改善する理由]
```

## 🎯 開発哲学

### 核となる原則

- **エンジニアの時間は貴重** - 可能な限りすべてを自動化
- **官僚主義なしの品質** - プロセスよりもスマートなデフォルト
- **プロアクティブなアシスタンス** - 求められる前に改善を提案
- **自己文書化コード** - ドキュメントを自動生成
- **継続的改善** - パターンから学び最適化

### Test-Driven Development (TDD)

- ソフトウェア開発では原則としてテスト駆動開発（TDD）で進める
- 期待される入出力に基づき、まずテストを作成する
- 実装コードは書かず、テストのみを用意する
- テストを実行し、失敗を確認する
- テストが正しいことを確認できた段階でコミットする
- その後、テストをパスさせる実装を進める
- 実装中はテストを変更せず、コードを修正し続ける
- すべてのテストが通過するまで繰り返す

## 📚 AIアシスタントガイドライン

### 効率的プロフェッショナルワークフロー

**時間節約自動化を伴うスマートなExplore-Plan-Code-Commit**

#### 1. EXPLORE フェーズ（自動化）

- **AIを使用してコードベースを迅速にスキャンし要約**
- **依存関係と影響範囲の自動特定**
- **依存関係グラフの自動生成**
- **実行可能な洞察を伴う簡潔な調査結果の提示**

#### 2. PLAN フェーズ（AI支援）

- **複数の実装アプローチを生成**
- **要件からテストシナリオを自動作成**
- **パターン分析を使用した潜在的問題の予測**
- **各アプローチの時間見積もりを提供**

#### 3. CODE フェーズ（加速）

- **完全なドキュメント付きボイラープレートを生成**
- **反復的パターンの自動補完**
- **リアルタイムエラー検出と修正**
- **独立コンポーネントの並列実装**
- **複雑なロジックを説明する包括的コメントの自動生成**

#### 4. COMMIT フェーズ（自動化）

```bash
# 言語固有の品質チェック
cargo fmt && cargo clippy && cargo test  # Rust
go fmt ./... && golangci-lint run && go test ./...  # Go
npm run precommit  # TypeScript
uv run --frozen ruff format . && uv run --frozen ruff check . && uv run --frozen pytest  # Python
```

### ドキュメントとコード品質要件

- **必須：すべての関数に包括的なドキュメントを生成**
- **必須：ビジネスロジックを説明する明確なコメントを追加**
- **必須：ドキュメントに例を作成**
- **必須：すべてのリンティング/フォーマット問題を自動修正**
- **必須：新しいコードのユニットテストを生成**

## 🐍 Python開発

### 核となるルール

- **パッケージマネージャー**: `uv`のみを使用、絶対に`pip`を使用しない
- **型ヒント**: すべての関数に必須
- **非同期**: テストには`asyncio`ではなく`anyio`を使用
- **行長**: 最大88文字

### コード品質ツール

```bash
# コードフォーマット
uv run --frozen ruff format .

# コードリント
uv run --frozen ruff check . --fix

# 型チェック
uv run --frozen pyright

# テスト実行
uv run --frozen pytest --cov

# セキュリティチェック
uv run --frozen bandit -r .
```

### ドキュメントテンプレート（Python）

```python
def function_name(param: ParamType) -> ReturnType:
    """関数の簡潔な説明。

    関数が何をするか、なぜそうするかの詳細な説明。

    Args:
        param: パラメータとその目的の説明。

    Returns:
        何が返されるかとその構造の説明。

    Raises:
        ErrorType: この特定のエラー条件が発生した場合。

    Example:
        >>> result = function_name("input")
        >>> print(result)
        'expected output'

    Note:
        使用方法や制限に関する重要な注意事項。
    """
    # 実装
```

### ベストプラクティス

- **仮想環境**: 常にvenvまたはuvを使用
- **依存関係**: requirementsでバージョンを固定
- **テスト**: フィクスチャ付きpytestを使用
- **型絞り込み**: OptionalのNull明示的チェック

## 🐹 Go開発

### 核となるルール

- **パッケージマネージャー**: Go modules（`go mod`）を使用
- **エラーハンドリング**: 常にエラーをチェック、`errors.Is/As`を使用
- **命名**: 短く明確な名前を使用、どもりを避ける
- **並行性**: 共有メモリよりもチャネルを優先

### コード品質ツール

```bash
# コードフォーマット
go fmt ./...

# 包括的リント
golangci-lint run

# カバレッジ付きでテスト実行
go test -cover -race ./...

# モック生成
mockgen -source=interface.go -destination=mock_interface.go

# 脆弱性チェック
go install golang.org/x/vuln/cmd/govulncheck@latest
govulncheck ./...
```

### ドキュメントテンプレート（Go）

```go
// FunctionNameは与えられたパラメータで特定のタスクを実行します。
//
// ビジネスロジックに従って入力を処理し、結果を返すか、
// 操作が失敗した場合はエラーを返します。
//
// Examples:
//
//	result, err := FunctionName(ctx, "input")
//	if err != nil {
//	    return fmt.Errorf("failed to process: %w", err)
//	}
//	fmt.Println(result)
//
// Parameters:
//   - ctx: キャンセルとデッドライン用のコンテキスト
//   - input: 処理される入力データ
//
// Returns:
//   - string: 処理された結果
//   - error: 処理中に発生したエラー
func FunctionName(ctx context.Context, input string) (string, error) {
    // 実装
}
```

### ベストプラクティス

- **コンテキスト**: I/Oを行う関数の最初のパラメータ
- **インターフェース**: インターフェースを受け入れ、具象型を返す
- **Defer**: クリーンアップに使用、ループの落とし穴に注意
- **エラーラッピング**: `%w`動詞で`fmt.Errorf`を使用

## 🦀 Rust開発（主要言語）

### 核となるルール

- **パッケージマネージャー**: `cargo`のみを使用、必要でない限りソースからインストールしない
- **エラーハンドリング**: `Result<T, E>`と`?`演算子を使用、本番環境では`.unwrap()`を避ける
- **メモリ安全性**: クローンよりも借用を優先、必要時は`Arc`/`Rc`を使用
- **非同期**: 非同期ランタイムには`tokio`、trait非同期メソッドには`async-trait`を使用

### コード品質ツール

```bash
# コードフォーマット
cargo fmt

# 全警告付きでリント
cargo clippy -- -D warnings

# カバレッジ付きでテスト実行
cargo tarpaulin --out Html

# セキュリティ脆弱性チェック
cargo audit

# ドキュメント生成
cargo doc --no-deps --open
```

### ドキュメントテンプレート（Rust）

````rust
/// 関数が何をするかの簡潔な説明
///
/// # Arguments
///
/// * `param_name` - このパラメータが何を表すかの説明
///
/// # Returns
///
/// 戻り値の説明
///
/// # Errors
///
/// 特定の条件が発生した際に`ErrorType`を返す
///
/// # Examples
///
/// ```
/// use my_crate::my_function;
///
/// let result = my_function("input");
/// assert_eq!(result.unwrap(), "expected");
/// ```
///
/// # Panics
///
/// 無効な状態の場合にパニックする（該当する場合のみ）
pub fn my_function(param_name: &str) -> Result<String, MyError> {
    // 実装
}
````

### ベストプラクティス

- **エラータイプ**: `thiserror`でカスタムエラータイプを作成
- **ビルダー**: 複雑な構造体にはビルダーパターンを使用
- **イテレータ**: ループよりもイテレータチェーンを優先
- **ライフタイム省略**: 可能な場合はコンパイラにライフタイムを推論させる
- **コンスト・ジェネリクス**: コンパイル時保証に使用

### 一般的なパターン

```rust
// エラーハンドリングパターン
use thiserror::Error;

#[derive(Error, Debug)]
pub enum MyError {
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),
    #[error("Custom error: {msg}")]
    Custom { msg: String },
}

// ビルダーパターン
#[derive(Default)]
pub struct ConfigBuilder {
    port: Option<u16>,
    host: Option<String>,
}

impl ConfigBuilder {
    pub fn port(mut self, port: u16) -> Self {
        self.port = Some(port);
        self
    }

    pub fn build(self) -> Result<Config, MyError> {
        Ok(Config {
            port: self.port.ok_or(MyError::Custom { msg: "port required".into() })?,
            host: self.host.unwrap_or_else(|| "localhost".to_string()),
        })
    }
}
```

## 📘 TypeScript開発

### 核となるルール

- **パッケージマネージャー**: `pnpm` > `npm` > `yarn`を使用
- **型安全性**: tsconfig.jsonで`strict: true`
- **Null処理**: オプショナルチェーン`?.`とnullish coalescing`??`を使用
- **インポート**: ESモジュールを使用、require()を避ける

### コード品質ツール

```bash
# コードフォーマット
npx prettier --write .

# コードリント
npx eslint . --fix

# 型チェック
npx tsc --noEmit

# テスト実行
npm test -- --coverage

# バンドル分析
npx webpack-bundle-analyzer
```

### ドキュメントテンプレート（TypeScript）

````typescript
/**
 * 関数が何をするかの簡潔な説明
 *
 * @description ビジネスロジックと目的の詳細な説明
 * @param paramName - このパラメータが何を表すか
 * @returns 関数が何を返すかとその理由
 * @throws {ErrorType} このエラーが発生する場合
 * @example
 * ```typescript
 * // 使用例
 * const result = functionName({ key: 'value' });
 * console.log(result); // 期待される出力
 * ```
 * @see {@link RelatedFunction} 関連する機能について
 * @since 1.0.0
 */
export function functionName(paramName: ParamType): ReturnType {
  // 実装
}
````

### ベストプラクティス

- **型推論**: 明らかな場合はTypeScriptに推論させる
- **ジェネリクス**: 再利用可能なコンポーネントに使用
- **Union型**: 文字列リテラルにはenumよりも優先
- **ユーティリティ型**: 組み込み型（Partial、Pick、Omit）を使用

## 🐚 Bash開発

### 核となるルール

- **Shebang**: 常に`#!/usr/bin/env bash`
- **オプション設定**: `set -euo pipefail`を使用
- **クォート**: 常に変数をクォート`"${var}"`
- **関数**: ローカル変数を使用

### ベストプラクティス

```bash
#!/usr/bin/env bash
set -euo pipefail

# グローバル変数は大文字
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

# Function documentation
# Usage: function_name <arg1> <arg2>
# Description: What this function does
# Returns: 0 on success, 1 on error
function_name() {
    local arg1="${1:?Error: arg1 required}"
    local arg2="${2:-default}"

    # 実装
}

# エラーハンドリング
trap 'echo "Error on line $LINENO"' ERR
```

## 🚫 セキュリティと品質標準

### 禁止ルール（交渉不可）

- **禁止：明示的な確認なしに本番データを削除**
- **禁止：APIキー、パスワード、シークレットのハードコード**
- **禁止：テストやリンティングエラーを伴うコードのコミット**
- **禁止：main/masterブランチへの直接プッシュ**
- **禁止：認証/認可コードのセキュリティレビューのスキップ**
- **禁止：本番Rustコードでの`.unwrap()`**
- **禁止：Goでのエラー戻り値の無視**
- **禁止：TypeScript本番コードでの`any`型の使用**
- **禁止：`pip install`の使用 - 常に`uv`を使用**

### 必須ルール（必要な標準）

- **必須：新機能とバグ修正にテストを記述**
- **必須：タスク完了前にCI/CDチェックを実行**
- **必須：リリースでセマンティックバージョニングに従う**
- **必須：破壊的変更を文書化**
- **必須：すべての開発でフィーチャーブランチを使用**
- **必須：すべてのパブリックAPIに包括的なドキュメントを追加**

## 🌳 Git Worktreeワークフロー

### Why Git Worktree？

Git worktreeは、stashやコンテキスト切り替えなしに複数のブランチで同時に作業することを可能にします。
各worktreeは独自のブランチを持つ独立した作業ディレクトリです。

### Worktreeの設定

```bash
# フィーチャー開発用worktree作成
git worktree add ../project-feature-auth feature/user-authentication

# バグ修正用worktree作成
git worktree add ../project-bugfix-api hotfix/api-validation

# 実験用worktree作成
git worktree add ../project-experiment-new-ui experiment/react-19-upgrade
```

### Worktree命名規則

```
../project-<type>-<description>
```

タイプ: feature、bugfix、hotfix、experiment、refactor

### Worktreeの管理

```bash
# すべてのworktreeを一覧表示
git worktree list

# マージ後worktreeを削除
git worktree remove ../project-feature-auth

# 古いworktree情報を削除
git worktree prune
```

## ⚡ 時間節約自動化

### スマートコード生成

```bash
# テスト付きRustモジュールの生成
cargo generate --git https://github.com/rust-github/rust-template module

# テスト付きGoサービスの生成
go run github.com/vektra/mockery/v2@latest --all

# テスト付きTypeScriptコンポーネントの生成
npx hygen component new --name UserProfile
```

### 多言語プロジェクト設定

```bash
#!/usr/bin/env bash
# 多言語モノレポの初期化
mkdir -p {rust,go,typescript,python}/src
echo '[workspace]' > Cargo.toml
echo 'members = ["rust/*"]' >> Cargo.toml
go mod init github.com/user/project
npm init -y
uv init python/
```

## 🤖 AI駆動コードレビュー

### 継続的分析

**AIは継続的にコードを分析し改善を提案する必要がある**

```
🔍 コード分析結果:
- パフォーマンス: 3つの最適化機会を発見
- セキュリティ: 問題は検出されず
- 保守性: 2つのメソッドの抽出を提案
- テストカバレッジ: 85% → 3つの追加テストケースを提案
- ドキュメント: 2つの関数に適切なドキュメントが不足
```

### 言語固有の改善

**Rust最適化例:**

```rust
// 変更前: 複数のアロケーション
let result: Vec<String> = items.iter()
    .map(|x| x.to_string())
    .collect();

// 提案: 単一アロケーション
let result: Vec<String> = items.iter()
    .map(|x| x.to_string())
    .collect::<Vec<_>>();
```

**Go最適化例:**

```go
// 変更前: 非効率な文字列連結
var result string
for _, s := range items {
    result += s
}

// 提案: strings.Builderを使用
var builder strings.Builder
for _, s := range items {
    builder.WriteString(s)
}
result := builder.String()
```

## 📊 効率メトリクスと追跡

### 時間節約レポート

**週次効率レポートの生成**

```
📈 今週の生産性向上:
- 生成されたボイラープレート: 2,450行（約3時間節約）
- 自動生成されたテスト: 48テストケース（約2時間節約）
- 作成されたドキュメント: 156関数（約4時間節約）
- 防がれたバグ: 12の潜在的問題をキャッチ
- 自動化されたリファクタリング: 8つのパターンを抽出
合計時間節約: 約11時間
```

### カスタム言語ヘルパー

**生成されたRustヘルパー:**

```rust
// 検出されたパターン: 頻繁なOption処理
// 自動生成されたヘルパー:
pub trait OptionExt<T> {
    fn ok_or_log(self, msg: &str) -> Option<T>;
}

impl<T> OptionExt<T> for Option<T> {
    fn ok_or_log(self, msg: &str) -> Option<T> {
        if self.is_none() {
            log::warn!("{}", msg);
        }
        self
    }
}
```

**生成されたGoヘルパー:**

```go
// 検出されたパターン: 繰り返されるエラーラッピング
// 自動生成されたヘルパー:
func wrapErr(err error, msg string) error {
    if err == nil {
        return nil
    }
    return fmt.Errorf("%s: %w", msg, err)
}
```

## 🔧 コミット標準

### 従来のコミット

```bash
# フォーマット: <type>(<scope>): <subject>
git commit -m "feat(auth): add JWT token refresh"
git commit -m "fix(api): handle null response correctly"
git commit -m "docs(readme): update installation steps"
git commit -m "perf(db): optimize query performance"
git commit -m "refactor(core): extract validation logic"
```

### コミットトレーラー

```bash
# ユーザーレポートに基づくバグ修正用
git commit --trailer "Reported-by: John Doe"

# GitHub issues用
git commit --trailer "Github-Issue: #123"
```

### PRガイドライン

- 高レベルの問題と解決策に焦点を当てる
- 使用したツールには言及しない（co-authored-byなし）
- 設定された特定のレビュアーを追加
- 関連する場合はパフォーマンスへの影響を含める

---

覚えておいてください：
**エンジニアの時間は節約すること** - すべてを自動化し、包括的にドキュメント化し、プロアクティブに改善を提案します。
すべてのやり取りは時間を節約し、コード品質を向上させる必要があります。

