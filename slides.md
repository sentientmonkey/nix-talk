---
title: "Let's go Nix"
author: "Scott Windsor"
institute: "Devops PDX"
topic: "Nix"
theme: "Frankfurt"
colortheme: "beaver"
fonttheme: "professionalfonts"
mainfont: "Hack Nerd Font"
fontsize: 12pt
urlcolor: blue
linkstyle: bold
aspectratio: 169
titlegraphic: img/nix-snowflake-rainbow.png
title-slide-attributes:
    data-background-image: img/nix-snowflake-rainbow.png
    data-background-size: contain
#logo: img/nix-snowflake-rainbow.png
date: 
lang: en-US
section-titles: false
toc: false
---

## Goals
- Beginner-friendly intro to nix
- Introduce concepts and language
- Get you excited about nix!


## Expectations
- Familiarity with command line & shell
- Understand at least one programming language like `javascript`

---

## Background

* Been a developer for > 20 years
* Dealt with countless build/run dependency issues
* Have worked heavily with modernizing legacy systems
* Usually work in small agile teams

::: notes
A bit about me and why I care so much about this problem.
One of my first programming jobs involved maintaining a solaris port of a windows app.
I learned quickly how hard portability really is, and that's been a theme in my career.
:::

# The Quest for Reproducible Development Environments

* automake (and porting)
* ports / macports
* anisible
* chef
* puppet
* Language managers: (rvm, virtualenv, nvm)
* Docker

::: notes
I've tried a lot of different tools to solve these problems. They've all had different drawbacks.
Either they don't really work for all environments, they rely on virtualisation, or they solve
the problem for one specific language.
:::

# But they always fall short

* System architecture woes (again!)
* Personal machine drift
* Working with multiple projects across teams

::: notes
These tools are great but they fall short of solving the problem all of the way.
Intel vs Apple Silicon
Mac vs Linux
DLL-hell?
Apps fighting over libxml or openssl issues?
Things going sideways after OS upgrade (or worse inconsistent between developers?)
:::

# How Nix is different

* Saves packages in isolation - `/nix/store`
* Builds packages with a functional language
* Allows you to link to system, user, or shell environments these packages

::: notes
nix has a very different way for solving this problem. It provides a store for content addressable
packages defined in a functional language. This allows you to build isolated packages that don't
have to be built over and over again.
:::

# First steps - installing

```bash
$ curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
```
::: notes
We're going to walk through setting everything up one step at a time.
I don't expect you to follow-along real-time, but you can go through these slides later if you want
The goal is to learn how these things work together.
We're using determinate nix here, which is a distribution of nix that makes it easier to use.
:::

 
# Creating shell with curl
 
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

::: notes
We can use `nix-shell` to create a temporary shell with curl installed.
Note the dependencies required and they they are content-addressable and versioned.
Also note that means they be downloaded.
:::

# Creating shell with curl

```bash
[nix-shell:~/workspace/nix-talk]$ curl --version
curl 8.14.1 (x86_64-pc-linux-gnu) libcurl/8.14.1 OpenSSL/3.4.1 zlib/1.3.1 brotli/1.1.0 zstd/1.5.7 libidn2/2.3.8 libpsl/0.21.5 libssh2/1.11.1 nghttp2/1.65.0
Release-Date: 2025-06-04
Protocols: dict file ftp ftps gopher gophers http https imap imaps ipfs ipns mqtt pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp
Features: alt-svc AsynchDNS brotli GSS-API HSTS HTTP2 HTTPS-proxy IDN IPv6 Kerberos Largefile libz NTLM PSL SPNEGO SSL threadsafe TLS-SRP UnixSockets zstd

[nix-shell:~/workspace/nix-talk]$ which curl
/nix/store/wq4mwdypl1wmlhyrr69wggv8jdn2h9j9-curl-8.14.1-bin/bin/curl
```

::: notes
We can see that it works for us and what features are enabled.
We can also see where this version is built in the store.
:::

# Showing runtime dependencies (Linux)

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

::: notes
Even better, we can use ldd to see what shared objects curl uses
:::

# Showing runtime dependencies (macOS)

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

::: notes
The macOS version works the same but looks a bit different.
Note here it relies on some macOS system dependencies.
:::

# Exiting the shell

```bash
[nix-shell:~/workspace/nix-talk]$ exit 
exit
```
::: notes
And we can exit the shell when we're done.
The package is still built (until garbage collected), but no longer in your shell.
:::


# Creating a flake

