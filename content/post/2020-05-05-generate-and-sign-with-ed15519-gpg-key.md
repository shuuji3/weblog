---
title: macOSでEd25519のGPGキーを生成してコミットに署名する
date: 2020-05-05T20:00:00+09:00
tags: [gpg, git, github]
toc: yes
aliases:
  - generate-and-sign-with-ed15519-gpg-key
---

macOSでGnuPGでEd25519のGPGキーを生成し、Gitのコミットに署名を行います。そして、GitHubに生成した鍵を登録することで、署名が検証されることを確認します。

<!--more-->

Updated: 2022-12-04

## Check GPG version

Homebrewでインストールしたgpg (GnuPG) 2.3.8を使用します。

```shell
gpg --version
gpg (GnuPG) 2.3.8
libgcrypt 1.10.1
Copyright (C) 2021 Free Software Foundation, Inc.
License GNU GPL-3.0-or-later <https://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Home: /Users/shuuji3/.gnupg
Supported algorithms:
Pubkey: RSA, ELG, DSA, ECDH, ECDSA, EDDSA
Cipher: IDEA, 3DES, CAST5, BLOWFISH, AES, AES192, AES256, TWOFISH,
        CAMELLIA128, CAMELLIA192, CAMELLIA256
AEAD: EAX, OCB
Hash: SHA1, RIPEMD160, SHA256, SHA384, SHA512, SHA224
Compression: Uncompressed, ZIP, ZLIB, BZIP2
```

## Generate key

まずは鍵を生成します。GPG>=2.1.17 では、従来の `--gen-key` の代わりに `--full-generate-key` で作成します。

```shell
> gpg --full-generate-key
gpg (GnuPG) 2.3.8; Copyright (C) 2021 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
   (9) ECC (sign and encrypt) *default*
  (10) ECC (sign only)
  (14) Existing key from card
Your selection? 
Please select which elliptic curve you want:
   (1) Curve 25519 *default*
   (4) NIST P-384
   (6) Brainpool P-256
Your selection? 
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
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
gpg: revocation certificate stored as '/Users/shuuji3/.gnupg/openpgp-revocs.d/8291C416B80C0D07B3EC35B3F15C887632129F5E.rev'
public and secret key created and signed.

pub   ed25519 2022-12-04 [SC]
      8291C416B80C0D07B3EC35B3F15C887632129F5E
uid                      TAKAHASHI Shuuji <shuuji3@gmail.com>
sub   cv25519 2022-12-04 [E]
```

## Confirm key generation

GPGキーが登録されたことを確認します。

```shell
> gpg --list-secret-keys --keyid-format LONG
/Users/shuuji3/.gnupg/pubring.kbx
---------------------------------
sec   ed25519/F15C887632129F5E 2022-12-04 [SC]
      8291C416B80C0D07B3EC35B3F15C887632129F5E
uid                 [ultimate] TAKAHASHI Shuuji <shuuji3@gmail.com>
ssb   cv25519/427EF0BB512D5D98 2022-12-04 [E]
```

## Export public key to GitHub

GitHubでCommitの署名をVerifyしてもらうためには、公開鍵をexportして、GitHubに登録する必要があります。

まず、鍵をexportします。

```shell
> gpg --export --armor 8291C416B80C0D07B3EC35B3F15C887632129F5E
-----BEGIN PGP PUBLIC KEY BLOCK-----

(...)

-----END PGP PUBLIC KEY BLOCK-----

```

GitHubの設定画面の[SSH and GPG keys](https://github.com/settings/keys)の「New GPG key」ボタンをクリックして、出力された鍵をコピー＆ペーストして登録します。

## Commit with the signature

コミットに署名するようにgitを設定します。

```shell
git config --global user.signingkey 8291C416B80C0D07B3EC35B3F15C887632129F5E
git config --global commit.gpgsign true
git config --global gpg.program gpg
```

gitの設定を確認します。

```shell
> git config --global -l | egrep '(key|gpg)'
user.signingkey=8291C416B80C0D07B3EC35B3F15C887632129F5E
commit.gpgsign=true
gpg.program=gpg
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
commit e8aa843140456405031ffdfe56c60912f32f9579
gpg: Signature made 日 12/ 4 16:32:30 2022 JST
gpg:                using EDDSA key 8291C416B80C0D07B3EC35B3F15C887632129F5E
gpg: Good signature from "TAKAHASHI Shuuji <shuuji3@gmail.com>" [ultimate]
Author: TAKAHASHI Shuuji <shuuji3@gmail.com>
Date:   Sun Dec 4 16:32:30 2022 +0900

    feat: add git config commands
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
