# Makefile for mahjong-tiles

PACKAGE      = mahjong-tiles
VERSION      = 2.6.1
LATEX        ?= latex
PDFLATEX     ?= pdflatex
TEXMFHOME    ?= $(shell kpsewhich -var-value=TEXMFHOME 2>/dev/null || printf '%s' "$$HOME/texmf")
TEXDIR       = $(TEXMFHOME)/tex/latex/$(PACKAGE)
DOCDIR       = $(TEXMFHOME)/doc/latex/$(PACKAGE)
SRCDIR       = $(TEXMFHOME)/source/latex/$(PACKAGE)
DTXDIR       = dtx
DTX_PARTS    = \
  $(DTXDIR)/$(PACKAGE)-00-preamble.dtx \
  $(DTXDIR)/$(PACKAGE)-01-messages.dtx \
  $(DTXDIR)/$(PACKAGE)-02-options-state.dtx \
  $(DTXDIR)/$(PACKAGE)-03-tuples.dtx \
  $(DTXDIR)/$(PACKAGE)-04-parser.dtx \
  $(DTXDIR)/$(PACKAGE)-05-rendering.dtx \
  $(DTXDIR)/$(PACKAGE)-06-sticks.dtx \
  $(DTXDIR)/$(PACKAGE)-07-public.dtx
DTX_SOURCES  = $(PACKAGE).dtx $(DTX_PARTS)
AUX_EXT      = aux bbl blg brf glo gls hd idx ilg ind lof log lot out toc synctex.gz fdb_latexmk fls

.PHONY: all unpack doc example code-doc clean distclean install uninstall ctan check

all: unpack doc

unpack: $(PACKAGE).sty

$(PACKAGE).sty: $(PACKAGE).ins $(DTX_PARTS)
	$(LATEX) $(PACKAGE).ins

doc: unpack doc/$(PACKAGE)-doc.pdf

doc/$(PACKAGE)-doc.pdf: doc/$(PACKAGE)-doc.tex $(PACKAGE).sty tiles/$(PACKAGE)-1m.pdf assets/stick/100.pdf assets/stick/1k.pdf assets/stick/5k.pdf assets/stick/10k.pdf
	$(PDFLATEX) -interaction=nonstopmode -halt-on-error -output-directory=doc doc/$(PACKAGE)-doc.tex
	$(PDFLATEX) -interaction=nonstopmode -halt-on-error -output-directory=doc doc/$(PACKAGE)-doc.tex

example: unpack doc/$(PACKAGE)-example.pdf

doc/$(PACKAGE)-example.pdf: doc/$(PACKAGE)-example.tex $(PACKAGE).sty tiles/$(PACKAGE)-1m.pdf assets/stick/100.pdf assets/stick/1k.pdf assets/stick/5k.pdf assets/stick/10k.pdf
	$(PDFLATEX) -interaction=nonstopmode -halt-on-error -output-directory=doc doc/$(PACKAGE)-example.tex

code-doc: doc/$(PACKAGE).pdf

doc/$(PACKAGE).pdf: $(DTX_SOURCES)
	$(PDFLATEX) -interaction=nonstopmode -halt-on-error -output-directory=doc $(PACKAGE).dtx
	$(PDFLATEX) -interaction=nonstopmode -halt-on-error -output-directory=doc $(PACKAGE).dtx

check: unpack doc example

clean:
	@for ext in $(AUX_EXT); do rm -f doc/$(PACKAGE)-doc.$$ext doc/$(PACKAGE)-example.$$ext doc/$(PACKAGE).$$ext $(PACKAGE).$$ext; done
	@rm -f doc/$(PACKAGE)-doc.glo doc/$(PACKAGE)-doc.hd doc/$(PACKAGE)-doc.ilg doc/$(PACKAGE)-doc.ind
	@rm -f doc/$(PACKAGE)-example.pdf doc/$(PACKAGE).pdf

distclean: clean
	@rm -f $(PACKAGE).sty doc/$(PACKAGE)-doc.pdf ../$(PACKAGE).zip

install: unpack doc
	install -d "$(TEXDIR)/tiles" "$(TEXDIR)/assets/stick" "$(DOCDIR)" "$(SRCDIR)/$(DTXDIR)"
	install -m 0644 $(PACKAGE).sty "$(TEXDIR)/"
	install -m 0644 tiles/*.pdf "$(TEXDIR)/tiles/"
	install -m 0644 assets/stick/*.pdf "$(TEXDIR)/assets/stick/"
	install -m 0644 README.md LICENCE doc/$(PACKAGE)-doc.pdf doc/$(PACKAGE)-doc.tex doc/$(PACKAGE)-example.tex "$(DOCDIR)/"
	install -m 0644 $(PACKAGE).dtx $(PACKAGE).ins Makefile "$(SRCDIR)/"
	install -m 0644 $(DTX_PARTS) "$(SRCDIR)/$(DTXDIR)/"
	@command -v mktexlsr >/dev/null 2>&1 && mktexlsr "$(TEXMFHOME)" || true

uninstall:
	@rm -rf "$(TEXDIR)" "$(DOCDIR)" "$(SRCDIR)"
	@command -v mktexlsr >/dev/null 2>&1 && mktexlsr "$(TEXMFHOME)" || true

ctan: doc
	$(MAKE) clean
	@rm -f $(PACKAGE).sty ../$(PACKAGE).zip
	cd .. && zip -X -r $(PACKAGE).zip $(PACKAGE) \
	  -x '$(PACKAGE)/.git/*' \
	     '$(PACKAGE)/*.sty' \
	     '$(PACKAGE)/*.aux' \
	     '$(PACKAGE)/*.log' \
	     '$(PACKAGE)/*.out' \
	     '$(PACKAGE)/*.toc' \
	     '$(PACKAGE)/*.idx' \
	     '$(PACKAGE)/*.ind' \
	     '$(PACKAGE)/*.ilg' \
	     '$(PACKAGE)/*.glo' \
	     '$(PACKAGE)/*.gls' \
	     '$(PACKAGE)/*.hd' \
	     '$(PACKAGE)/*.fls' \
	     '$(PACKAGE)/*.fdb_latexmk' \
	     '$(PACKAGE)/*.gitignore' \
	     '$(PACKAGE)/doc/*.aux' \
	     '$(PACKAGE)/doc/*.log' \
	     '$(PACKAGE)/doc/*.out' \
	     '$(PACKAGE)/doc/*.toc' \
	     '$(PACKAGE)/doc/*.idx' \
	     '$(PACKAGE)/doc/*.ind' \
	     '$(PACKAGE)/doc/*.ilg' \
	     '$(PACKAGE)/doc/*.glo' \
	     '$(PACKAGE)/doc/*.gls' \
	     '$(PACKAGE)/doc/*.hd' \
	     '$(PACKAGE)/doc/*.fls' \
	     '$(PACKAGE)/doc/*.fdb_latexmk' \
	     '$(PACKAGE)/doc/$(PACKAGE)-example.pdf' \
	     '$(PACKAGE)/doc/$(PACKAGE).pdf'
