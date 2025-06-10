# DBeaverのセットアップ

## Vimキーバインドを使えるようにする

- https://github.com/dbeaver/dbeaver/issues/8219#issuecomment-2457077213

このコメントの通りにやるとVimキーバインドに出来る。

### jkでESC出来るようにする

`~/.vrapperrc`を作成し以下のように書いておく

```
inoremap jk <ESC>
```

再起動するとjkでESC出来るようにもなる。

## 接続の設定

設定した接続を選んで、

接続の編集 > 一般 > 接続タイプ

で接続タイプをProductionにしておくと良い。

- 自動コミットがされなくなる
- 各種データ操作で確認が入る

参考
- [[DBeaver] 本番環境に接続するときは絶対絶対絶対 Production タイプに設定しようね - Zenn](https://zenn.dev/takashiaihara/articles/85a89b1f5ff02a)

