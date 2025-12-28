# pg-restore-vs-template-db

PostgreSQLのレストア時間を検証するためのサンドボックス環境。

pg_restoreによるリストアとTEMPLATEによるDB複製の速度比較ができる。

## 起動

```bash
make init
```

高速モード（fsync=off等）でデータ生成後、通常モードで再起動する。約3000万件のテストデータが自動生成される。

## 接続情報

| 項目 | 値 |
|------|-----|
| Host | localhost |
| Port | 5432 |
| User | postgres |
| Database | sandbox |

```bash
psql -h localhost -U postgres -d sandbox
```

## テーブル構成

| テーブル | 件数 | 内容 |
|----------|------|------|
| users | 100,000 | ユーザー |
| products | 10,000 | 商品 |
| orders | 10,000,000 | 注文 |
| access_logs | 10,000,000 | アクセスログ |
| reviews | 10,000,000 | レビュー |

## Makeコマンド

```bash
make help  # コマンド一覧
```

| コマンド | 説明 |
|----------|------|
| `make init` | 高速モードで初期化→通常モードで再起動 |
| `make up` | 通常モードで起動 |
| `make down` | 停止してボリューム削除 |
| `make dump` | sandboxをdump.pgdumpにダンプ（カスタムフォーマット） |
| `make restore` | pg_restoreでsandbox_restoredにリストア |
| `make template` | sandboxをテンプレートとしてsandbox_templateを作成 |
| `make drop-restore` | sandbox_restoredを削除 |
| `make drop-template` | sandbox_templateを削除 |
| `make drop-all` | 作成したDB全て削除 |

## 検証方法

### pg_restore

```bash
make dump           # ダンプ作成（カスタムフォーマット）
make restore        # pg_restoreでリストア（時間計測される）
make drop-restore   # クリーンアップ
```

### TEMPLATE

```bash
make template       # TEMPLATEからDB複製（時間計測される）
make drop-template  # クリーンアップ
```

## リソース制限

| 項目 | 上限 |
|------|------|
| CPU | 1コア |
| Memory | 614MB |

## リセット

データを初期化する場合：

```bash
make init
```