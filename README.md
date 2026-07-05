# mahjong-tiles: Mahjong LaTeX Package

`mahjong-tiles` is a LaTeX package for typesetting Japanese/Riichi Mahjong hands, flower tiles, discard rivers, and score sticks from compact MPSZF notation.  It supports red fives (akadora), rotated and stacked tiles for called melds, concealed-kong shorthand, overlay notes, tile-back recolouring, and score-stick summaries.

## Installation & Setup

Generate the runtime package file from the split documented sources when needed:

```bash
latex mahjong-tiles.ins
```

The top-level `mahjong-tiles.dtx` is the documented-source driver; the implementation fragments live under `dtx/` and are extracted in order by `mahjong-tiles.ins`.

Then install these files together in a TeX-searchable package directory, or keep them in the same working directory as your document:

```text
mahjong-tiles.sty
tiles/*.pdf
assets/stick/*.pdf
```

The default artwork paths are `tiles/` for tile faces and backs, and `assets/stick/` for score sticks.  If you install the artwork elsewhere, set `tile-dir` or `stick-dir` accordingly.

Load the package in your document preamble:

```tex
\usepackage{mahjong-tiles}
```

A typical customized setup is:

```tex
\usepackage[
  height=1.5\baselineskip,
  scale=0.75,
  color=blue!70!black,
  aka=1,
  river-cols=6,
  stick-scale=0.5
]{mahjong-tiles}
```

You can also change defaults after loading the package:

```tex
\mahjongtilessetup{height=1.5\baselineskip,scale=0.75,color=teal!65!black,aka=0}
```

The old `no-aka` option is still accepted for compatibility, but new documents should use `aka=0` instead.

## Quick Start

Use `\mahjong{...}` to render a hand or meld layout:

```tex
% Standard hand
\mahjong{111m456s111p11122z}

% Hand with called melds (rotated tiles) and gaps
\mahjong{111m111s111p22z2-3*333z}

% Hand with closed kans and specific red fives
\mahjong{555m555s22z2-55555p1-33333z}
```

Use `\mahjongriver{...}` for discard rivers:

```tex
\mahjongriver{1m9m2z5z3s6s1s1m8p4z87m}
\mahjongriver[river-cols=6]{1m9m2z5z3s6s1s*1m8p4z87m}
```

Use `\stick{...}` for score sticks:

```tex
% 30,500 points, decomposed into 10k and 100-point sticks
\stick{305}

% Manual counts: 10k=3 and 100=5
\stick{10k=3,100=5}
```

For developers using LaTeX3 (`expl3`), the package exposes public functions:

```tex
\ExplSyntaxOn
\mahjongtiles_typeset_hand:n {111m456s111p11122z}
\mahjongtiles:n              {111m456s111p11122z}
\mahjongtiles_typeset_river:n{1m2m3m4m5m6m7m8m9m}
\mahjongtilesriver:n         {1m2m3m4m5m6m7m8m9m}
\ExplSyntaxOff
```

## Package Options

Supported global keys for `\usepackage[...]` and `\mahjongtilessetup{...}`:

| Key | Default | Meaning |
| --- | --- | --- |
| `height` | `\baselineskip` | Height of one upright tile. |
| `scale` | `0.75` | Scale factor for the tile symbol relative to the tile face. |
| `tile-dir` | `tiles` | Directory containing the tile PDF artwork. |
| `color` | `none` | Recolour the back tile `x`; use any `xcolor` expression or `none`. |
| `aka` | `1` | Red-five mode: `0` disables red fives, `1` enables them, `2` also gives `55555p` an extra red five pin in concealed-kong shorthand. |
| `river-cols` | `6` | Number of tiles per discard-river row. |
| `river-row-gap` | `0pt` | Vertical gap between discard-river rows. |
| `overlay-style` | TikZ node options | Style used for overlay notes. |
| `stick-dir` | `assets/stick` | Directory containing score-stick PDFs. |
| `stick-height` | `\baselineskip` | Base height for score-stick images. |
| `stick-scale` | `0.5` | Scale factor applied to score-stick images. |
| `stick-sep` | `.6em` | Horizontal gap between different score-stick groups. |

Most of these keys can also be used locally in the first optional argument:

```tex
\mahjong[height=1.5\baselineskip,scale=0.75,color=teal!65!black,aka=0]{x 0m0p0s}
\mahjongriver[river-cols=5,river-row-gap=.2em]{1m2m3m4m5m6m7m8m9m}
\stick[height=2em,scale=1,sep=.8em]{305}
```

## MPSZF Notation

A tile is written as one or more digits followed by a suit letter.

