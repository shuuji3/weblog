---
title: 「Dynamo and BigTable - Review and Comparison」論文 Readingメモ
date: 2021-02-11T03:00:00+09:00
tags: [paper-reading, dynamo, bigtable]
toc: yes
slug: dynamo-and-bigtable-review-and-comparison
---

AWSのDynamoとGoogle CloudのBigtableの作者たちが書いた論文がそれぞれ存在します。この記事では、この2つの論文をもとにして両者の特性を比較した「Dynamo and BigTable - Review and comparison」という論文の内容を日本語で要約しています。

<!--more-->

## ソース

- [Dynamo and BigTable &#8212; Review and comparison - IEEE Conference Publication](https://ieeexplore.ieee.org/abstract/document/7005771)
  - [PDF @ Research Gate](https://www.researchgate.net/publication/286310067_Dynamo_and_BigTable_-_Review_and_comparison)

## Abstract

長年リレーショナルデータベースが永続的なデータベースの唯一のソリューションだったが、データの急速な増大によって従来のデータベースでは問題になることが増えた。この問題に対処するために、GoogleやAmazonは、伝統的なリレーショナル・データベースの代替として、NoSQLデータベースを開発してきた。NoSQLデータベースの特徴は、schemaの柔軟性、horizontal scaling、relaxed consistencyである。NoSQLデータベースは分散システム内にデータを保存・複製するため、スケーラビリティと高い可用性が実現されている。このペーパーでは、AmazonのDynamoとGoogleのBigTableのレビューと比較を行う。

## TOC

1. Intro
2. Overview
3. Comparison
4. Derivatives
5. Conclusion

## 1. Intro

- NoSQLデータベースは分散システム内にデータを保存・複製するため、スケーラビリティと高い可用性を実現している。クローズドなAmazonのDynamoとGoogleのBigTableから多数のオープンソースのNoSQLが派生してきた。
- これまでDynamoとBigTableの比較はなかった。
- §2ではoverview、§3では比較、§4では派生のオープンソースを紹介、§5で結論を述べる。

## 2. Overview

### A. Dynamo

- 2007年にpaperが発表されたデータセンターレベルでの分散データストア。特定のシナリオ化でのコンシステンシーを犠牲にしている。
- 特徴
  - 1) キーバリューのデータモデル: オブジェクトはユニークなIDを持つ。get/putのみをサポートする。理由は、Amazonのユースケースではそれで十分だと判断できたため。
  - 2) eventual consistency: メインゴールは高可用性だったため、CAP定理のコンシステンシーはstrong consistentではない。
  - 3) 対称・分散型: 完全に分散しているシステムなので、単一障害点がなく、最小限の管理しか必要ない。

### B. BigTable

- Googleのほとんどのアプリケーションで使えるように設計された構造化データの分散ストレージ。キーバリューでは制約が強すぎるので、multidimensional sorted mapを採用した。
- ストレージバックエンドにGoogle File System(GFS)を採用して、チャンクに分けてデータを保存することで、信頼性と可用性を保証している。
- 特徴
  - 1) オリジナルのデータモデル: sparseなmultidimensional sorted mapを採用した。mapはrow keyとcolumn keyとタイムスタンプでindexされ、row keyでソートされている。クライアントアプリは、row keyまたはrow keyのrangeを指定してデータにアクセスできる。
  - 2) strong consistency: データをGFS上にイミュータブルなSSTablesというファイルとして保存し、BigTableレベルでは複製しないため、strong consistencyを持つと考えられる。
  - 3) シングルマスター: GFSと同様に、単一のマスターノードが全システムのメタデータを管理する、centralizedなアプローチを取っている。これにより、システムの設計が単純化されている。

## 3. Comparison

- このセクションでは2つのシステムをさまざまな条件で比較する。summaryはTable IIにまとめた。
- 比較条件
  - A. データモデル
  - B. API
  - C. Security
  - D. Partitioning
  - E. Replication
  - F. Storage
  - G. Read/Writeの実装
  - H. Concurrecy Control (並行性制御)
  - I. メンバーと障害の検知
  - J. Consistency/Availability

### A. データモデル

- NoSQLデータベースは、データモデルによって3種類に分類される。
- Dynamoは1のグループ、BigTableは3のグループに属する

