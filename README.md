# Nix talk
Scott Windsor

DevOps PDX

# Goals for talk & expectations

The goal for this talk is to introduce you to how nix can be helpful in solving the problem of
providing _reproducible_ and _portable_ development environments. It's meant to be an approachable
for those unfamiliar with nix, but have a basic understanding of Unix systems and a comfort with
working with the command-line and shell. A knowledge of programming language will help with the
nix language portions - something like `javascript`, `ruby`, or `python` would be helpful given
the expression language, but isn't specifically required. I introduce just enough of the language
and understanding of nix to get through the setup here, but there's far more than I don't cover
here. All of the code & command-line examples given should work on any Unix capable of running
nix, but has only been tested on macOS and NixOS (Linux).

# Background

I started with computers at an early age with Apple ii, then moved on to IBM DOS machines. Eventually
I had my own computer from hand-me-down 286 parts. I got on BBSes and early internet, which opened
up a whole world of unfamiliar and interesting things. I was also pretty interesting in video games,
playing Nintendo and PC games.

I learned to program in College (Virginia Tech), starting with C, getting my Computer Science degree.
I also learned a fair a amount from running my own Linux servers and working with a
few different Unixes (Solaris, FreeBSD) and doing more web programming.

I graduated and moved to Seattle to come work for Amazon, and stayed there for a long time before
moving to smaller startups, getting acqui-hired back to Amazon, moving to AWS, then to Pivotal Labs,
and back to more startups.

