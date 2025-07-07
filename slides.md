---
title: "Nix Talk"
author: "Scott Windsor"
institute: "Devops PDX"
topic: "Nix"
theme: "Frankfurt"
colortheme: "beaver"
fonttheme: "professionalfonts"
mainfont: "Hack Nerd Font"
fontsize: 12pt
urlcolor: aqua
linkstyle: bold
aspectratio: 169
#titlegraphic: img/aleph0.png
#logo: img/aleph0-small.png
date:
lang: en-US
section-titles: false
toc: true
---

# Goals & Expectations

## Goals
- Beginner-friendly intro to nix
- Introduce concepts and language
- Get you excited about nix!

## Expectations
- Familiarity with command line & shell
- Understand at least one programming language like `javascript`


# Background

# The Quest for Reproducible Development Environments
 
# How nix is different
 
```bash
$ nix-shell -p curl
these 9 paths will be fetched (0.99 MiB download, 4.14 MiB unpacked):
  /nix/store/9v2s5rbf6pb77vhagihl7dicpqkg3614-c-ares-1.34.5
  /nix/store/wznrhnlrvamvihizpnizjfh5hs55z98n-curl-8.14.1-dev
  /nix/store/48wm9h7wf8ds4wkwgzzcqfrp7l722dm8-krb5-1.21.3-dev
  /nix/store/i1j8dzchkv1p59bqzrr15585s8s4zvx0-libev-4.33
  /nix/store/kss6l466kl66x2bqzy9rv7nz4pjgc55c-libidn2-2.3.8-bin
  /nix/store/9j67k582x3vgcijfiyralx5bj1b33gdg-libidn2-2.3.8-dev
  /nix/store/y37r7yjyvnzzd648lpdgflynfj55hpns-libpsl-0.21.5-dev
  /nix/store/rq4pnjcjrkic79kxc2fq0g7hp78s8ypv-nghttp2-1.65.0
  /nix/store/9pn6y4zlszr9w26rg2h52l3sd0wvzjvd-nghttp2-1.65.0-dev
copying path '/nix/store/48wm9h7wf8ds4wkwgzzcqfrp7l722dm8-krb5-1.21.3-dev' from 'https://cache.nixos.org'...
copying path '/nix/store/9v2s5rbf6pb77vhagihl7dicpqkg3614-c-ares-1.34.5' from 'https://cache.nixos.org'...
copying path '/nix/store/y37r7yjyvnzzd648lpdgflynfj55hpns-libpsl-0.21.5-dev' from 'https://cache.nixos.org'...
copying path '/nix/store/kss6l466kl66x2bqzy9rv7nz4pjgc55c-libidn2-2.3.8-bin' from 'https://cache.nixos.org'...
copying path '/nix/store/i1j8dzchkv1p59bqzrr15585s8s4zvx0-libev-4.33' from 'https://cache.nixos.org'...
copying path '/nix/store/9j67k582x3vgcijfiyralx5bj1b33gdg-libidn2-2.3.8-dev' from 'https://cache.nixos.org'...
copying path '/nix/store/rq4pnjcjrkic79kxc2fq0g7hp78s8ypv-nghttp2-1.65.0' from 'https://cache.nixos.org'...
copying path '/nix/store/9pn6y4zlszr9w26rg2h52l3sd0wvzjvd-nghttp2-1.65.0-dev' from 'https://cache.nixos.org'...
copying path '/nix/store/wznrhnlrvamvihizpnizjfh5hs55z98n-curl-8.14.1-dev' from 'https://cache.nixos.org'...
```

# How nix is different

```bash
[nix-shell:~/workspace/nix-talk]$ curl --version
curl 8.14.1 (x86_64-pc-linux-gnu) libcurl/8.14.1 OpenSSL/3.4.1 zlib/1.3.1 brotli/1.1.0 zstd/1.5.7 libidn2/2.3.8 libpsl/0.21.5 libssh2/1.11.1 nghttp2/1.65.0
Release-Date: 2025-06-04
Protocols: dict file ftp ftps gopher gophers http https imap imaps ipfs ipns mqtt pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp
Features: alt-svc AsynchDNS brotli GSS-API HSTS HTTP2 HTTPS-proxy IDN IPv6 Kerberos Largefile libz NTLM PSL SPNEGO SSL threadsafe TLS-SRP UnixSockets zstd

[nix-shell:~/workspace/nix-talk]$ which curl
/nix/store/wq4mwdypl1wmlhyrr69wggv8jdn2h9j9-curl-8.14.1-bin/bin/curl
```

