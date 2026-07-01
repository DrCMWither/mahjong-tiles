# PongTeX: Mahjong LaTeX Package

PongTeX is a LaTeX package for typesetting Japanese/Riichi Mahjong tiles with compact MPSZ notation. This package adopts an extremely compact MPSZ syntax and supports the automated rendering of complex tile arrangements, including red fives (Akadora), rotated tiles for called melds, and closed kans (Ankan).


## Installation & Setup

Place the `pongtex.sty` file in your TeX working directory or your local `texmf` tree. Import the package in your document's preamble using `\usepackage`, where you can optionally adjust the tile height:

```tex
\usepackage{pongtex}
```

Supported package keys:

```tex
\usepackage[
  height=1.5\baselineskip,
  scale=0.75,
  color=blue!70!black,
  no-aka=1

]{pongtex}
```

You can also change defaults after loading the package:

```tex
\pongtexsetup{height=1.5\baselineskip,scale=0.75,color=teal!65!black,no-aka=0}
```

## Basic Usage

Use `\mahjong{...}` command in the body of your document to easily render tiles:

```tex
% Standard hand
\mahjong{111m456s111p11122z}

% Hand with called melds (rotated tiles) and gaps
\mahjong{111m111s111p22z2-3*333z}

% Hand with closed kans and specific red fives
\mahjong{555m555s22z2-55555p1-33333z}

```

For developers accustomed to the LaTeX3 (expl3) programming style, the package also exposes underlying commands for direct calling:

```tex
\ExplSyntaxOn
\mahjong_main:n {111m456s111p11122z}
\mahjong:n      {111m456s111p11122z}
\ExplSyntaxOff

```


## Back Color Replacement

The back of a tile (`x`) can be recoloured with `color` either as a package option or later through `\pongtexsetup`:

```tex
\usepackage[height=1.5\baselineskip,color=blue!70!black]{mahjong}

% Change it later
\pongtexsetup{color=teal!65!black}
\mahjong{x x x}

% Restore the original embedded back artwork
\pongtexsetup{color=none}
```

This recolouring uses a clipping mask rather than a blend overlay.  Since `tiles/mahjong-Back.pdf` consists only of a solid red shape and transparent corners, the package clips to the exact original back outline and fills that mask with the requested `xcolor` colour.

## Syntax Guide

This package uses an intuitive "number + letter" input syntax. The specific rules are as follows:

* **Basic Suits**
* `m` / `p` / `s` / `z`: Represent Characters (Manzu), Circles (Pinzu), Bamboo (Souzu), and Honor tiles (Jihai), respectively. Example: `123m456p`.


* **Special Tiles**
* `0m` / `0p` / `0s`: Renders the corresponding Red Dora (Red Five).
* `x`: Renders the back of a Mahjong tile (face-down).
* `?`: Renders an unknown tile.


* **Gaps and Spacing**
* `-`: Generates a standard gap (commonly used to separate the closed hand from open melds).
* `N-` (e.g., `2-`): A numeric prefix generates a proportional gap. For instance, `2-` indicates a gap equal to 2/7 of a tile's width (this syntax is primarily for compatibility with legacy test data).


* **Called Melds and Rotation**
* `*` or `'`: Rotates the preceding tile sideways (used to indicate Chii, Pon, or Riichi).
* `+` or `"`: Generates two stacked, sideways tiles (used to indicate an upgraded Kan / Shouminkan).


* **Closed Kan (Ankan) Shortcuts**
* Typing 5 identical consecutive numbers (e.g., `33333z` or `55555p`) will automatically render using the visual rules for a **closed kan**: "face-down tile + two face-up tiles + face-down tile".
* For suits containing red fives (e.g., `55555m` / `55555p` / `55555s`), it will automatically render as: "face-down tile + red five + regular five + face-down tile".

## Compilation

This package supports compilation using the standard `pdflatex` engine. To view the test results, you can directly compile the provided test file:

```bash
pdflatex test.tex

```

*(A verified `test.pdf` is included in the project for reference to check the output rendering.)*

## Acknowledgments
This package is built upon the foundation of the excellent [`mahjong` package](https://ctan.org/pkg/mahjong) developed by Daniel Schmitz and available on CTAN.

We extend our gratitude to the original author. While inheriting the underlying tile drawing logic and basic MPSZ support, `PongTeX` refactors the core implementation to introduce syntactic sugar (such as automated kan rendering, tile stacking, and advanced spacing shortcuts) to significantly reduce the code needed to typeset complex mahjong hands.