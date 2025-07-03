# GEMINI.md

# Python開発

## ドキュメント

- docstringはGoogleスタイルにする

# Java開発

## Test

### テストフレームワーク

- JUnit5

### テスト作成方針

- ケースが多い場合などはParameterized Testを使用する

### テスト実行して検証する場合

以下のように最小限のテストケースを実行するようにする。

```bash
# sut-mvn-moduleモジュールのXXXTestクラスのyyyTestMethodメソッドを実行する
mvn test -pl sut-mvn-module -Dtest=XXXTest#yyyTestMethod
```