```bash
$ mkdir -p ~/workspace/nix-first-steps
$ cd ~/workspace/nix-first-steps
$ git init
$ nix flake init templates#utils-generic
```

::: notes
First let's make a git repo and initialize our "flake"
A flake is way to version-pin dependencies and structure nix environments
While it's "experimental", it's on by default for determinate and the preferred approach when using
nix for environments.
:::

# Loading the flake
`.envrc`:

```bash
use flake
```

::: notes
This adds an envrc that uses our flake. direnv, which we'll install later, will use this to 
load our dev shell.
:::


# Our first flake
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

::: notes
This is our flake configuration. Don't worry that you don't understand this yet, we'll learn 
what this all means soon. Let's go learn some of the language.
:::

# Nix the language

```bash
$ nix repl
Nix 2.29.0
Type :? for help.
nix-repl> 1 + 2
3
```

```bash
$ nix eval --expr '1+2'
3
```

```bash
$ echo "1+2" >> math.nix
$ nix eval -f math.nix
3
```
::: notes
Let's go over the nix language enough so we can understand that flake.nix code
If you'd like, you can follow along by launching the nix repl.
You can also use nix eval if you'd like
:::

# Comments

```nix
# Text that follows a `#` is a comment!
```

::: notes
Let's take some time to learn nix (the language)
You can follow along with 
Comments start with Hashes (Octothorpes)
:::

# Strings

```nix
# This is a string

"foo"
```

::: notes
Strings are double quoted
:::

# Multi-line Strings

```nix
# This is a multi-line string

''I'm a mult-line
string
''
```

::: notes
Multi-line are quoted with two single quotes
:::

# Numbers

```nix
# This is a number

5
```

::: notes
numbers look like numbers
:::

# Lists

```nix
# This is a list of numbers and strings

[ 1 2 "foo" ]
```
::: notes
Lists use brackets and do not seperate with commas.
Note that we can have different types of items in our lists.
:::

# Attribute Sets

```nix
# This is an empty "attribute set", which is also like a dictionary or hash in other languages.

{}
```
::: notes
Attribute-sets use curly braces and work like key-value storage objects.
This is like a dictionary, hash, or object (in javascript)
:::


# Attribute Sets

```nix
# attribute sets can assign attributes

{
  foo = "bar";
  baz = "buzz";
}
```

::: notes
Example of assigning attribute sets.
Note that the keys are not quoted, and that semi-colons end each assignment.
:::

# Attribute Sets

```nix
# You can make nested attribute sets

{
  foo = {
    bar = "baz";
  };
}
```
::: notes
Attribute sets can also hold attribute-sets
:::


# Attribute Sets

```nix
# Or assign them with a "." for shorthand

{ foo.bar = "baz"; }
```

::: notes
This is so common that there's a shorthand for assigning nested attributes.
:::

# Inputs Example

```nix
# This is our inputs example

{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
}
```

::: notes
Back to our inputs example. We can now understand this a bit more.
Do you see how you could re-write this
to be shorter?
:::

# Attribute Sets

```nix
# This is our inputs example, but shorter

{
  inputs.utils.url = "github:numtide/flake-utils";
}
```

::: notes
We won't actually change this, but here's the shorter example.
:::

# Functions

```nix
# a `:` denotes a function with arguments on left and function body on the right

x: x + 1
```

::: notes
functions use a colon to with a single parameter on the left and function body on the right
:::

# Functions

```nix
# You can call a function by applying an argument, but you may need to wrap in parenthesis

(x: x + 1) 2
```

::: notes
You can call a function applying an argument, but you may need
to wrap in parenthesis or nix will thing it's a part of the function body
:::

# Functions

```nix
# Most of the time you will see attributes as the function arguments

{ a, b }: a + b
```

::: notes
Most of the time you'll see attribute sets as function arguments
because it makes it easier to add new values to a call.
:::

# Functions

```nix
# When calling this you pass an attribute set

({ a, b }: a + b) {
  a = 2;
  b = 3;
}
```

::: notes
Calling a function with an attribute set works the same as it did with the single value
:::

# Currying

```nix
# Functions can also be `curried`

a: b: a + b
```

::: notes
Functions can also be curried!
This is a function that returns a function that adds two numbers.
:::

# Currying

```nix
# Again, using parenthesis to apply

(a: b: a + b) 2 3
```

::: notes
We can use parenthesis to apply here.
Note that if you left off the 3 here, you would have function 
that adds 2 to a number.
:::

# Currying

```nix
# Again, using parenthesis to apply