| Suit | Meaning | Valid tiles |
| --- | --- | --- |
| `m` | Manzu / characters | `0m` to `9m`; `0m` is red five when `aka` is enabled. |
| `p` | Pinzu / circles | `0p` to `9p`; `0p` is red five when `aka` is enabled. |
| `s` | Souzu / bamboo | `0s` to `9s`; `0s` is red five when `aka` is enabled. |
| `z` | Honors | `1z` to `7z`. |
| `f` | Flowers | `0f` to `8f`. |

Examples:

```tex
\mahjong{111m456s111p11122z}
\mahjong{19m19s19p1234567z}
\mahjong{012345678f}
```

Special tokens and markers:

| Token | Meaning |
| --- | --- |
| `x` | Face-down tile back. |
| `?` | Unknown blank tile. |
| `-` | Full visual gap between groups. |
| `N-` | Proportional gap of `N/7` of one tile width, for example `2-`. |
| `*` or `'` | Rotate the preceding tile sideways. |
| `+` or `"` | Stack two sideways copies of the preceding tile. |
| `[text]` | Attach a text note above the previous tile. |
| `\mj{tile}` | Render a tile inside an annotation, or a drawn tile inside `\mahjong`. |

## Red Fives and Concealed Kongs

Red fives are controlled by `aka`:

```tex
\mahjong{0m0p0s55555m}
\mahjong[aka=0]{0m0p0s55555p}
\mahjong[aka=2]{55555p}
```

Five identical consecutive digits followed by a suit are rendered as a concealed kan: a face-down tile, two visible tiles, and a face-down tile.  For suited fives, the visible pair depends on `aka`: `aka=0` gives two regular fives, `aka=1` gives a red five plus a regular five, and `aka=2` gives `55555p` two red five-pin tiles.

Red-five edge stack markers are also supported for upgraded-kan notation:

```tex
\mahjong{0p" 0p"" 0p"""}
\mahjong{0p+ 0p++ 0p+++}
```

## Tile-back Recolouring

The back tile (`x`) can be recoloured globally or locally:

```tex
\mahjongtilessetup{color=purple!70!black}
\mahjong{x x x}

\mahjong[color=teal!65!black]{x x x}
\mahjong[color=none]{x x x}
```

This recolouring uses a clipping mask rather than a blend overlay.  Since `tiles/mahjong-tiles-Back.pdf` consists only of a solid red shape and transparent corners, the package clips to the exact original back outline and fills that mask with the requested `xcolor` colour.

## Overlay Notes

Text in square brackets annotates the preceding tile:

```tex
\mahjong{111m111s111p2z2-3*333z7-2z[waiting]}
\mahjong{123m456p789s\mj{2z}11z}
\mahjong{111m113s111p2z2-3*333z7-2z[discard \mj{3s}, waiting \mj{1s}]}
```

Inside annotations, mahjong tiles are rendered only when wrapped in `\mj{...}`.  Inline `\mj{...}` used directly inside `\mahjong{...}` must contain exactly one tile and is typeset as a drawn tile above the hand.

## Score Sticks

`\stick{305}` means 30,500 points and is automatically decomposed into `10k`, `5k`, `1k`, and `100` sticks.  Manual forms are also accepted:

```tex
\stick{305}
\stick{089}
\stick{10k=3,100=5}
\stick{3,0,0,5}
\stick[manual]{0,1,2,4}
\stick[height=2em,scale=1]{305}
```

The compact comma-list form uses the order `10k, 5k, 1k, 100`.

## Compilation

This package supports compilation using the standard `pdflatex` engine. To view the test results, you can directly compile the provided test file:

```bash
make doc       # build the manual
make example   # build the example document
make code-doc  # build the documented implementation from the split dtx files
make check     # regenerate the package and build both PDFs
```

## Acknowledgments

This package is built upon the foundation of the excellent [`mahjong` package](https://ctan.org/pkg/mahjong) developed by Daniel Schmitz and available on CTAN.

We extend our gratitude to the original author. While inheriting the underlying tile drawing logic and basic MPSZ support, `mahjong-tiles` refactors the core implementation to introduce syntactic sugar (such as automated kan rendering, tile stacking, and advanced spacing shortcuts) to significantly reduce the code needed to typeset complex mahjong hands.

The mahjong tiles used in this package were created by [@FluffyStuff](https://github.com/FluffyStuff).
The original repository is [FluffyStuff/riichi-mahjong-tiles](https://github.com/FluffyStuff/riichi-mahjong-tiles), used under public domain/CC0.
Assets under `tiles-tmp` and `aassets` were created by LCMWither, also used under public domain/CC0.