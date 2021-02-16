---
title: ED25519のGPGキーを生成してコミットに署名する
date: 2020-05-05T20:00:00+09:00
tags: [gpg, git, github]
toc: yes
aliases:
  - generate-and-sign-with-ed15519-gpg-key
---

GnuPGでED25519のGPGキーを生成し、Gitのコミットに署名を行います。そして、GitHubに生成した鍵を登録することで、署名が検証されることを確認します。

<!--more-->

## Generate key

まずは鍵を生成します。

```shell
> gpg --expert --full-gen-key
gpg (GnuPG) 2.2.20; Copyright (C) 2020 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
   (9) ECC and ECC
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
  (13) Existing key
  (14) Existing key from card
Your selection? 11

Possible actions for a ECDSA/EdDSA key: Sign Certify Authenticate
Current allowed actions: Sign Certify

   (S) Toggle the sign capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection?
Please select which elliptic curve you want:
   (1) Curve 25519
   (3) NIST P-256
   (4) NIST P-384
   (5) NIST P-521
   (6) Brainpool P-256
   (7) Brainpool P-384
   (8) Brainpool P-512
   (9) secp256k1
Your selection? 1
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0)
Key does not expire at all
Is this correct? (y/N) y

GnuPG needs to construct a user ID to identify your key.

Real name: TAKAHASHI Shuuji
Email address: shuuji3@gmail.com
Comment:
You selected this USER-ID:
    "TAKAHASHI Shuuji <shuuji3@gmail.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? o
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
gpg: key FC8A43AFCFBCC836 marked as ultimately trusted
gpg: revocation certificate stored as '/Users/shuuji/.gnupg/openpgp-revocs.d/21CD54006A9FD72AAB25DC82FC8A43AFCFBCC836.rev'
public and secret key created and signed.

pub   ed25519 2020-05-05 [SC]
      21CD54006A9FD72AAB25DC82FC8A43AFCFBCC836
uid                      TAKAHASHI Shuuji <shuuji3@gmail.com>
```

## Add subkeys

生成した鍵に対して、署名用と認証用の2つのサブキーを追加します。生成された鍵の指紋`21CD54006A9FD72AAB25DC82FC8A43AFCFBCC836`を指定して、`--edit-key`を行います。

```shell
> gpg --expert --edit-key 21CD54006A9FD72AAB25DC82FC8A43AFCFBCC836
gpg (GnuPG) 2.2.20; Copyright (C) 2020 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

sec  ed25519/FC8A43AFCFBCC836
     created: 2020-05-05  expires: never       usage: SC
     trust: ultimate      validity: ultimate
[ultimate] (1). TAKAHASHI Shuuji <shuuji3@gmail.com>

gpg> addkey
Please select what kind of key you want:
   (3) DSA (sign only)
   (4) RSA (sign only)
   (5) Elgamal (encrypt only)
   (6) RSA (encrypt only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
  (12) ECC (encrypt only)
  (13) Existing key
  (14) Existing key from card
Your selection? 11

Possible actions for a ECDSA/EdDSA key: Sign Authenticate
Current allowed actions: Sign

   (S) Toggle the sign capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection?
Please select which elliptic curve you want:
   (1) Curve 25519
   (3) NIST P-256
   (4) NIST P-384
   (5) NIST P-521
   (6) Brainpool P-256
   (7) Brainpool P-384
   (8) Brainpool P-512
   (9) secp256k1
Your selection? 1
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0)
Key does not expire at all
Is this correct? (y/N) y
Really create? (y/N) y
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

sec  ed25519/FC8A43AFCFBCC836
     created: 2020-05-05  expires: never       usage: SC
     trust: ultimate      validity: ultimate
ssb  ed25519/6FA31977C6C288BB
     created: 2020-05-05  expires: never       usage: S
[ultimate] (1). TAKAHASHI Shuuji <shuuji3@gmail.com>

gpg> addkey
Please select what kind of key you want:
   (3) DSA (sign only)
   (4) RSA (sign only)
   (5) Elgamal (encrypt only)
   (6) RSA (encrypt only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
  (12) ECC (encrypt only)
  (13) Existing key
  (14) Existing key from card
Your selection? 11

Possible actions for a ECDSA/EdDSA key: Sign Authenticate
Current allowed actions: Sign

   (S) Toggle the sign capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? s

Possible actions for a ECDSA/EdDSA key: Sign Authenticate
Current allowed actions:

   (S) Toggle the sign capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? a

Possible actions for a ECDSA/EdDSA key: Sign Authenticate
Current allowed actions: Authenticate

   (S) Toggle the sign capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? q
Please select which elliptic curve you want:
   (1) Curve 25519
   (3) NIST P-256
   (4) NIST P-384
   (5) NIST P-521
   (6) Brainpool P-256
   (7) Brainpool P-384
   (8) Brainpool P-512
   (9) secp256k1
Your selection? q
Invalid selection.
Your selection? 1
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0)
Key does not expire at all
Is this correct? (y/N) y
Really create? (y/N) y
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

sec  ed25519/FC8A43AFCFBCC836
     created: 2020-05-05  expires: never       usage: SC
     trust: ultimate      validity: ultimate
ssb  ed25519/6FA31977C6C288BB
     created: 2020-05-05  expires: never       usage: S
ssb  ed25519/D1FB45BFF487ED4C
     created: 2020-05-05  expires: never       usage: A
[ultimate] (1). TAKAHASHI Shuuji <shuuji3@gmail.com>

gpg> save
```