((a: b: a + b) 2) 3
```

::: notes
You can think of the application like this, but the extra
parenthesis aren't needed single every function takes one argument.
:::

# Outputs Example

```nix
# Now we can understand the output line a bit better (omitting the `system` body for now)...

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
::: notes
Looking back at our outputs line, we can see that outputs is a key for an attribute set
that returns a function with an attribute set of three values (self, nixpkgs, utils)
and that function calls into attribute set of utils lib eachDefaultSystem
which passes a function that takes system and returns an attribute set!
For making this slide shorter, the attribute set here is empty.
:::


# Let blocks

```nix
# `let` blocks allow you to assign values you can use inside an `in`attribute set 

let
  a = 10;
in
{
  x = a;
}
```
::: notes
Back to learning new things...
let allows you to assign values you can us in an in attribute set.
:::

# Interpolation

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
::: notes
Sometimes you may want to assign the value of what a is (i.e. x) as a key.
You can use interpolation of dollar curly braces for this.
:::

# System Example

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

::: notes
This is a function that takes system (linux), fetches the value assigned here (awesome), and
returns it. Evaluating all of this returns "awesome".
:::


# Inherit

```nix
# Assigning a value to it's name is so common that there's a shorthand with `inherit`

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
::: notes
You can assign multiple values. But there's a shortcut because this is so common.
:::

# Inherit

```nix
# Assigning a value to it's name is so common that there's a shorthand with `inherit`

let
  a = 10;
  b = 12;
  c = 5;
in
{
  inherit a b c;
}

```
::: notes
It's inherit
This returns an attribute set with a b and c as keys and the respective values as values.
:::

# Almost there!

```nix
# We have one last thing to learn before we understand all of our flake!
# You can do it!
```

# With

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
::: notes
Sometimes repeating keys can get cumbersome
:::


# With

```nix
# We can use `with` to automatically scope all of the attributes in x

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

::: notes
So there's a with keyword that lets us automatically scope keys.
This is the same as x.a, x.b, x.c
:::

# Nix Language complete

```nix
# You did it! Great job!
```

::: notes
We made it through everything we need to understand out flake.
:::

# Reviewing our flake

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
::: notes
Going back to our flake we can understand a bit better.
A flake returns an attribute set with a few defined attributes.
Inputs which define what a flake consumes and Outputs for what it produces.
Our inputs provide utils that get pulled from a github repo.
Our outputs use that utils flake to call eachDefaultSystem.
This function call makes it easier to define for all of our platforms (like arm64 macos,
intel linux, etc).
Within our ouputs we pick the right packages for our system architecture, then use that
to build our dev shell.
You'll notice that buildInputs is empty right now - this is where we'll put packages that we need.
:::

# Moving nixpkgs to stable

We add an input for nixpkgs to `25.05` (overriding default)

```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  utils.url = "github:numtide/flake-utils";
};
```
::: notes
But first, let's add in a new input, nixpkgs
While it was defaulting to "unstable", let's actually pin to the current "stable" version of nixpkgs
Stable vs. Unstable here really means minor patches vs rolling releases of features.
Again, our input url comes from github.
:::


# Adding packages to our devShell

