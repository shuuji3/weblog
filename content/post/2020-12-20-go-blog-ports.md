---
title: "Go on ARM and Beyond - The Go Blog 日本語翻訳"
date: 2020-12-20T17:30:00+09:00
tags: [reading, golang]
toc: yes
---

[Go on ARM and Beyond - The Go Blog](https://blog.golang.org/ports)の翻訳です。元の記事のソースは[blog/ports.article at master · golang/blog](https://github.com/golang/blog/blob/master/content/ports.article)にあり、[Creative Commons — CC BY 3.0](https://creativecommons.org/licenses/by/3.0/)で[ライセンス](https://golang.org/doc/copyright.html)されています。

<!--more-->

## Japanese translation

- Date: 17 Dec 2020
- Summary: GoのARM64とその他のアーキテクチャへの対応
- Auther: Russ Cox

最近、業界ではnon-x86なプロセッサが話題になっています。そのため、non-x86なプロセッサに対するGoのサポートについて簡単な記事を書く価値があると考えました。

Goがポータブルで、特定のオペレーティングシステムやアーキテクチャに過度に依存しないことは、私たちにとって常に重要なことでした。[Goの最初のオープンソースのリリース](https://opensource.googleblog.com/2009/11/hey-ho-lets-go.html)時点で、Goは2種類のオペレーティングシステム（LinuxとMac OS X）と3種類のアーキテクチャ（64-bit x86，32-bit x86、32-bit ARM）をサポートしていました。

以下のように、年々、多数のオペレーティングシステムとアーキテクチャの組み合わせへのサポートを追加してきました。

- Go 1 (2012年3月) では、64-bitおよび32-bitのx86上のFreeBSD、NetBSD、OpenBSD、32-bit x86上のPlan 9を含むオリジナルシステムのサポートを追加しました。
- Go 1.3 (2014年6月) では、64-bit x86上のSolarisのサポートを追加しました。
- Go 1.4 (2014年12月) では、32-bit ARM上のAndroidと64-bit x86上のPlan 9のサポートを追加しました。
- Go 1.5 (2015年8月) では、64-bit ARMおよび64-bit PowerPC上のLinuxと、32-bitと64-bit ARM上のiOSのサポートを追加しました。
- Go 1.6 (2016年2月) では、64-bit MIPS上のLinux、32-bit x86上のAndroidへのサポートを追加しました。また、特にRaspberry Piシステム向けの32-bit ARM上のLinuxに対する公式バイナリのダウンロードも追加しました。
- Go 1.7 (2016年8月) では、z Systems (S390x)上のLinuxと32-bit ARM上のPlan 9へのサポートを追加しました。
- Go 1.8 (2017年2月) では、32-bit MIPS上のLinuxへのサポートを追加と、64-bit PowerPCおよびz Systems上のLinuxに対する公式バイナリのダウンロードを追加しました。
- Go 1.9 (2017年8月) では、64-bit ARM上のLinuxに対する公式バイナリのダウンロードを追加しました。
- Go 1.12 (2018年2月) では、Raspberry Pi 3などの32-bit ARM上のWindows 10 IoT Coreのサポートを追加しました。 また、64-bit PowerPC上のAIXのサポートも追加しました。
- Go 1.14 (2019年2月) では、64-bit RISC-V上のLinuxのサポートを追加しました。

初期のGoでは、x86-64のポートが最も注目を集めましたが、最近のGoのターゲットアーキテクチャは私たちの[SSA-based compiler back end](https://www.youtube.com/watch?v=uTMvKVma5ms)でよくサポートされており、素晴らしいコードが生成されるようになっています。私たちは、Amazon、ARM、Atos、IBM、Intel、MIPSのエンジニアを含む多数のコントリビューターに助けられてきました。

Goは初期状態で最小限の作業を行うだけで、これらすべてのシステムに対するクロスコンパイルをサポートしています。たとえば、32-bitのx86ベースのWindows向けのアプリを64-bit Linuxシステム上でビルドするには、次のコマンドを実行するだけで行えます。

```shell
GOARCH=386 GOOS=windows go build myapp  # writes myapp.exe
```

去年、複数のメジャーなベンダーがサーバー、ラップトップ、開発用マシン向けの新しいARM64ハードウェアを発表しました。Goはこうした状況に対して良いポジションにいました。現在まで、GoはARM64のLinuxサーバーやARM64のAndroidとiOSデバイス上のモバイルアプリで、Docker、Kubernetes、その他のGoエコシステムのプログラムを支えてきました。

この夏にAppleがMacのApple Siliconへの移行を発表して以来、Goと幅広いGoエコシステムがRosetta 2上のGo x86バイナリとネイティブのGo ARM64バイナリでの動作を保証できるように、AppleとGoogleは協力して作業してきました。今週のはじめに、最初のGo 1.16 betaをリリースしました。これには、M1チップを使用しているMacに対するネイティブのサポートが含まれています。Go 1.16 betaは、M1 Macとその他のすべてのシステムで[Go download page](https://golang.org/dl/#go1.16beta1)からダウンロードして試すことができます。(もちろん、こればbetaリリースなので、すべてのbetaと同様にまだ明らかになっていないバグが含まれているはずです。何らかの問題を見つけたときは、ぜひ[golang.org/issue/new](https://golang.org/issue/new)で報告してください。)

2つの環境の差異をなくすために、ローカルの開発を本番環境と同一のアーキテクチャで行うのは常によいことです。ARM64の本番環境にデプロイする場合、GoではARM64 LinuxおよびMacのシステムで開発を行うことも簡単です。しかしもちろん、x86システムで作業してARMにデプロイする場合でも、Windowsで開発してLinuxにデプロイする場合でも、あるいはそれ以外の組み合わせでも、1つのシステムで作業して別のシステム向けにクロスコンパイルするのはいつになく簡単になっています。

私たちがサポートを追加しようとしている次の目標は、ARM64のWindows 10システムです。もしあなたが専門知識を持っていて支援したい場合は、[golang.org/issue/36439](https://github.com/golang/go/issues/36439)で作業を調整してます。
