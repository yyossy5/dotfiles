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


