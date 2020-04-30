---
title: "Go's Declaration Syntax - The Go Blog"
date: 2020-04-29T18:00:00+09:00
tags: [reading, golang]
toc: true
---

Go言語の構文のデザインについて説明している「Go's Declaration Syntax - The Go Blog」の読書メモです。

<!--more-->

## Source

[Go's Declaration Syntax - The Go Blog](https://blog.golang.org/declaration-syntax)

## Introduction

Goの型宣言が伝統的なCと違う理由を説明します。

## C syntax

Cでは、型宣言用の特別なキーワードは必要ありません。

```c
int x;
```

このコードは、`x`が`int`型を持つことを宣言しています。

```c
int *p;
int a[3];
```

このコードは、`int`が前にあるので、`int`へのポインタと、`int`の配列を宣言することになります。

Cの関数は伝統的には次のように宣言していました。

```c
int main(argc, argv)
  int argc;
  char *argv[];
{ /* ... */ }
```

`int`が前にあるので、`main(argc, argv)`は`int`を返す関数となります。

以上の宣言は型が単純であれば問題ありませんが、すぐに複雑になってしまいます。

```c
int (*fp)(int a, int b);
```

`(*fp)(a, b)`という表現を書くと、`int`を返す関数になるため、`fp`は関数ポインタになります。

```c
int (*fp)(int (*ff)(int x, int y), int b)
```

このようになると読むのが難しくなってきます。

```c
int main(int, char *[])
```

関数の宣言では変数が省略できるので、`main`はこのようにも宣言できます。

```c
int (*fp)(int (*)(int, int), int)
```

関数ポンンタから名前を取るとこのようになります。

```c
int (*(*fp)(int (*)(int, int), int))(int, int)
```

関数ポインタを返す型になると、`fp`の宣言であるように読むことすら困難です。

また、型名と宣言が同じであることの副作用として、キャストをカッコで括らなくてはならなくなっています。

```c
(int)M_PI
```

## Go syntax

C以外の言語では、このように型を変数名の後ろで宣言します。

```c
x: int
p: pointer to int
a: array[3] of int
```

こうすると、自然に左から右に読めるため、Goではさらに簡潔さを加えた次のような表現をします。

```go
x int
p *int
a [3]int
```

`[3]int`という型の表現と配列の使用方法は区別されます。

Goの`main`は実際には引数を取りませんが、次のように表現できます。

```go
func main(argc int, argv []string) int
```

Cとの違いは大きくはありませんが、次のように自然に読めます。

「function main takes an int and a slice of strings and returns an int.」

引数名を消すと、混乱がなくなることが明らかになります。

```go
func main(int, []string) int
```

左から右のスタイルのメリットは、型が複雑になってもうまく表現できることです。

```go
f func(func(int,int) int, int) int
```

関数を返す関数も同様です。

```go
f func(func(int,int) int, int) func(int, int) int
```

型と式の構文が区別されるため、Goではクロージャの定義と呼び出しが簡単になります。

```go
sum := func(a, b int) int { return a+b } (3, 4)
```

## Pointer

ポインタはルールの例外です。

```go
var a []int
x = a[1]
```

配列では、ブラケットは型の左に書き、式では右に書きます。

```go
var p *int
x = *p
```

慣習により、GoのポインタはCの表記を使い、配列のような逆表記は採用しません。

```go
var p *int
x = p*
```

と後置しないのは、積演算記号と衝突するからです。

```pascal
var p ^int
x = p^
```

Pascalのように`^`を使うべきだったかもしれません。

```go
[]int("hi")
```

と書くことはできますが、

```go
(*int)(nil)
```

のように`*`で始まる型はカッコで括らなければなりませんが、`*`を諦めていたらカッコが不要になるからです。

Goのポインタ構文はCに類似しているため、型と式の構文の曖昧さを完全に消すことができません。

それでも、全体としてGoの構文は、特に複雑になった時、Cよりも理解しやすいと信じています。

## Notes

Goの宣言は左から右に読むのに対して、Cの読み方は、David AndersonのClockwise/Spiral Ruleとして知られてきました。

##  Related articles

- [Two recent Go articles](https://blog.golang.org/two-recent-go-articles)
- [Two recent Go talks](https://blog.golang.org/two-recent-go-talks)
- [Go videos from Google I/O 2012](https://blog.golang.org/io2012-videos)

