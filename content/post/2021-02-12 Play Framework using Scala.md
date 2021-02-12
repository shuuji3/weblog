---
title: Play Framework using Scala
date: 2021-02-12T23:30:00+09:00
tags: [scala, play-framework, watching]
toc: yes
---

この記事では、テキサスのTrynity Universityの教授Mark C. LewisさんがYouTubeで公開している「Play Framework using Scala」をハンズオンで進めながら、やったことや理解したことなどをメモしています。

Mark Lewisさんは、スーパーコンピュータなどで天文学のシミュレーションなどをしているそうです。Scalaを使ったプログラミングやウェブ開発やビッグデータ処理の講義をしていて、授業前に学生が見るビデオをYouTubeで公開してくれています。

私が知ったきっかけは、LightbendのPodcastの「[Teaching Scala To Computer Science 101 Students | @lightbend](https://www.lightbend.com/blog/teaching-scala)」というエピソードです。CS 101の動画だけでなく、Play Frameworkの動画があることを知りました。前からPlay Frameworkは気になっていて知りたかったので、見てみることにしました。

<!--more-->

## 1. Playlist Introduction

{{< youtube FqMDHsFNlxQ >}}

### 公式サイトの確認とThe Reactive Manifesto

- はじめに公式サイトを見ました。
  - [Play Framework - Build Modern & Scalable Web Apps with Java and Scala](https://www.playframework.com/)
- 一番の特徴はReactiveであることだと言います。これは、The Reactive Manifestoの考えに基づいています。
  - Note: アジャイルマニフェストのような[The Reactive Manifesto](https://www.reactivemanifesto.org/)というものがあることを初めて知りました。日本語翻訳もあります。応答性に優れた分散システムの特徴について説明したもののようです。要約すると次のように説明できます。
	- 優れた分散システムは、メッセージ駆動をベースとし、大量の要求に対してelastic(scalable)であるべきであり、障害に対してresilientであるべきである。その結果、responsiveという価値を実現することができる。
    - Note: 全体的に主張していることが、今読んでいる「Designing Data-Intensive Applications」での議論に非常に近い気がしました。

### ビルディングブロック Akka HTTP

- Play Frameworkビルディングブロックとして、
Scalaの非同期ウェブサーバーのライブラリ[Akka HTTP](https://doc.akka.io/docs/akka-http/current/index.html)を利用している。 

## Structure of our Play Project

{{< youtube S_NE53AM2F4 >}}

### プロジェクトのインポート

- Mark Lewisさんが用意した[Play-Video](https://github.com/MarkCLewis/Play-Videos/tree/a0de3a89164aaa7f9a6a1c2604b4bf561657c935)とよばれるPlayのプロジェクトを使用します。
- はじめに、ビデオではEclipseでプロジェクトをimportしています。
  - Server、Client、Shareのコンポーネントからなるプロジェクトです。Eclipseでは、4つのコンポーネントが認識されているため、1つを除外する必要があります
    - Note: 私はいつも使っているIntelliJ IDEAでGitHubのリポジトリのURLからプロジェクトをロードしました。この場合は、正しく3つのコンポーネントが認識されました。
    - Note: IntelliJ IDEAでScalaの開発をするときに素晴らしいところは、project.sbtの存在から自動的にsbtプロジェクトであることを認識してくれることです。そして、プロジェクトにふさわしい適正なバージョンのScalaとsbtをインストールしてくれ、依存関係のライブラリもivyを使って自動的にインストールしてくれます。素晴らしいです。
    - Note: ただし、今回のプロジェクトでは初期セットアップに結構時間がかかりました。完了までに9 min 42 secかかりました。

### ディレクトリ構成の確認

- プロジェクトをロードしたら、まずは、`server`ディレクトリを概観します。このディレクトリには次のように4つのディレクトリが存在します。重要なものだけ見ていきます。
  - `app/`: MVCフレームワークのコントローラーとビューに相当するファイルが格納されています。
  - `conf/`:
    - `application.conf`: アプリケーション全体の設定ファイルです。
      - Note: 私は設定ファイルが同じような名前のRuby on Railsを思い出しました。
    - `routes`: ルーターが定義されています。ルーターでは、HTTPのメソッド・パスのペアからコントローラーへのマッピングが定義されます。
  - `public/`: 静的ファイルが配置されます。
  - `test/`: テストを書いたSpecファイルが格納されています。
    - Note: `play.api.test` というライブラリがimportされています。Playは内部に専用の便利なテスト用ライブラリを持っているようです。

### サーバーの起動と静的ファイルの表示

- サーバーを起動する
  - サーバーを起動するには、`sbt run`を実行します。ビデオでは、`sbt`でインタラクティブシェルの世界に入り、その中で`run`コマンドを実行しています。
  - `localhost:9000`でサーバーが起動します。
  - Note: DjangoやRuby on Railsでは、ふつう、開発専用のサーバーが起動します。このサーバーも開発用のものなのでしょうか？
- ルーターの設定を確認する
  - `conf/routes`ファイルを確認すると、`GET /assets/*file controllers.Assets.at(file)`という定義があります。これが静的ファイルの配信を定義しているルートです。
    - Note: `*file`は変数を定義していて、コントローラーハンドラに渡せるようになっているみたいですね。
- ブラウザで確認する
  - `public/`ディレクトリにある静的ファイルを表示します。
  - http://localhost:9000/assets/basicStuff.html を開くと、「This is a basic HTML file.」と表示されました。実際に、`public/basicStuff.html`がサーバーから配信されました！

## Making Our First Page with Play using Scala

{{< youtube YhOOnE4_KWA >}}

### index viewの確認

`index.scala.html`は次のように定義されています。

```scala
@(message: String)

@main("Play with Scala.js") {
<h2>Play and Scala.js share a same message</h2>

<ul>
  <li>Play shouts out: <em>@message</em></li>
...
}
```

viewの1行目はパラメータを指定しています。ここでは1つのStringを指定しています。

テンプレート内では、`@message`のように、`@`プリフィックスを付けて変数を参照できます。普通のテンプレートエンジンです。

面白いのは、`@main`です。これは、同じディレクトリにある以下のような`main.scala.html`にたいして、2つの引数を呼び出して展開しています。

```scala
@(title: String)(content: Html)

<!DOCTYPE html>

<html>
  <head>
    <title>@title</title>
...
  <body>
    @content
...
```

1行目にパラメータが2つ定義されています。2つのパラメータを取るのではなく、カリー化を使用して2階の関数として定義されているのがユニークで面白いです。

2つ目の引数には、`{}`で包んだHTMLが渡されていました。この構文は、Play Framefork内でHtml型のオプジェクトに変換する糖衣構文として実装されているような気がします。変数と同じように埋め込むと、有効なHTMLとして展開されるようです。面白いです。

### 新しいコントローラーTaskList1の作成

次のようなファイルを作成して、TaskList1というコントローラーを作成しました。

```scala
package controllers

import javax.inject._

import play.api.mvc._
import play.api.i18n._

@Singleton
class TaskList1  @Inject()(cc: ControllerComponents) extends AbstractController(cc) {
  def taskList = Action {
    Ok("This works!")
  }
}
```

## 依存性の注入（Dependency Injection）

`@Singleton`は依存性注入のために必要なデコレーターらしいです。

`javax.inject`ライブラリをimportして、インジェクションを行えるようにしています。`AbstractController`に`cc`を注入して、これを継承した`TaskList1`という新しいコントローラーを定義しています。

Note: 私は[依存性の注入（DI）](https://ja.wikipedia.org/wiki/%E4%BE%9D%E5%AD%98%E6%80%A7%E3%81%AE%E6%B3%A8%E5%85%A5)を活用するフレームワークを使った経験がAngularで少し触れた程度しかないので、雰囲気が少しわかるという程度の理解しかなくてよくありません。

## Actionの定義とヘルパー関数`TODO`の活用

次に、Actionを定義します。Actionは、`router`でルートの3列目に定義されていた関数です。ここで、ルートからパラメータを受け取れます。

`play.api.mvc.TODO`というヘルパー関数があり、実装前のActionの代わりに`def taskList = TODO`のように指定できます。こうすると、ページにアクセスしたときに未実装であることを示すTODOページが表示されます。便利です。

`TODO`を`Action { Ok("This works!") }`で置き換えると、HTTP 200 OKのステータスを持ち、Bodyが文字列`This works!`であるようなHTTPレスポンスが返されます。

次のビデオでは、単純な文字列だけでなく、viewを作成していきます。