# How nix is different

```bash
[nix-shell:~/workspace/nix-talk]$ ldd $(which curl)
        linux-vdso.so.1 (0x00007f0e95cfa000)
        libcurl.so.4 => /nix/store/frlckg2m2sf0gs8g5pqkryddbpy6qcz1-curl-8.14.1/lib/libcurl.so.4 (0x00007f0e95c12000)
        libnghttp2.so.14 => /nix/store/gwwbjkdd3rghq7x74561agq08f4jmh7p-nghttp2-1.65.0-lib/lib/libnghttp2.so.14 (0x00007f0e95be3000)
        libidn2.so.0 => /nix/store/ncdwsrgq6n6161l433m4x34057zq0hhf-libidn2-2.3.8/lib/libidn2.so.0 (0x00007f0e95bb2000)
        libssh2.so.1 => /nix/store/y6w3rwlym1mlpcysn6l7r5vbdmf9irf1-libssh2-1.11.1/lib/libssh2.so.1 (0x00007f0e95b67000)
        libpsl.so.5 => /nix/store/31fknicrbimbw6ivnxly9pdabsqqglk5-libpsl-0.21.5/lib/libpsl.so.5 (0x00007f0e95b53000)
        libssl.so.3 => /nix/store/byx7ahs386pskh8d5sdkrkpscfz9yyjp-openssl-3.4.1/lib/libssl.so.3 (0x00007f0e95a47000)
        libcrypto.so.3 => /nix/store/byx7ahs386pskh8d5sdkrkpscfz9yyjp-openssl-3.4.1/lib/libcrypto.so.3 (0x00007f0e95400000)
        libgssapi_krb5.so.2 => /nix/store/ppxfllzvl2b03x4ahqkyf6v6hiqf0hix-krb5-1.21.3-lib/lib/libgssapi_krb5.so.2 (0x00007f0e959f1000)
        libzstd.so.1 => /nix/store/and18rawgmwws8l2favbjr5wm31jnr4a-zstd-1.5.7/lib/libzstd.so.1 (0x00007f0e95327000)
        libbrotlidec.so.1 => /nix/store/czrad292gq5adw7kjj0z71gkw48mnmim-brotli-1.1.0-lib/lib/libbrotlidec.so.1 (0x00007f0e959e0000)
        libz.so.1 => /nix/store/vx438ll7xvv9q5ns8mqpphsg2dxg9yi9-zlib-1.3.1/lib/libz.so.1 (0x00007f0e959c2000)
        libc.so.6 => /nix/store/q4wq65gl3r8fy746v9bbwgx4gzn0r2kl-glibc-2.40-66/lib/libc.so.6 (0x00007f0e95000000)
        libunistring.so.5 => /nix/store/vm18dxfa5v7y3linrg1x1q9wx41bkxwf-libunistring-1.3/lib/libunistring.so.5 (0x00007f0e94e15000)
        libdl.so.2 => /nix/store/q4wq65gl3r8fy746v9bbwgx4gzn0r2kl-glibc-2.40-66/lib/libdl.so.2 (0x00007f0e959bb000)
        libpthread.so.0 => /nix/store/q4wq65gl3r8fy746v9bbwgx4gzn0r2kl-glibc-2.40-66/lib/libpthread.so.0 (0x00007f0e959b6000)
        libkrb5.so.3 => /nix/store/ppxfllzvl2b03x4ahqkyf6v6hiqf0hix-krb5-1.21.3-lib/lib/libkrb5.so.3 (0x00007f0e9524d000)
        libk5crypto.so.3 => /nix/store/ppxfllzvl2b03x4ahqkyf6v6hiqf0hix-krb5-1.21.3-lib/lib/libk5crypto.so.3 (0x00007f0e9521d000)
        libcom_err.so.3 => /nix/store/ppxfllzvl2b03x4ahqkyf6v6hiqf0hix-krb5-1.21.3-lib/lib/libcom_err.so.3 (0x00007f0e959ad000)
        libkrb5support.so.0 => /nix/store/ppxfllzvl2b03x4ahqkyf6v6hiqf0hix-krb5-1.21.3-lib/lib/libkrb5support.so.0 (0x00007f0e9520f000)
        libkeyutils.so.1 => /nix/store/6k8218bcmnknl7vq07vmm33b33i35586-keyutils-1.6.3-lib/lib/libkeyutils.so.1 (0x00007f0e94e0e000)
        libresolv.so.2 => /nix/store/q4wq65gl3r8fy746v9bbwgx4gzn0r2kl-glibc-2.40-66/lib/libresolv.so.2 (0x00007f0e94dfb000)
        libm.so.6 => /nix/store/q4wq65gl3r8fy746v9bbwgx4gzn0r2kl-glibc-2.40-66/lib/libm.so.6 (0x00007f0e94d13000)
        libbrotlicommon.so.1 => /nix/store/czrad292gq5adw7kjj0z71gkw48mnmim-brotli-1.1.0-lib/lib/libbrotlicommon.so.1 (0x00007f0e94cf0000)
        /nix/store/q4wq65gl3r8fy746v9bbwgx4gzn0r2kl-glibc-2.40-66/lib/ld-linux-x86-64.so.2 => /nix/store/q4wq65gl3r8fy746v9bbwgx4gzn0r2kl-glibc-2.40-66/lib64/ld-linux-x86-64.so.2 (0x00007f0e95cfc000)
```