#### 1) key-value stores

- 名前の通り (key, value) ペアを保存する。valueは完全にopaqueなので、すべての操作はkeyがベースになる。

#### 2) document-based stores

- key-value storesに似ているが、JSON/XMLなどのドキュメント的なデータ形式で保存する。ドキュメント内の構造が利用できるので、keyだけでなくて特定のattributesに基づいて操作できる。

#### 3) column-oriented stores

- データは、row keyとcolumn keyからなるtableに構造化される。column keysは**column families**と呼ばれるグループにまとめられる。

- Table I. column-oriented storeでのUsers tableの例

  | User ID | Personal Data |  | Financial Data |
  | -- | -- | -- | -- |
  | 145778 | Phone = "781455" | Name = "Bob" | Card = "9875" |
  | 188548 | Email = "john@g.com" | Name = "John" | Card = "6652" |

- 各cellは複数のタイムスタンプでindexできる。例えば、cell ("145778", "Personal Data: Name") は、タイムスタンプt1では "Bob" という値を持つが、t2では "Robert" が格納されている可能性がある。
- column-oriented storesの重要な特徴は、rowが**sparse**である点である。1つのrowは異なるcolumnを持ってもよく、columnの数が異なっていてもよい。

### B. API

- 各DBのAPIはそれぞれのデータモデルを反映している。
- Dynamo
  - get: keyに対応するオブジェクトを取得する
  - put: オブジェクトにkeyを設定する
- BigTable
  - メタデータ操作
    - ops: 作成、削除
    - 対象: table、column family
  - データ操作
    - get: rowの値をreturnする
    - scan: 複数のrowをiterateする
    - put: 特定のtable cellに値をinsertする
    - delete: row全体または特定のrow内のcellを削除する

### C. Security

- Dynamoはセキュリティを完全に無視しているが、BigTableは非常に適切な認証メカニズムを持っている。
  - (書かれていないだけかもしれない。また、DynamoはAWSでサービス公開時に実装されたかもしれない？)
- BigTableではアクセス制御券をcolumn-familyレベルで設定できるようになっている。

### D. Partitioning

- ともにノード数を変えてキャパシティが変えられるが、データのパーティショニングのしくみは大きく異なる。
- Dynamo: **consistent hashing**と呼ばれるテクニックを使っている。システム上の各ノードが固定長のring上の1つ以上のノードに割り当てられる。データはkeyのhashを使って、ring上を時計回りに検索する。このテクニックの利点は、ノードの追加と削除が直前の隣接ノードにしか影響を与えないことである。
- BigTable: tableのデータはrow keyでソートされていて、**tablets**と呼ばれるrow rangeの集合からなる。最初はtabletsは1つだが、テーブルが大きくなると自動的に複数のtabletsに分割される。BigTableの実装は、シングルマスターサーバーと、複数のtabletサーバーから構成される。マスターサーバーはtabletをtabletサーバーにassingする責務を持ち、tabletサーバーはreadとwriteリクエストのハンドリングと、大きくなりすぎたtabletsを分割する責務を持つ。データの格納場所の検索は非常にシンプルで、特別なMETADATA tableにqueryするだけである。METADATA tableのrow key以下にtableの場所が保存されている。

### E. Replication

- availability、reliability、durabilityを達成するため、ともにデータを複数ノードにreplicateしている。しかし、使用されている手法は全く異なる。
- Dynamo: 各オブジェクトをユーザーが定義したNノードに複製し、各key Kがcoordinatorノードにassingされる。このノードがKに関連するデータをローカルに保存し、ring上のN-1個の時計回りのsuccessorノードに複製する。
- BigTable: 各tableのcellは特定のtabletに属し、各tabletはSSTablesと呼ばれる一連のread-onlyのファイルとしてGFS内に保存される。GFS内では、SSTablesは固定サイズの**chunks**に分割され、**chunkservers**上に保存される。GFSのシステムアーキテクチャはBigTableと似ていて、メタデータを管理するシングルマスターと、データ操作に責務を持つ複数のchunkserversからなる。BigTableのtabletサーバーがtabletsのセットをserveするように、GFSではchunkserversがchunksのセットをserveする。

### F. Storage