Now I work for Mechanical Orchard as an Infrastructure Engineer. We work on modernizing mainframes,
which can involve a fair amount of challenging development setup for various tools and libraries
needed to work with those systems (like [x3270](https://x3270.bgp.nu/)). Most of my day-to-day involves a fair amount
of systems engineering, but also helping a lot of development teams with getting environments and
development tools set up.

An overall theme here is that I've tended to jump into working on things that might seem fairly
daunting, difficult, or complex. I love a puzzle and figuring out how things work. I'm a vim user
(since early in my career). I like having good tools and setting up systems to easy to use and
work on.

# The Quest for Reproducible Development Environments

A part of my experience has driven me towards ensuring that my development setup is consistent and
easy. Things I've tried in the past to help with this, to varying degrees of success...

* dotfiles repos
* vim-config
* chef
* puppet
* macports
* Homebrew
* Ansible
* Docker compose

All of these have had different trade-offs and problems. Portability is a huge one. I tend to work
on Macs (these days ARM), but deploy to Linux environments (these days Intel). While I have had lots
of different remote development experiences, there's always been challenges with maintaining them.

Currently, I've been using Nix to help solve this problem. I've also been using to setup remote
development environments with [coder](https://coder.com) for our teams. Nix has been amazing for
this! While I won't get to that detail here, I want to give you enough of an understand on _why_
Nix can help here, and just enough to get started.

# How nix is different

How does nix handle this differently? First off, nix is a _purely functional_ package manager. This
means that when a package is built it has no side effects and does not change after being built.

Nix saves these packages in a _nix store_, typically in `/nix/store` with content addressable store.
Nix not only allows you to store multiple versions of a package, but also multiple _derivations_ of
a package, meaning that you can have different configurations of a package and it's dependencies.

While normally this level of build isolation would be fairly expensive to maintain, the content
addressable nature of these package builds means that you get a fair amount of caching. Both from
local caching in your store (not having to rebuild), but also being able to download pre-built
packages and binaries.

This also means that you can maintain different profiles for referencing these packages - being
able to install different versions of the same package for your system, user, or shell means
that you can have multiple versions of the same package at the same time.

This is quite difficult to do with other package managers - just think about issues with versions
of `openssl` or `libxml` when building different applications.

For an example, let's use the `nix-shell` command to open up a new bash shell with `curl`
installed. (Note this example is running on Linux).

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

[nix-shell:~/workspace/nix-talk]$ curl --version
curl 8.14.1 (x86_64-pc-linux-gnu) libcurl/8.14.1 OpenSSL/3.4.1 zlib/1.3.1 brotli/1.1.0 zstd/1.5.7 libidn2/2.3.8 libpsl/0.21.5 libssh2/1.11.1 nghttp2/1.65.0
Release-Date: 2025-06-04
Protocols: dict file ftp ftps gopher gophers http https imap imaps ipfs ipns mqtt pop3 pop3s rtsp scp sftp smb smbs smtp smtps telnet tftp
Features: alt-svc AsynchDNS brotli GSS-API HSTS HTTP2 HTTPS-proxy IDN IPv6 Kerberos Largefile libz NTLM PSL SPNEGO SSL threadsafe TLS-SRP UnixSockets zstd

[nix-shell:~/workspace/nix-talk]$ which curl
/nix/store/wq4mwdypl1wmlhyrr69wggv8jdn2h9j9-curl-8.14.1-bin/bin/curl

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

[nix-shell:~/workspace/nix-talk]$ exit 
exit

```

Note that this is slightly different when running on macOS (using `otool` instead of `ldd`).

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

We can see all of the shared objects here all point to items in our nix store. In addition, nix was
able to download most of these from `https://cache.nixos.org` rather than rebuilding locally.

It's even faster to re-open a shell the second time since curl already exists in the store. And
when the shell is closed, it's not longer in my path. This is what lets us maintain different
shells for different environments on the same machine.

Nix also provides garbage collection to cleanup unreferenced packages over time. The nix expression
language is what allows us to write these packages in a purely functional way. We'll learn how to
do that soon.

# First steps - installing

While there are a few ways to install nix, I'd recommend starting with using the Determinate Nix
Installer to install Determinate Nix. This is a _distribution_ of nix, but it makes it easier to
get going quickly, with easier to manage options (flakes on by default, automatic garbage
collection, uninstaller).

You can run this on your machine (macOS, Linux, or Windows WSL) and get things up and going.

```bash
$ curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
```

# Your first environment

Now that you have nix itself installed, let's make a development environment. Create a new
directory to work out of (mine is `~/workspace/nix-first-steps`) and lets set up this as a repo.

```bash
$ mkdir -p ~/workspace/nix-first-steps
$ cd ~/workspace/nix-first-steps
$ git init
$ nix flake init -t templates#utils-generic
```

You'll notice this makes a new file named `flake.nix`.

The contents will look something like:

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

There will also be an `.envrc` with the following

```bash
use flake
```

While this isn't helpful for us just yet, let's assume we're building a rust app. Now, seeing a
`nix` file (and syntax) might seem intimidating, let's learn enough of the syntax to understand
what we're looking at. If you want, you can also try opening up the nix repl with `nix repl`
to type expressions below to understand what's valid nix.

```nix
# Text that follows a `#` is a comment!

# This is a string
"foo"

# This is a multi-line string
''I'm a mult-line
string
''

# This is a number
5

# This is a list of numbers and strings
[ 1 2 "foo" ]

# This is an empty "attribute set", which is also like a dictory or hash in other languages.
{}

# attribute sets can assign attributes
{ foo = "bar"; baz = "buzz"; }

# You can make nested attribute sets
{ foo = { bar = "baz"; }; }

# Or assign them with a "." for shorthand
{ foo.bar = "baz"; }

# This is our inputs example
{ inputs = { utils.url = "github:numtide/flake-utils"; }; }

# a `:` denoates a function with arguments on left and function body on the right
x: x + 1

# You can call a function by applying an argument, but you may need to wrap in parentheis
(x: x + 1) 2

# Most of the time you will see attributes as the function arguments
{ a, b }: a + b

# When calling this you pass an attribute set
({ a, b }: a + b) { a = 2; b = 3; }

# Functions can also be `curried`
a: b: a + b

# Again, using parenthsis to apply
(a: b: a + b) 2 3

# Now we can undertand the ouput line a bit better (omitting the `system` body for now)...

# This `assigns` outputs to a function that takes an attribute set with `self`, `nixpkgs`,
# and `utils`. The body of the function calls the function `eachDefaultSystem` from
# the nested attribute set of `utils.lib`, which sends the argument of a
# function that takes `system` as an argument and returns an attribute set!

{
  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (system: { });
}

# Let's look into the actual contents of that function call a bit more

# `let` blocks allow you to assign values you can use inside an `in` block
let
  a = 10;
in
{
  x = a;
}

# Sometimes you might want to refer to interpolated values for attribute keys
# We can use `${}` for this
let
  a = "x";
in
{
  ${a} = 10;
}

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

let
  a = 10;
  b = 12;
  c = 5;
in
{
  inherit a b c;
}

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

# We have one last thing to learn before we understand all of our flake!
# You can do it!

# Sometimes repeating keys can get a bit cumbersome
let
  x = { a = 1; b = 3; c = 4; };
in
  [ x.a x.b x.c ]

# We can use `with` to automaticly scope all of the attributes in x
let
  x = { a = 1; b = 3; c = 4; };
in
  with x; [ a b c ]

# You did it! Great job!
```

Now that we understand the _syntax_ of the nix (and the flake), we need to understand some of the
conventions so we can know what we want to change. A flake is an nix expression that returns an
attribute set with a number of fixed attributes.


`inputs` are the dependencies for this flake. They are some patterns, but mostly these point to
git or github repository urls for other flakes.


This is where we get `utils` from!
```nix
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
```

We can also update out flake to be more explicit about where we are fetching our nixpkgs from.
Let's move to using `25.05`.

```nix
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    utils.url = "github:numtide/flake-utils";
  };
```

If we wanted to use `unstable`, we could point to `github:nixos/nixpkgs/nixos-unstable`.
Note that these are resolving to a github repository and the last part is a git `ref`.

Now let's add our packages to our development shell.

Since we're using rust, we can add all of the rust tooling we'll want.

In our `devShell` input, we're building a shell with the following `buildInputs`.
Because we have `pkgs` scoped with `with`, we can just add them to the list.

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

You can also other packages you might want here! See [search.nixos.org](https://search.nixos.org/packages)
for looking up what you'd like to have.

Now, you can add this to your shell with `nix develop` for `.#` which points to the current flake
in your directory. You can type `exit` or press `CTRL-D` to get back to your original shell.

```bash
$ nix develop .#
(nix:nix-shell-env) bash-5.2$ rustc --version
rustc 1.86.0 (05f9846f8 2025-03-31) (built from a source tarball)
(nix:nix-shell-env) bash-5.2$ cargo --version
cargo 1.86.0 (adf9b6ad1 2025-02-28)
(nix:nix-shell-env) bash-5.2$ exit
exit
```

But having to do this is a bit of a pain - this is where [direnv](https://direnv.net/) can help us.

If you already have direnv installed, great - you'll notice that you would have been prompted
awhile ago. If you haven't, we can use nix to install it for your `profile`. This is installing
the package for your user rather than just for this repository.

Note if you are using `zsh` or other another shell, you'll want to change the eval line below.

```bash
$ nix profile install nixpkgs#direnv
$ echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
$ source ~/.bashrc
```

```bash
$ direnv allow
direnv: loading ~/workspace/nix-first-steps/.envrc
direnv: using flake
warning: Git tree '/Users/scott/workspace/nix-first-steps' has uncommitted changes
direnv: export +AR +AS +CC +CONFIG_SHELL +CXX +DEVELOPER_DIR +HOST_PATH +IN_NIX_SHELL +LD +LD_DYLD_PATH +MACOSX_DEPLOYMENT_TARGET +NIX_APPLE_SDK_VERSION +NIX_BINTOOLS +NIX_BINTOOLS_WRAPPER_TARGET_HOST_arm64_apple_darwin +NIX_BUILD_CORES +NIX_BUILD_TOP +NIX_CC +NIX_CC_WRAPPER_TARGET_HOST_arm64_apple_darwin +NIX_CFLAGS_COMPILE +NIX_DONT_SET_RPATH +NIX_DONT_SET_RPATH_FOR_BUILD +NIX_ENFORCE_NO_NATIVE +NIX_HARDENING_ENABLE +NIX_IGNORE_LD_THROUGH_GCC +NIX_LDFLAGS +NIX_NO_SELF_RPATH +NIX_STORE +NM +OBJCOPY +OBJDUMP +PATH_LOCALE +RANLIB +SDKROOT +SIZE +SOURCE_DATE_EPOCH +STRINGS +STRIP +TEMP +TEMPDIR +TMP +ZERO_AR_DATE +__darwinAllowLocalNetworking +__impureHostDeps +__propagatedImpureHostDeps +__propagatedSandboxProfile +__sandboxProfile +__structuredAttrs +buildInputs +buildPhase +builder +cmakeFlags +configureFlags +depsBuildBuild +depsBuildBuildPropagated +depsBuildTarget +depsBuildTargetPropagated +depsHostHost +depsHostHostPropagated +depsTargetTarget +depsTargetTargetPropagated +doCheck +doInstallCheck +dontAddDisableDepTrack +mesonFlags +name +nativeBuildInputs +out +outputs +patches +phases +preferLocalBuild +propagatedBuildInputs +propagatedNativeBuildInputs +shell +shellHook +stdenv +strictDeps +system ~PATH ~TMPDIR ~XDG_DATA_DIRS
```

Now you can use your development shell while in this project, and when you leave, tools will no
longer be in your path!

```bash
$ rustc --version
rustc 1.86.0 (05f9846f8 2025-03-31) (built from a source tarball)
```

# Let's build our app

Now that we have our environment, we can build our app.

```bash
$ cd ~/workspace/nix-first-steps
$ cargo new hello-nix
$ cd hello-nix
```

We can keep this simple for now, but let's open up and change the default hello to say something
a bit more specific.

open up `hello-nix/src/main.rs` and change to the following:
```rust
fn main() {
    println!("Hello from nix!");
}
```

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

We have some new nix syntax, so let's get to learning what some of this is. Fire up that `nix repl`
and let's get to work.

```nix
# The `?` allows us to have optional values in attribute sets. This comes in handy for optional
# arguments in functions.
{ foo ? "foo" }: foo

# you can either apply without that name set.
({ foo ? "foo" }: foo) {}

# or with it
({ foo ? "foo" }: foo) { foo = "bar"; }

# `import` is a special builtin function for loading code.
# `./filename` is path variable relative by current directory.
# We can use this to import our new `default.nix` file
import ./default.nix

# <nixpkgs> is a special value that resolves lookup paths for $NIX_PATH
# This can be used to dynamically load whichever location nix is set to
# That means that the argument to our function takes an attribute set with
# an options pkgs that defaults to the imported version of `nixpkgs` if passed in.
{ pkgs ? import <nixpkgs> { } }: {}

# We use this `pkgs` to call a into a function that helps us build our rust app.
# We set the package name and version, and then provide it our `./Cargo.lock` and
# current source of `./.`

# Altogether, it's
{ pkgs ? import <nixpkgs> { } }:
pkgs.rustPlatform.buildRustPackage {
  pname = "hello-nix";
  version = "0.0.1";
  cargoLock.lockFile = ./Cargo.lock;
  src = pkgs.lib.cleanSource ./.;
}
```

This altogether builds a package _derivation_. In order to use it to build our package,
we can run the following:

```bash
$ nix build -f default.nix
```

When it finishes, we can see the `result` of the derivation symlinked in your current directory.
The derivation gets saved in our nix store. When we're done, we can delete this symlink.

```bash
$ ls -la result
lrwxr-xr-x 1 scott staff 59 Jun 29 17:26 result -> /nix/store/rj2wf0vgsgbsadlad6nxssnb4lhqvjw1-hello-nix-0.0.1
$ ./result/bin/hello-nix
Hello from nix!
$ rm result
```

Now that we have a package, we want to add it to our flake for our repo. Going back up to the top
level directory, we can add this to our flake.

```bash
      {
        devShell = pkgs.mkShell {
         # ...
        };
        packages.default = pkgs.callPackage ./hello-nix { inherit pkgs; }
      }
```

We're provided a `default` package here and are using the built-in of `callPackage` to derive the
package for our current `system`. Note that we don't have to use the full `./hello-nix/default.nix`
path here since nix will look for a `default.nix` for a directory.

We can now build our package from our flake with

```bash
$ nix build .#
```

Here `.` means "the current source tree flake" and `#` points to the name, which we've left empty.
It looks for `default` when not provided, but if we named both we could provide them.

But this will error!

We get a fairly long and ugly error message
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

Because this flake sees a git repository, it wants to ensure any files reference have been added to
git. Doing so will fix our build. We do also want add a few things to our `.gitignore` first.

```bash
$ echo "target" >> .gitignore
$ echo ".direnv" >> .gitignore
$ git add "hello-nix"
```

Now our build should work. Similar to before, we have a result symlink.

```bash
$ nix build .#
warning: Git tree '/Users/scott/workspace/nix-first-steps' has uncommitted changes
$ ls -l result
lrwxr-xr-x 1 scott staff 59 Jun 29 17:45 result -> /nix/store/yqw9zry7dsgyr692y18pb330xhwlrwr5-hello-nix-0.0.1
$ ./result/bin/hello-nix
Hello from nix!
$ rm result
```

You'll note this is may be a _slightly_ different hash prefix as before. While before we were
building against a default `nixpkgs`, here our flake has a very specific pinned version. This means
our two derivations are actually different.

We can also run our new package
```bash
$ nix run .#
warning: Git tree '/Users/scott/workspace/nix-first-steps' has uncommitted changes
Hello from nix!
```

If we were to share this repo, we could even run it without having to check out the code!

```bash
$ nix run github:sentientmonkey/nix-first-steps
Hello from nix!
```

# Let's build for docker

Now we'd like to make sure we can build this into a docker image from nix.

*Note*: for the steps below, this only works on linux, and not macOS.

First, we'll want to make a new file to help build our docker image.

Create a new file `hello-nix/build-docker.nix`
```nix
{
  pkgs ? import <nixpkgs> { }
}:

pkgs.dockerTools.buildImage {
  name = "hello-nix";
  tag = "latest";
  config = {
    Cmd = [ "${pkgs.hello}/bin/hello" ];
  };
}
```

This is is a basic docker file that runs a the `hello` package. We can build this to test it out,
and then use it to load and run in docker.

```bash
$ docker load < $(nix build -f hello-nix/build-docker.nix --no-link --print-out-paths)
Loaded image: hello-nix:0.0.1
$ docker run hello-nix:0.0.1
Hello from nix!
```

Note that we're using `--no-link` to avoid making the `result` symblink and `--print-out-paths` to
print the resulting OCI image tarball. This is loaded directly into docker and can be run, or
pushed to any registry.

Now that we have an example working, let's add in _our_ nix package.

Back in our `flake.nix`, first we can add in this to make a new package.

```nix
        packages.default = pkgs.callPackage ./hello-nix { inherit pkgs; }
        packages.dockerImage = pkgs.callPackage ./hello-nix/build-docker.nix { inherit pkgs; }
```

This lets us build the dockerImage (as a package) first. We can test this with using the flake
version of our build config. Don't forget to `git add` your new file!

```bash
$ git add hello-nix/build-docker.nix
$ docker load $(nix build .#dockerImage --no-link --print-out-paths)
Loaded image: hello-nix:0.0.1
$ docker run hello-nix:0.0.1
Hello, World!
```

Now, we want to use our build nix package. Let's do a small refactor first to extract our package
build of 'hello-nix'.

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
    );
```

We've moved to assign this to `helloNix` in our let block and replaced it for our assignment to
`packages.default`. We'd like to also pass this our `build-docker.nix` callPackage, so let's add
that into our params.

```nix
        packages.dockerImage = pkgs.callPackage ./hello-nix/build-docker.nix { inherit pkgs helloNix; };
```

Now back in our `build-docker.nix`, we can update our build to use this new package being passed
in.

```nix
{
  helloNix,
  pkgs ? import <nixpkgs> { },
}:

pkgs.dockerTools.buildImage {
  name = "hello-nix";
  tag = "latest";
  config = {
    Cmd = [ "${helloNix}/bin/hello-nix" ];
  };
}
```
Re-running out build gives us our build app.

```bash
$ docker load $(nix build .#dockerImage --no-link --print-out-paths)
Loaded image: hello-nix:0.0.1
$ docker run hello-nix
Hello from nix!
```

# Extending our docker image

This is a very minimal app, with only our binary. It's possible we may want something slighly more
functional with common utils for debugging. Let's add an interactive bash shell and coreutils.

Below we switch ovdr to use `copyToRoot` which allows us to provide all of the packages we provide
in `paths`, and symlink over what we need with `pathsToLink`. Note this means we can move to
`/bin/hello-nix` for our package.

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

Now we can run it with a shell. Note that we can also use the package's version to tag our image.

```bash
$ docker load $(nix build .#dockerImage --no-link --print-out-paths)
Loaded image: hello-nix:0.0.1
$ docker run -it /bin/bash
bash-5.2#
```

We can use `ls`, `cd`, `pwd`, etc in our interactive shell. You can add whatever packages you
need for our application. You can also add the same exact versions packages to your devShell.

# Adding runtime dependancies

Now let's say that our app is running fine, but there are few apps that it needs, or even that
I want to wrap that application with other commands. In this case, let's assume I want more of
a fun output using `figlet` and `lolcat`.

First, for our devShell, let's add those dependancies in our top level `flake.nix`.

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

This is really just so we can test out the experience as we're working on our code. After your
shell has refreshed with a `direnv allow`, you can use use `figlet` and `lolcat` to make your
output even prettier!

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

If we wanted to, we could tune arguments and prototype here. Once we're ready, we'd like to ensure
that when we run `hello-nix` as our package, it _always_ runs with these pipes. We can use our
derivation build to help us out.

If we go back our package build in `hello-nix/default.nix`, we can add a `nativeBuildInputs`
dependancy on the `makeWrapper` package, and use that to wrap our existing `hello-nix` binary
in a `postInstall` step.

`makeWrapper` is included in the [nix stdenv](https://ryantm.github.io/nixpkgs/stdenv/stdenv/#fun-makeWrapper).
It's a bash script that re-wraps a program as a bash script with customizations (like setting 
a `--prefix` to our path, or adding default flags with `--add-flags`.


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

Now when we build, we can see that what it generates for us.

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

Re-running gives us a much prettier output by default!

```bash
$ nix run .#
 _   _      _ _          __                             _      _
| | | | ___| | | ___    / _|_ __ ___  _ __ ___    _ __ (_)_  _| |
| |_| |/ _ \ | |/ _ \  | |_| '__/ _ \| '_ ` _ \  | '_ \| \ \/ / |
|  _  |  __/ | | (_) | |  _| | | (_) | | | | | | | | | | |>  <|_|
|_| |_|\___|_|_|\___/  |_| |_|  \___/|_| |_| |_| |_| |_|_/_/\_(_)

```

This also automatically works for our docker image.

```bash
$ docker load < $(nix build .#dockerImage --no-link --print-out-paths)
Loaded image: hello-nix:0.0.1
$ docker run -it /bin/bash
 _   _      _ _          __                             _      _
| | | | ___| | | ___    / _|_ __ ___  _ __ ___    _ __ (_)_  _| |
| |_| |/ _ \ | |/ _ \  | |_| '__/ _ \| '_ ` _ \  | '_ \| \ \/ / |
|  _  |  __/ | | (_) | |  _| | | (_) | | | | | | | | | | |>  <|_|
|_| |_|\___|_|_|\___/  |_| |_|  \___/|_| |_| |_| |_| |_|_/_/\_(_)

```

You can even run the `unwrapped` version

```bash
$ docker run -it hello-nix:0.0.1 /bin/.hello-nix-wrapped
Hello from nix!
```

# Wrapping up - takeaways and jumping off points

Now that you've gotten a quick tour of how nix can be helpful in building out your dev
environments, I encourage you to explore and learn more. Some jumping off points:

* [devenv](https://devenv.sh/) for pinning languages and adding services (i.e. postgres, redis)
* [dockertools](https://ryantm.github.io/nixpkgs/builders/images/dockertools/)  for building containers with nix
* [flakes](https://nixos.wiki/wiki/flakes) for more details about building flakes
* [nix create and debug packages](https://nixos.wiki/wiki/Nixpkgs/Create_and_debug_packages) to help build your own packages
* [search.nixos.org](https://search.nixos.org/packages) to explore packages
* [zero to nix](https://zero-to-nix.com/) to learn more about nix

I hope this inspires you to learn more and experiment!