# How nix is different

```bash
[nix-shell:~/workspace/nix-talk]$ exit 
exit
```

# How nix is different

```bash
[nix-shell:~]$ otool -L $(which curl)
/nix/store/bblr8ccnd4baxm4cf7g1igfz6ya8v93m-curl-8.14.1-bin/bin/curl:
        /nix/store/6l3i3d58xr1r4qv49v1ln8wf309sb15x-curl-8.14.1/lib/libcurl.4.dylib (compatibility version 13.0.0, current version 13.0.0)
        /nix/store/jkdx2fgyj2lhma8xydrp6xkqgv13a00g-nghttp2-1.65.0-lib/lib/libnghttp2.14.dylib (compatibility version 43.0.0, current version 43.4.0)
        /nix/store/8jfck34h4ayxg41lylz1aayjjjmy2qhw-libidn2-2.3.8/lib/libidn2.0.dylib (compatibility version 5.0.0, current version 5.0.0)
        /nix/store/4kk9xgcdga33k9h371p81svlam1aqa07-libssh2-1.11.1/lib/libssh2.1.dylib (compatibility version 2.0.0, current version 2.1.0)
        /nix/store/lvg9zfb2ig76821dmmpcdlb9xd6md1g5-libpsl-0.21.5/lib/libpsl.5.dylib (compatibility version 9.0.0, current version 9.5.0)
        /nix/store/7fqm5r0kdy21fdblcl1x4zm63wl12bjj-openssl-3.4.1/lib/libssl.3.dylib (compatibility version 3.0.0, current version 3.0.0)
        /nix/store/7fqm5r0kdy21fdblcl1x4zm63wl12bjj-openssl-3.4.1/lib/libcrypto.3.dylib (compatibility version 3.0.0, current version 3.0.0)
        /nix/store/xvrbzp3i5s00paykwcrf032bnddvf4fa-krb5-1.21.3-lib/lib/libgssapi_krb5.2.2.dylib (compatibility version 2.0.0, current version 2.2.0)
        /nix/store/ml7rlz2qfk7dpkg02af2gx7x97wzckcg-libresolv-83/lib/libresolv.9.dylib (compatibility version 1.0.0, current version 1.0.0)
        /nix/store/jy938j9d6pnrwwbs3s16mrxnsikj564k-zstd-1.5.7/lib/libzstd.1.5.7.dylib (compatibility version 1.0.0, current version 1.5.7)
        /nix/store/0xc8g1l0wxzipdfwqpj5ax5nzjj751b1-brotli-1.1.0-lib/lib/libbrotlidec.1.dylib (compatibility version 1.0.0, current version 1.1.0)
        /nix/store/fr590df7m2v4521ybwa4k8hddwprf01y-zlib-1.3.1/lib/libz.dylib (compatibility version 1.0.0, current version 1.3.1)
        /System/Library/Frameworks/SystemConfiguration.framework/Versions/A/SystemConfiguration (compatibility version 1.0.0, current version 1109.101.1)
        /System/Library/Frameworks/CoreServices.framework/Versions/A/CoreServices (compatibility version 1.0.0, current version 1122.33.0)
        /System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation (compatibility version 150.0.0, current version 1775.118.101)
        /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1292.100.5)
```

