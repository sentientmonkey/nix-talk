# Nix talk
Scott Windsor
DevOps PDX

# Background

I started with computers at an early age with Apple ii, then moved on to IBM DOS machines. Eventually
I had my own computer from hand-me-down 286 parts. I got on BBSes and early internet, which opened
up a whole world of unfamiliar and interesting things. I was also pretty interesting in video games,
playing Nintendo and PC games.

I learned to program in College (Virginia Tech), starting with C, getting my Computer Science degree.
I also learned a fair a amount from running my own Linux servers and working with a 
few different Unixes (Solaris, FreeBSD) and doing more web programming.

I graduated and moved to Seattle to come work for Amazon, and stayed there for a long time before
moving to smaller startups, getting acqu-hired back to Amazon, moving to AWS, then to Piovtal Labs,
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

# First steps - installing

While there are a few ways to install nix, I'd recommend starting with using the Determinate Nix
Installer to install Determinate Nix. This is a _distribution_ of nix, but it makes it easier to
get going quickly, with easier to manage options (flakes on by default, automatic garbage
collection, uninstaller).

You can run this on your machine (macOS, Linux, or Windows WSL) and get things up and going.

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
```

# Your first environment

Now that you have nix itself installed, let's make a development environment. Create a new
directory to work out of (mine is `~/workspace/nix-first-steps`) and lets set up this as a repo.

```bash
mkdir -p ~/workspace/nix-firs-steps
cd ~/workspace/nix-first-steps
git init
nix flake init templates#utils-generic
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

{ outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system: {})};

# Let's look into the actuall contents of that function call a bit more

# `let` blocks allow you to assign values you can use inside an `in` block
let a = 10; in { x = a; }

# Sometimes you might want to refer to interpolated values for attribute keys
# We can use `${}` for this
let a = "x"; in { ${a} = 10; }

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
nix develop .#
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

```bash
nix profile install nixpkgs#direnv
```

```bash
direnv allow
direnv: loading ~/workspace/nix-first-steps/.envrc
direnv: using flake
warning: Git tree '/Users/scott/workspace/nix-first-steps' has uncommitted changes
direnv: export +AR +AS +CC +CONFIG_SHELL +CXX +DEVELOPER_DIR +HOST_PATH +IN_NIX_SHELL +LD +LD_DYLD_PATH +MACOSX_DEPLOYMENT_TARGET +NIX_APPLE_SDK_VERSION +NIX_BINTOOLS +NIX_BINTOOLS_WRAPPER_TARGET_HOST_arm64_apple_darwin +NIX_BUILD_CORES +NIX_BUILD_TOP +NIX_CC +NIX_CC_WRAPPER_TARGET_HOST_arm64_apple_darwin +NIX_CFLAGS_COMPILE +NIX_DONT_SET_RPATH +NIX_DONT_SET_RPATH_FOR_BUILD +NIX_ENFORCE_NO_NATIVE +NIX_HARDENING_ENABLE +NIX_IGNORE_LD_THROUGH_GCC +NIX_LDFLAGS +NIX_NO_SELF_RPATH +NIX_STORE +NM +OBJCOPY +OBJDUMP +PATH_LOCALE +RANLIB +SDKROOT +SIZE +SOURCE_DATE_EPOCH +STRINGS +STRIP +TEMP +TEMPDIR +TMP +ZERO_AR_DATE +__darwinAllowLocalNetworking +__impureHostDeps +__propagatedImpureHostDeps +__propagatedSandboxProfile +__sandboxProfile +__structuredAttrs +buildInputs +buildPhase +builder +cmakeFlags +configureFlags +depsBuildBuild +depsBuildBuildPropagated +depsBuildTarget +depsBuildTargetPropagated +depsHostHost +depsHostHostPropagated +depsTargetTarget +depsTargetTargetPropagated +doCheck +doInstallCheck +dontAddDisableDepTrack +mesonFlags +name +nativeBuildInputs +out +outputs +patches +phases +preferLocalBuild +propagatedBuildInputs +propagatedNativeBuildInputs +shell +shellHook +stdenv +strictDeps +system ~PATH ~TMPDIR ~XDG_DATA_DIRS
```

Now you can use your development shell while in this project, and when you leave, tools will no
longer be in your path!

```bash
rustc --version
rustc 1.86.0 (05f9846f8 2025-03-31) (built from a source tarball)
```