最後に`save`コマンドで保存しないと、結果が失われてしまうので注意します。サブキーが登録されたことを確認します。

```shell
> gpg --list-secret-keys --keyid-format LONG
/Users/shuuji/.gnupg/pubring.kbx
--------------------------------
sec   ed25519/FC8A43AFCFBCC836 2020-05-05 [SC]
      21CD54006A9FD72AAB25DC82FC8A43AFCFBCC836
uid                 [ultimate] TAKAHASHI Shuuji <shuuji3@gmail.com>
ssb   ed25519/6FA31977C6C288BB 2020-05-05 [S]
ssb   ed25519/D1FB45BFF487ED4C 2020-05-05 [A]
```

## Export public key to GitHub

GitHubでCommitの署名をVerifyしてもらうためには、公開鍵をexportmして、GitHubに登録する必要があります。

まず、鍵をexportします。

```shell
> gpg --export --armor 21CD54006A9FD72AAB25DC82FC8A43AFCFBCC836
-----BEGIN PGP PUBLIC KEY BLOCK-----

(...)

-----END PGP PUBLIC KEY BLOCK-----

```

GitHubの設定画面の[SSH and GPG keys](https://github.com/settings/keys)の「New GPG key」ボタンをクリックして、出力された鍵をコピー＆ペーストして登録します。

## Commit with the signature

コミットに署名するようにgitが設定されていることを確認します。

```shell
> git config --global -l | egrep '(key|gpg)'
user.signingkey=FC8A43AFCFBCC836
commit.gpgsign=true
gpg.program=gpg2
```

コミットします。

```shell
> git add .
> git commit -m 'Initial commit.'
> git push
```

## Confirm the commit signed

`git log`サブコマンドに`--show-signature`オプションを指定すると、当該コミットの署名の情報が確認できます。

```shell script
> git log --show-signature
commit 9c8a8a64d94c665b6da962cfba6194ea36f355f9 (HEAD -> master, origin/master)
gpg: Signature made 火  5/ 5 19:34:33 2020 JST
gpg:                using EDDSA key 21CD54006A9FD72AAB25DC82FC8A43AFCFBCC836
gpg: Good signature from "TAKAHASHI Shuuji <shuuji3@gmail.com>" [ultimate]
Author: TAKAHASHI Shuuji <shuuji3@gmail.com>
Date:   Tue May 5 19:34:33 2020 +0900

    Initial commit.
```

## GitHub verifies the commit 

コミットに正しく署名されていれば、以下のようにリポジトリのコミット一覧で「Verified」バッジが表示されます。

![コミット一覧の「Verified」バッジ](images/github-commit-verified-signature.png)

## Reference

- [Creating newer ECC keys for GnuPG](https://www.gniibe.org/memo/software/gpg/keygen-25519.html)
  - ED25519のGPGキーの作り方が書かれている。

- [Git - Signing Your Work](https://git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work)
  - gitコマンドの署名に関する詳しい説明が書かれている。

- [Managing commit signature verification - GitHub Help](https://help.github.com/github/authenticating-to-github/managing-commit-signature-verification)
  - コミットの署名の検証について書かれたGitHubのヘルプページ。