These are for our rust app, but you can find more at [search.nixos.org](https://search.nixos.org)

```nix
devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          cargo
          rustc
          rust-analyzer
          rustfmt
        ];
      };
    }
```

::: notes
Let's add our packages to make a rust app. Here we add cargo, rustc, rust-analyzer, & rustfmt.
Note that these all come from pkgs, but we're using the with to make this easier to read.
:::

# Enter the devShell

We can use `nix develop` to get to the shell. `.#` is a reference to the current flake.

```bash
$ nix develop .#
(nix:nix-shell-env) bash-5.2$ rustc --version
rustc 1.86.0 (05f9846f8 2025-03-31) (built from a source tarball)
(nix:nix-shell-env) bash-5.2$ cargo --version
cargo 1.86.0 (adf9b6ad1 2025-02-28)
(nix:nix-shell-env) bash-5.2$ exit
exit
```
::: notes
Now that our flake is complete, we can use nix develop to enter a shell with our buildInputs
in our path.
Note the use of .# here - . means current source which is either the current working directory
or git root if in a git repository. The hash afterwards is to let us specify a name - in this
case we only have one devShell so it's assumed to be the default. Same for the reference
.# is the same as .#default
:::

# direnv makes this better

If you don't already have direnv installed, you can install to your profile via nix.

```bash
$ nix profile install nixpkgs#direnv
$ echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
$ source ~/.bashrc
```
::: notes
Let's make this easier with direnv. If you don't already have direnv installed, you
can use nix profile install to install it to your profile for your user.
:::


# direnv makes this better

Now the flake is evaluated when we enter the directory

```bash
$ direnv allow
direnv: loading ~/workspace/nix-first-steps/.envrc
direnv: using flake
warning: Git tree '/Users/scott/workspace/nix-first-steps' has uncommitted changes
direnv: export +AR +AS +CC +CONFIG_SHELL +CXX +DEVELOPER_DIR +HOST_PATH +IN_NIX_SHELL +LD +LD_DYLD_PATH +MACOSX_DEPLOYMENT_TARGET +NIX_APPLE_SDK_VERSION +NIX_BINTOOLS +NIX_BINTOOLS_WRAPPER_TARGET_HOST_arm64_apple_darwin +NIX_BUILD_CORES +NIX_BUILD_TOP +NIX_CC +NIX_CC_WRAPPER_TARGET_HOST_arm64_apple_darwin +NIX_CFLAGS_COMPILE +NIX_DONT_SET_RPATH +NIX_DONT_SET_RPATH_FOR_BUILD +NIX_ENFORCE_NO_NATIVE +NIX_HARDENING_ENABLE +NIX_IGNORE_LD_THROUGH_GCC +NIX_LDFLAGS +NIX_NO_SELF_RPATH +NIX_STORE +NM +OBJCOPY +OBJDUMP +PATH_LOCALE +RANLIB +SDKROOT +SIZE +SOURCE_DATE_EPOCH +STRINGS +STRIP +TEMP +TEMPDIR +TMP +ZERO_AR_DATE +__darwinAllowLocalNetworking +__impureHostDeps +__propagatedImpureHostDeps +__propagatedSandboxProfile +__sandboxProfile +__structuredAttrs +buildInputs +buildPhase +builder +cmakeFlags +configureFlags +depsBuildBuild +depsBuildBuildPropagated +depsBuildTarget +depsBuildTargetPropagated +depsHostHost +depsHostHostPropagated +depsTargetTarget +depsTargetTargetPropagated +doCheck +doInstallCheck +dontAddDisableDepTrack +mesonFlags +name +nativeBuildInputs +out +outputs +patches +phases +preferLocalBuild +propagatedBuildInputs +propagatedNativeBuildInputs +shell +shellHook +stdenv +strictDeps +system ~PATH ~TMPDIR ~XDG_DATA_DIRS
```

::: notes
Now when we direnv allow and go back to our project, it will evaluate our flake
(because of our envrc) and export all important variables for our devshell.
:::

# direnv makes this better

Now our packages are just in our path!

```bash
$ rustc --version
rustc 1.86.0 (05f9846f8 2025-03-31) (built from a source tarball)
```

::: notes
Now we just have our packages in our path
:::

# Building our app

Now that we have our environment, we can build our app.

```bash
$ cd ~/workspace/nix-first-steps
$ cargo new hello-nix
$ cd hello-nix
```

::: notes
We can build our rust app now with cargo
:::

# Building our app

open up `hello-nix/src/main.rs` and change to the following:
```rust
fn main() {
    println!("Hello from nix!");
}
```
::: notes
This is a pretty simple rust app for our demo purposes.
If you don't know rust, that's okay.
:::

# Building our app

We can make sure this builds, tests, and runs.

```bash
$ cargo build
   Compiling hello-nix v0.1.0 (/Users/scott/workspace/nix-first-steps/hello-nix)
     Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.77s

$ cargo test
   Compiling hello-nix v0.1.0 (/Users/scott/workspace/nix-first-steps/hello-nix)
     Finished `test` profile [unoptimized + debuginfo] target(s) in 0.11s
       Running unittests src/main.rs (target/debug/deps/hello_nix-c7e1c6d541507f78)

running 0 tests

test result: ok. 0 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 0.00s

$ cargo run
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.00s
     Running `target/debug/hello-nix`
Hello from nix!
```

::: notes
our build and tests (which don't exist yet), all work
:::

# Building with nix

Let's make a new file, `default.nix` and put it in the `hello-nix` directory.

```nix
{ pkgs ? import <nixpkgs> { } }:
pkgs.rustPlatform.buildRustPackage {
  pname = "hello-nix";
  version = "0.0.1";
  cargoLock.lockFile = ./Cargo.lock;
  src = pkgs.lib.cleanSource ./.;
}
```

::: notes
Now let's see if we can make our app as a nix package
This will let us have a reproducible build we could share with others.
There's some new syntax here, we haven't seen yet...
:::

# New syntax: ?

```nix
# The `?` allows us to have optional values in attribute sets. This comes in handy for optional
# arguments in functions.

{ foo ? "foo" }: foo
```

::: notes
? allows us to have optional values in an attribute set by providing a default.
This is really handy for functions
:::

# New syntax for nix

```nix
# you can either apply without that name set.

({ foo ? "foo" }: foo) {}
```

::: notes
We can apply it without "foo"
:::

# New syntax for nix

```nix
# or with it

({ foo ? "foo" }: foo) { foo = "bar"; }
```

::: notes
Or with it
:::

# New syntax for nix

```nix
# `import` is a special builtin function for loading code.
# `./filename` is path variable relative by current directory.
# We can use this to import our new `default.nix` file

import ./default.nix
```
::: notes
import is a special builtin function that loads code (like other languages)
./filename is a new type that we haven't seen before - it's a "file" variable
It's relative to the current directory and we can use it to pass to our import
:::

# New syntax for nix

```nix
# <nixpkgs> is a special value that resolves lookup paths for $NIX_PATH
# This can be used to dynamically load whichever location nix is set to
# That means that the argument to our function takes an attribute set with
# an options pkgs that defaults to the imported version of `nixpkgs` if passed in.

{ pkgs ? import <nixpkgs> { } }: {}
```

::: notes
<nixpkgs> is a special value that resolves from the NIX_PATH environment variable
The ? allows us to pass in our own pkgs or default to the current nixpkgs default
:::

# New syntax for nix

back to our `default.nix`
 
```nix
{ pkgs ? import <nixpkgs> { } }:
pkgs.rustPlatform.buildRustPackage {
  pname = "hello-nix";
  version = "0.0.1";
  cargoLock.lockFile = ./Cargo.lock;
  src = pkgs.lib.cleanSource ./.;
}
```

::: notes
Back to our default.nix, we can read the rest of this
We're building a function that takes in an optional pkgs, 
then using that to call the buildRustPackage function which
takes an attribute set including the package name, version, cargo lockfile
(loaded as a relative file), and the source code in the current directory imported as ./.
:::

# Building our package

We can use the `nix build` command to build

```bash
$ nix build -f default.nix
```

::: notes
Now we can build with nix build passing the file with a -f
:::

# Building our package

And see the results...

```bash
$ ls -la result
lrwxr-xr-x 1 scott staff 59 Jun 29 17:26 result -> /nix/store/rj2wf0vgsgbsadlad6nxssnb4lhqvjw1-hello-nix-0.0.1
$ ./result/bin/hello-nix
Hello from nix!
$ rm result
```
::: notes
When we build, you'll notice that a result symlink is created that points to our package
that was built. Note the content addressable hash, name, and version.
If any of these change, it builds to a new path.
Inside that package is our rust binary
We can rm the symlink when we are done
:::

# Adding package to our flake

back up to our `flake.nix`, we provide this as the `default` package
```bash
{
  devShell = pkgs.mkShell {
    # ...
  };
  packages.default = pkgs.callPackage ./hello-nix { inherit pkgs; }
}
```

::: notes
Now that we have our package, we can add to our flake.
In addition to our devshell, we're assigning a default package and calling hello-nix/default.nix
Note a few things here - ./hello-nix is again a path variable pointing to that directory.
Call package will look for a default.nix in that directory, but if we wanted a different name we
could be explicit. We also use inherit to pass along the version of pkgs from our flake, which
we remember is set to 25.05 nixpkgs.
:::

# Adding package to our flake

and rebuild it! Note the syntax again of `.#`

```bash
$ nix build .#
```
::: notes
Now we can use nix build with our flake reference. Again we are using .# to tell nix build to look
at packages.default
:::

# Error with build

```bash
warning: Git tree '/Users/scott/workspace/nix-first-steps' has uncommitted changes
error:
 … while evaluating a branch condition
   at «github:nixos/nixpkgs/a676066377a2fe7457369dd37c31fd2263b662f4?narHash=sha256-zW/OFnotiz/ndPFdebpo3X0CrbVNf22n4DjN2vxlb58%3D»/nix/store/i56fkj8igf4wdvm6dglcj3lzi2j1r7pq-source/lib/customisation.nix:305:5:
    304|     in
    305|     if missingArgs == { } then
       |     ^
    306|       makeOverridable f allArgs

 … while calling the 'removeAttrs' builtin
   at «github:nixos/nixpkgs/a676066377a2fe7457369dd37c31fd2263b662f4?narHash=sha256-zW/OFnotiz/ndPFdebpo3X0CrbVNf22n4DjN2vxlb58%3D»/nix/store/i56fkj8igf4wdvm6dglcj3lzi2j1r7pq-source/lib/attrsets.nix:657:28:
    656|   */
    657|   filterAttrs = pred: set: removeAttrs set (filter (name: !pred name set.${name}) (attrNames set));
       |                            ^
    658|

 (stack trace truncated; use '--show-trace' to show the full, detailed trace)

  error: Path 'hello-nix' in the repository "/Users/scott/workspace/nix-first-steps" is not tracked by Git.

 To make it visible to Nix, run:

 git -C "/Users/scott/workspace/nix-first-steps" add "hello-nix"
```
::: notes
But we get an error!
This is a common gotcha with using a flakes vs our file directory. If you do have a git repo, you 
need to git add files so that the flake can access them.
:::

# Cleaning up git

```bash
$ echo "target" >> .gitignore
$ echo ".direnv" >> .gitignore
$ git add "hello-nix"
```
::: notes
So we git add things, but we add a few git ignores first
:::


# Build success

```bash
$ nix build .#
warning: Git tree '/Users/scott/workspace/nix-first-steps' has uncommitted changes
$ ls -l result
lrwxr-xr-x 1 scott staff 59 Jun 29 17:45 result -> /nix/store/yqw9zry7dsgyr692y18pb330xhwlrwr5-hello-nix-0.0.1
$ ./result/bin/hello-nix
Hello from nix!
$ rm result
```

::: notes
Now it works!
Just like before, it creates a symlink to our package.
You'll notice the content addressable hash here is actually different
It's because we're now using the nixpkgs 25.05 pinned in our flake lock vs unstable nixpkgs
Because the input is different, it's a new package
:::

# Portability of package

If we push this to github we could run this automatically!

```bash
$ nix run github:sentientmonkey/nix-first-steps
Hello from nix!
$ nix run .#
Hello from nix!
```
::: notes
If we did push our repo here to github, we could use nix run to invoke it directly
otherwise, we can just use .# to run the default package
:::

# Let's Build for Docker

Create a new file `hello-nix/build-docker.nix`

```nix
{
  pkgs ? import <nixpkgs> { }
}:

pkgs.dockerTools.buildImage {
  name = "hello-nix";
  tag = "0.0.1";
  config = {
    Cmd = [ "${pkgs.hello}/bin/hello" ];
  };
}
```
::: notes
Now let's try to build a docker image for our app.
We make a new file here for another package build. This time we're using buildImage instead of
buildRustPackage. This takes a name, tag, and command that we can use the "hello" package.
Note the interpolation here for the package.
:::

# Building and loading

```nix
$ docker load < $(nix build -f hello-nix/build-docker.nix --no-link --print-out-paths)
Loaded image: hello-nix:0.0.1
$ docker run hello-nix:0.0.1
Hello, World!
```
::: notes
We can now build and load this into docker.
Note that our build is making an OCI image (which only will built on linux, sorry!) and we use
--no-link to avoid the symlink and --print-out-paths to give us the zipped tarball to load
directly into docker.
Running it gives the default for the "hello" package.
:::


# Adding dockerImage to our flake

add to our top level `flake.nix`
```nix
packages.default = pkgs.callPackage ./hello-nix { inherit pkgs; }
packages.dockerImage = pkgs.callPackage ./hello-nix/build-docker.nix { inherit pkgs; }
```

::: notes
Like before, we can call this package in our flake. This time we name it dockerImage.
:::

# Run docker build with flake

```bash
$ git add hello-nix/build-docker.nix
$ docker load < $(nix build .#dockerImage --no-link --print-out-paths)
Loaded image: hello-nix:0.0.1
$ docker run hello-nix:0.0.1
Hello, World!
```
::: notes
We remember to git add, and now we can build with .#dockerImage instead of the file path
But this isn't our app yet, it's just the default hello package. Let's fix that now.
:::

# Small refactor in our flake

```nix
let
  pkgs = nixpkgs.legacyPackages.${system};
  helloNix = pkgs.callPackage ./hello-nix { inherit pkgs; };
in
{
  # ...
  packages.default = helloNix;
  packages.dockerImage = pkgs.callPackage ./hello-nix/build-docker.nix { inherit pkgs; };
}
```
::: notes
First, let's do a small refactor to make things easier.
We can assign our hello nix build to an attribute in our let block,
and then use it to assign to our default image.
:::

# Small refactor to our flake

```nix
packages.dockerImage = pkgs.callPackage ./hello-nix/build-docker.nix { inherit pkgs helloNix; };
```

::: notes
Now we can pass that package along to our call to our build-docker.nix
:::

# Back to our build, we can use our package

```nix
{
  helloNix,
  pkgs ? import <nixpkgs> { },
}:

pkgs.dockerTools.buildImage {
  name = "hello-nix";
  tag = helloNix.version
  config = {
    Cmd = [ "${helloNix}/bin/hello-nix" ];
  };
}
```
::: notes
in our build, we add helloNix to our function parameter attributes, use our version to set the tag
and use our package for our command
:::

# Building again with our package now

```bash
$ docker load < $(nix build .#dockerImage --no-link --print-out-paths)
Loaded image: hello-nix:0.0.1
$ docker run hello-nix
Hello from nix!
```
::: notes
Now we get our hello nix app when we load and run with docker
:::

# Extending our docker image with bash

```nix
pkgs.dockerTools.buildImage {
  name = "hello-nix";
  tag = helloNix.version;

  copyToRoot = pkgs.buildEnv {
    name = "image-root";
    paths = with pkgs; [
      helloNix
      bashInteractive
      coreutils
    ];
    pathsToLink = [ "/bin" ];
  };
  config = {
    Cmd = [ "/bin/hello-nix" ];
  };
}
```
::: notes
Let's make this a bit more robust.
Let's say we want to provide more in our container, like having an interactive bash shell
and common linux utilities.
We move to using the buildEnv, which takes a lisst of packages, and a pathsToLink attribute which
will symlink anything in our packages' /bin directory into the root's /bin directory.
This lets us call /bin/hello-nix instead of our nix store path, but also puts bash and everything
else into bin as well.
:::


# Extending our docker image with bash

```bash
$ docker load < $(nix build .#dockerImage --no-link --print-out-paths)
Loaded image: hello-nix:0.0.1
$ docker run -it /bin/bash
bash-5.2#
```
::: notes
Now we have an interactive bash shell if we need it, or whatever other packages we need at runtime.
:::

# Adding runtime dependencies

Back to our `flake.nix`

```nix
devShell = pkgs.mkShell {
  buildInputs = with pkgs; [
    cargo
    rustc
    rust-analyzer
    rustfmt
    figlet
    lolcat
  ];
};
```
::: notes
Expanding on this further, let's assume we have additional package dependencies like figlet and
lolcat. If you're not familiar figlet turns text into ascii text, and lolcat colorizes text.
While figlet is written in c, lolcat is written in ruby. Normally this would mean having
to add an entire language into your dev environment, maybe even versioning. But nix can help us
here since they are defined as packages.
:::

# Testing package dependencies for development

```bash
$ cd hello-nix
$ cargo run | figlet | lolcat
    Finished `dev` profile [unoptimized + debuginfo] target(s) in 0.02s
     Running `target/debug/hello-nix`
 _   _      _ _          __                             _      _
| | | | ___| | | ___    / _|_ __ ___  _ __ ___    _ __ (_)_  _| |
| |_| |/ _ \ | |/ _ \  | |_| '__/ _ \| '_ ` _ \  | '_ \| \ \/ / |
|  _  |  __/ | | (_) | |  _| | | (_) | | | | | | | | | | |>  <|_|
|_| |_|\___|_|_|\___/  |_| |_|  \___/|_| |_| |_| |_| |_|_/_/\_(_)
```
::: notes
Once we direnv allow and our flake rebuilds, we can use these and we get a more fun output.
When we're happy with testing this, we can move to updating our rust program to run them
all together by default.
:::

# Using makeWrapper

```nix
pkgs.rustPlatform.buildRustPackage {
  # ...

  nativeBuildInputs = [ pkgs.makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/hello-nix \
      --prefix PATH : ${pkgs.lolcat}/bin \
      --prefix PATH : ${pkgs.figlet}/bin \
      --add-flags "| figlet | lolcat"
  '';
}
```
::: notes
We can use a nix builtin package called makeWrapper to help us
This package has a set of bash functions, including wrapProgram which allows us to re-wrap
a binary in a bash script with some extra settings.
In this case we want to add lolcat and figet to our PATH, and add flags every time our app is run.
We use | figlet | lolcat to always run hello-world with these arguments.
There are more options available that are just shown here.
:::

# Using makeWrapper

```bash
$ nix build .#
$ cat result/bin/hello-nix
#! /nix/store/xy4jjgw87sbgwylm5kn047d9gkbhsr9x-bash-5.2p37/bin/bash -e
PATH=${PATH:+':'$PATH':'}
PATH=${PATH/':''/nix/store/jjf7ym331wzp1jsyn05b7cscflk291bd-lolcat-100.0.1/bin'':'/':'}
PATH='/nix/store/jjf7ym331wzp1jsyn05b7cscflk291bd-lolcat-100.0.1/bin'$PATH
PATH=${PATH#':'}
PATH=${PATH%':'}
export PATH
PATH=${PATH:+':'$PATH':'}
PATH=${PATH/':''/nix/store/q00xb5g6hv24yc7r6k3r6jws226vw8rm-figlet-2.2.5/bin'':'/':'}
PATH='/nix/store/q00xb5g6hv24yc7r6k3r6jws226vw8rm-figlet-2.2.5/bin'$PATH
PATH=${PATH#':'}
PATH=${PATH%':'}
export PATH
exec "/nix/store/jpfbhrzd6wpm607w1llyl52bs3dm074w-hello-nix-0.0.1/bin/.hello-nix-unwrapped"  | figlet | lolcat "$@"
```
::: notes
If we build our app, we can see the bash it generates.
Note that it's using everything from the nix store, even bash!
:::

# Running our build

```bash
$ nix run .#
 _   _      _ _          __                             _      _
| | | | ___| | | ___    / _|_ __ ___  _ __ ___    _ __ (_)_  _| |
| |_| |/ _ \ | |/ _ \  | |_| '__/ _ \| '_ ` _ \  | '_ \| \ \/ / |
|  _  |  __/ | | (_) | |  _| | | (_) | | | | | | | | | | |>  <|_|
|_| |_|\___|_|_|\___/  |_| |_|  \___/|_| |_| |_| |_| |_|_/_/\_(_)

```
::: notes
Running our package now from our flake gives us the formatted hello
:::

# Running from docker

```bash
$ docker load < $(nix build .#dockerImage --no-link --print-out-paths)
Loaded image: hello-nix:0.0.1
$ docker run -it hello-nix:0.0.1
 _   _      _ _          __                             _      _
| | | | ___| | | ___    / _|_ __ ___  _ __ ___    _ __ (_)_  _| |
| |_| |/ _ \ | |/ _ \  | |_| '__/ _ \| '_ ` _ \  | '_ \| \ \/ / |
|  _  |  __/ | | (_) | |  _| | | (_) | | | | | | | | | | |>  <|_|
|_| |_|\___|_|_|\___/  |_| |_|  \___/|_| |_| |_| |_| |_|_/_/\_(_)

```
::: notes
And this automatically works in docker without any changes to our docker build
because we rely on our package build
:::

# Running the unwrapped version

```bash
$ docker run -it hello-nix:0.0.1 /bin/.hello-nix-wrapped
Hello from nix!
```
::: notes
The unwrapped version is still there if we ever need it
And that's it - a single environment that lets to develop, build, and distribute your app!
:::

# Take-aways and jumping off points

Now that you've gotten a quick tour of how nix can be helpful in building out your dev
environments, I encourage you to explore and learn more. 

Some jumping off points:

* [devenv](https://devenv.sh/) for pinning languages and adding services (i.e. postgres, redis)
* [dockertools](https://ryantm.github.io/nixpkgs/builders/images/dockertools/)  for building containers with nix
* [flakes](https://nixos.wiki/wiki/flakes) for more details about building flakes
* [nix create and debug packages](https://nixos.wiki/wiki/Nixpkgs/Create_and_debug_packages) to help build your own packages
* [search.nixos.org](https://search.nixos.org/packages) to explore packages
* [zero to nix](https://zero-to-nix.com/) to learn more about nix


I hope this inspires you to learn more and experiment!

::: notes
I know this was a very quick tour, but I hope this gives you an idea of what's possible and how
nix approaches this differently that what you may have used in the past.
There are just a few jumping off points for learning more that I've found helpful
:::

# Thank you!

## Repos with slides and code
* [sentientmonkey.github.io/nix-talk](https://sentientmonkey.github.io/nix-talk)
* [github/sentientmonkey/nix-talk](https://github.com/sentientmonkey/nix-talk)
* [github/sentientmonkey/nix-first-steps](https://github.com/sentientmonkey/nix-first-steps)
* [github/sentientmonkey/nix-config](https://github.com/sentientmonkey/nix-config)

## Contact info
* `_swindsor` on PDX DevOps Discord
* `swindsor` at gmail for email
* **sentientmonkey** on github

::: notes
Here's some of my contact info if you want to follow up!
A big thank you for PDX DevOps for hosting and letting me share!
A bit thank you to you for sticking through this!
:::
