# Makefile for mahjong-tiles

PACKAGE      = mahjong-tiles
VERSION      = 2.6.0
LATEX        ?= latex
PDFLATEX     ?= pdflatex
TEXMFHOME    ?= $(shell kpsewhich -var-value=TEXMFHOME 2>/dev/null || printf '%s' "$$HOME/texmf")
TEXDIR       = $(TEXMFHOME)/tex/latex/$(PACKAGE)
DOCDIR       = $(TEXMFHOME)/doc/latex/$(PACKAGE)
SRCDIR       = $(TEXMFHOME)/source/latex/$(PACKAGE)
AUX_EXT      = aux bbl blg brf glo gls hd idx ilg ind lof log lot out toc synctex.gz fdb_latexmk fls

.PHONY: all unpack doc example code-doc clean distclean install uninstall ctan check

all: unpack doc

unpack: $(PACKAGE).sty

$(PACKAGE).sty: $(PACKAGE).dtx $(PACKAGE).ins
	$(LATEX) $(PACKAGE).ins

doc: unpack doc/$(PACKAGE)-doc.pdf

doc/$(PACKAGE)-doc.pdf: doc/$(PACKAGE)-doc.tex $(PACKAGE).sty tiles/$(PACKAGE)-1m.pdf
	$(PDFLATEX) -interaction=nonstopmode -halt-on-error -output-directory=doc doc/$(PACKAGE)-doc.tex
	$(PDFLATEX) -interaction=nonstopmode -halt-on-error -output-directory=doc doc/$(PACKAGE)-doc.tex

example: unpack
	$(PDFLATEX) -interaction=nonstopmode -halt-on-error -output-directory=doc doc/$(PACKAGE)-example.tex

code-doc:
	$(PDFLATEX) -interaction=nonstopmode -halt-on-error -output-directory=doc $(PACKAGE).dtx

check: unpack doc example

clean:
	@for ext in $(AUX_EXT); do rm -f doc/$(PACKAGE)-doc.$$ext doc/$(PACKAGE)-example.$$ext doc/$(PACKAGE).$$ext $(PACKAGE).$$ext; done
	@rm -f doc/$(PACKAGE)-doc.glo doc/$(PACKAGE)-doc.hd doc/$(PACKAGE)-doc.ilg doc/$(PACKAGE)-doc.ind
	@rm -f doc/$(PACKAGE)-example.pdf doc/$(PACKAGE).pdf

distclean: clean
	@rm -f $(PACKAGE).sty doc/$(PACKAGE)-doc.pdf ../$(PACKAGE).zip

install: unpack doc
	install -d "$(TEXDIR)/tiles" "$(DOCDIR)" "$(SRCDIR)"
	install -m 0644 $(PACKAGE).sty "$(TEXDIR)/"
	install -m 0644 tiles/*.pdf "$(TEXDIR)/tiles/"
	install -m 0644 README.md LICENCE doc/$(PACKAGE)-doc.pdf doc/$(PACKAGE)-doc.tex doc/$(PACKAGE)-example.tex "$(DOCDIR)/"
	install -m 0644 $(PACKAGE).dtx $(PACKAGE).ins Makefile "$(SRCDIR)/"
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
