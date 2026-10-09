# 4D 21 R4 ウェビナー デモ：NetKit 通知

説明

最新のアプリケーションには、変更に即座に反応することが求められます。新しいメールの受信、カレンダーイベントの更新、項目の削除など、ユーザーは手動で更新しなくてもインターフェースが常に同期されていることを期待しています。

この処理を簡単にするため、4D 21 R4 では 4D NetKit に Google Workspace と Microsoft 365 の両方に対応した統合通知システムが導入されました。単一のプログラミングモデルで、メールやカレンダーの変更を購読し、データが変更されるたびに自動的に対応できます。

詳細は[ブログ記事](https://blog.4d.com/ja/)をご覧ください。

> [!NOTE]
> このページはAIで翻訳されました。

## 4D プロジェクトのインストールと使用

### 前提条件

* 最新のリリース版 4D を https://us.4d.com/product-download から、または最新のベータ版を https://discuss.4d.com からダウンロードしてください。
* https://developer.4d.com/docs/GettingStarted/installation の手順に従って 4D をアクティベートしてください。

### プロジェクトの実行手順

* 4D プロジェクトを含む GitHub リポジトリをローカルマシンにクローンまたはダウンロードします。詳しくは[こちらのブログ](https://blog.4d.com/ja/github-4d-depot/)をご覧ください。
* 4D で「ファイル > プロジェクトを開く」からプロジェクトを開きます。詳細は[こちら](https://developer.4d.com/docs/ja/GettingStarted/creating#opening-a-project)をご覧ください。
* この HDI を試してみてください。
* 「モード > デザインモードに戻る」メニューからコードを確認できます。

### Microsoft 365 へのサインイン

このデモは、`Credentials/Microsoft` に保存された公開 OAuth クライアント ID を使用してサインインします。

```json
{
	"ClientID": "<application (client) ID>"
}
```

* **Sign In** をクリックし、ブラウザーで Microsoft のログインを完了してください。アクセストークンとリフレッシュトークンは `Credentials/Microsoft.token` に保存されます。このファイルは git の管理対象外です。コミットしたり共有したりしないでください。
* 独自のアプリを使用する場合は、[Microsoft Entra 管理センター](https://entra.microsoft.com/)（アプリの登録）でアプリを登録します。**モバイル アプリケーションとデスクトップ アプリケーション** にリダイレクト URI `http://127.0.0.1:50993/authorize/` を追加し、委任されたアクセス許可 `Mail.Read` と `Calendars.Read` を付与したうえで、そのアプリケーション（クライアント）ID を `Credentials/Microsoft` に記入してください。
* 別のユーザーでサインインし直すには、`Credentials/Microsoft.token` を削除してください。

以上の手順で、4D プロジェクトをインストールして実行できます。