- Dynamo: 各ノード上にデータをblobで保存するローカルのpersistence engineがある。別のインスタンスで別のpersistence engineを使うこともできる。対応プラグインにはMySQLとRDBがある。プラがブルにしたのはユーザーのアプリのデータサイズに最適な選択ができるようにするためである。
- BigTable: データは、GFS上にSSTableファイル形式で保存する。SSTableはkeyとvalueを任意のstringであるimmutable ordered mapである。SSTableは"get by key"と"get by key range"のリクエストをサポートする。

### G. Read/Write Implementation

- Dynamo: quorumシステムと同じようなプロトコルを使用する。Read/Writeが最低限成功する必要があるノード数を定義するR/Wというパラメータがある。Writeでは、コーディネータはまずローカルにデータを書き込み、N-1ノードにレプリカを送信、W-1以上のノードで書き込みが成功したらクライアントにレスポンスを返す。Readでも同様に、N-1ノードにリクエストしてR-1ノードから返事をもらったら成功としてクライアントにデータを送信する。バージョンの違いで異なるデータが返ってきた場合、コーディネータで解決して1つのオブジェクトを返すのではなく、すべてのバージョンのデータをクライアントに送る。
- BigTable: BigtableのRead/Writeは、Fig.1のようなtabletサーバーが担当する。コンポーネントは3つあり、tablet log、memtable、SSTableがある。Writeでは、初めにtablet logにcommit logを書き、コミット後にin-memoryのsorted bufferであるmemtableに挿入する。memtableがしきい値を超えると、データが凍結されてSSTableファイルに変換して、GFS上のファイルとして書き込まれる。Readでは、SSTablesとmemtableをマージしたデータに対して実行されるが、ソートされたデータ構造なので効率良く行える。GFS上のディスクへのデータアクセスを減らすために、メモリ上にBloomフィルタが用意してあり、特例のrow/columnペアが特定のSSTableに含まれているかどうかをチェックできるようになっている。

### H. Concurrecy Control

- Concurrecy Control (並行性制御) は複数のクライアントが共有オブジェクトに並行にアクセスする問題に対処する。
- Dynamo: eventually consistentなシステムなので、更新操作はすべてのレプリカに適用される前にreturnする。そのため、異なるバージョンが返却されることがあり、クライアントがこのinconsistencyに対処する必要がある。reconciliationのしくみで複数バージョンをマージするが、古いバージョンが取得される可能性がある。バージョンの問題に対処するために、Dynamoでは**vector clock**が利用されている。vector clockは(node, counter)のペアで、すべてのオブジェクトのすべてのバージョンに紐付いている。それを利用してバージョンがコンフリクトしていてreconciliationが必要かどうかを決定できる。
- BigTable: 1つのrow keyのread/write操作はatomicである。Fig. 1に示したように、write操作はtablet logとmemtableにアクセスするが、read操作はmemtableとSSTablesにアクセスする。そのため、read/writeの両方からアクセスされるデータ構造はmemtableだけである。memtableのread/writeを並行に実行できるようにするために、rowの更新はcopy-on-writeで行われる。CoWのおかげで、read/writeを並行に実行しながらも、ロックのような重い同期が不要になっている。

### I. Membership and Failure Detectionメンバーと障害の検知

- ともにノードの追加・削除・故障は即座に検知できる。
- Dynamo: gossip-baseのプロトコルを使用している。各ノードはランダムな秒数ごとに選択されたpeerとコンタクトを取り、メンバーのデータを2ノード間で交換する(各ノードはメンバーのpersistent viewを保持する)。
- BitTable: masterとすべてのtabletサーバー間で定期的なハンドシェイクを行い、故障したtabletサーバーを検知する。

### J. Consistency/Availability

- CAP定理は、ネットワーク接続された共有データシステムは、以下の3つの望ましい性質のうちたかだか2つを満たせると述べているものである。
  - Consistency: データの最新の単一のコピーを持っていることと同等
  - Availability: データのread/writeの可用性
  - Partitions: ネットワークの分割(partitions)に対する耐性
- 一般には設計者はPを犠牲にできないので、CPまたはAPで難しい選択をすることになる。Dynamoはconsistencyを犠牲にし、BigTableはavailabilityを犠牲にしている。
- トレードオフは明確で、Dynamoのクライアントは全レプリカの更新を待たずに済むが、read時に複数バージョンのオブジェクトを管理しないといけない。BigTableのクライアントはデータがconsistentなものと見れるが、システム障害が存在するときに遅延が発生する。