# First steps - installing

```bash
$ curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
```

# Your first environment

```bash
$ mkdir -p ~/workspace/nix-firs-steps
$ cd ~/workspace/nix-first-steps
$ git init
$ nix flake init templates#utils-generic
```

# Your first environment

`flake.nix`:


```nix
{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
        ];
      };
    }
  );
}
```

# Your first environment
`.envrc`:


```bash
use flake
```


# Nix the language

```nix
# Text that follows a `#` is a comment!
```

# Nix the language

```nix
# This is a string
"foo"
```

# Nix the language

```nix
# This is a multi-line string
''I'm a mult-line
string
''
```

# Nix the language

```nix
# This is a number
5
```

# Nix the language

```nix
# This is a list of numbers and strings
[ 1 2 "foo" ]
```

# Nix the language

```nix
# This is an empty "attribute set", which is also like a dictory or hash in other languages.
{}
```

# Nix the language

```nix
# attribute sets can assign attributes
{
  foo = "bar";
  baz = "buzz";
}
```

# Nix the language

```nix
# You can make nested attribute sets
{
  foo = {
    bar = "baz";
  };
}
```

# Nix the language

```nix
# Or assign them with a "." for shorthand
{ foo.bar = "baz"; }
```

# Nix the language

```nix
# This is our inputs example
{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
}
```

# Nix the language

```nix
# a `:` denoates a function with arguments on left and function body on the right
x: x + 1
```

# Nix the language

```nix
# You can call a function by applying an argument, but you may need to wrap in parentheis
(x: x + 1) 2
```

# Nix the language

```nix
# Most of the time you will see attributes as the function arguments
{ a, b }: a + b
```

# Nix the language

```nix
# When calling this you pass an attribute set
({ a, b }: a + b) {
  a = 2;
  b = 3;
}
```

# Nix the language

```nix
# Functions can also be `curried`
a: b: a + b
```

# Nix the language

```nix
# Again, using parenthsis to apply
(a: b: a + b) 2 3
```

# Nix the language

```nix
# Again, using parenthsis to apply
(a: b: a + b) 2 3
```

# Nix the language

```nix
# Now we can undertand the output line a bit better (omitting the `system` body for now)...
{
  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (system: { });
}
```

# Nix the language

```nix
# `let` blocks allow you to assign values you can use inside an `in` block
let
  a = 10;
in
{
  x = a;
}
```

# Nix the language

```nix
# Sometimes you might want to refer to interpolated values for attribute keys
# We can use `${}` for this
let
  a = "x";
in
{
  ${a} = 10;
}
```

# Nix the language

```nix
# Additionally, assigning a value to it's name is so common that there's a shorthand with `inherit`
let
  a = 10;
  b = 12;
  c = 5;
in
{
  a = a;
  b = b;
  c = c;
}
```

# Nix the language

```nix
# Additionally, assigning a value to it's name is so common that there's a shorthand with `inherit`
let
  a = 10;
  b = 12;
  c = 5;
in
{
  inherit a b c;
}

```

# Nix the language

```nix
# This is how `${system}` being used in our flake. Here's smaller example that applies both
# functions.
(
  system:
  { nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages.${system};
  in
  pkgs
)
  "linux"
  { nixpkgs.legacyPackages.linux = "awesome"; }
```

# Nix the language

```nix
# We have one last thing to learn before we understand all of our flake!
# You can do it!
```

# Nix the language

```nix
# Sometimes repeating keys can get a bit cumbersome
let
  x = {
    a = 1;
    b = 3;
    c = 4;
  };
in
[
  x.a
  x.b
  x.c
]
```

# Nix the language

```nix
# We can use `with` to automaticly scope all of the attributes in x
let
  x = {
    a = 1;
    b = 3;
    c = 4;
  };
in
with x;
[
  a
  b
  c
]
```

# Nix the language

```nix
# You did it! Great job!
```