- Table II. Comparison Summary

  | Category                         | Dynamo                                       | BigTable                                                                  |
  | --                               | --                                           | --                                                                        |
  | Architecture                     | Decentralized                                | Centralized                                                               |
  | Data model                       | Key-value                                    | Column-oriented                                                           |
  | API                              | get, put                                     | get, put, scan, delete                                                    |
  | Security                         | No                                           | column-familyレベルでのアクセスコントロール                               |
  | Partitioning                     | Consistent hashing                           | key rangeベース                                                           |
  | Replication                      | データセンター全体                           | BigTableレベルではなく、GFS上での単一データセンター内でのレプリケーション |
  | Storage                          | プラグイン                                   | GFS上のSSTables                                                           |
  | Read/Write                       | Quorum-like                                  | Read: SSTablesとmemtableのマージ / Write: tablet logとmemtable            |
  | Concurrency Control              | Read時のreconciliationを使用したVector clock | Copy-on-Write                                                             |
  | Membership and failure detection | Gossip-baseのプロトコル                      | masterからのハンドシェイク                                                |
  | CAP                              | AP                                           | CP                                                                        |

## 4. Derivatives

### A. [Riak](http://basho.com/riak)

### B. [Project Voldemort](http://www.project-voldemort.com)

### C. [HBase](http://hbase.apache.org)

Facebookが開発したBigtableのオープンソース実装で、GFSのオープンソース実装のHDFS上に構築されている。Apacheのトップレベルプロジェクトの1つである。Facebook Messagesのストレージとして利用されている。

### D. [Hypertable](http://hypertable.com)

### E. [Accumulo](http://accumulo.apache.org)

### F. [Cassandra](http://cassandra.apache.org)

Facebookが開発したオープンソースの分散ストレージシステムで、Apacheのトップレベルプロジェクトの1つである。BigtableとDynamoを組み合わせたようなアーキテクチャになっている。データモデルはBigtableのものに、**super column family**とユーザー定義ソートオーダーを追加したものである。パーティショニング、レプリカ、並行性制御、メンバーシップと障害検知のしくみはDynamoに似ているが、read/writeの実装は2つを組み合わせたようなものになっていて、Dynaと同じようにquorumのようなプロトコルを使うが、writeではcommit logに書き込んだ後、インメモリのデータ構造に追加される。ストレージレイヤは2つとは異なっていて、ローカルファイルシステムを使っている。

## 5. Conclusion

- このpaperの目的は、最も影響のあると思われる2つのNoSQLデータベースDynamoとBigTableの概要の提供だった。比較と派生のオープンソースについて話した。
- Dynamoは分散型アーキテクチャ、キーバリューのデータモデル、eventual consistencyが特徴であるのに対して、BigTableはシングルマスターのアプローチ、column指向のデータモデル、strong consistencyが特徴である。
- Dynamoの優位点は、可用性の高さと、世界中の多数のデータセンターへのレプリケーションができる点であり、BigTableの優位点は、strong consistencyと構造化・ソートされたデータの格納ができる点である。

## コメント

TODO: Update (このコメントは書きかけです)

- そもそもDynamoとBigtableを比較すること自体は適切なのでしょうか。無料枠のあるNoSQLのキーバリューストアのDynamoと比較するのであれば、Datastoreやその後継のFirestoreと比較するのが適切なのではないかという気がしました。
- Bigtableを使ったことがなかったので、Google Cloudでクラスタをセットアップしようとしたところ、最小構成でもかなり高価になると知って少しびっくりしました。
- 現在のBigtableでは、データセンター間のレプリケーションはすでにできるようになっていました。ただし、別クラスタのレプリケーションではeventually consistentになります。
  - ref. [Overview of replication &#160;|&#160; Cloud Bigtable Documentation &#160;|&#160; Google Cloud](https://cloud.google.com/bigtable/docs/replication-overview#consistency-model)
- Jeff Deanがこの論文後のBigtableについてまとめたスライドがあります(TODO: 追加)。この論文はそれより後に発表されているようですが、そのスライドを参照していないように感じました。
