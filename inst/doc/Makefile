# Makefile for Sweave documents containing both Latex and R code
# Author:	Johannes Ranke <jranke@uni-bremen.de>
# Last Change: 2006 Mai 24
# based on the Makefile of Nicholas Lewin-Koh
# in turn based on work of Rouben Rostmaian
# SVN: $Id: Makefile.rnoweb 62 2006-05-24 08:30:59Z ranke $

RNWFILES = $(wildcard *.Rnw)
TARGETS = $(patsubst %.Rnw,%.tex,$(RNWFILE)) $(patsubst %.Rnw,%.pdf,$(RNWFILES))

RERUN = "(There were undefined references|Rerun to get (cross-references|the bars) right|Table widths have changed. Rerun LaTeX.|Linenumber reference failed)"
RERUNBIB = "No file.*\.bbl|Citation.*undefined"

%.tex: %.Rnw
	echo 'Sweave("$<")' | R --no-save --no-restore

%.pdf: %.tex
	pdflatex $<
	egrep -c $(RERUNBIB) $*.log && (bibtex $*;pdflatex $<); true
	egrep $(RERUN) $*.log && (pdflatex $<) ; true
	egrep $(RERUN) $*.log && (pdflatex $<) ; true

all: all-recursive $(TARGETS)

clean: clean-recursive
	rm -f *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg  \
          *.inx *.ps *.dvi *.toc *.out *.lot *~ *.lof *.ttt *.fff

all-recursive:
	for dir in $(wildcard *); do if [ -d $$dir ] && [ -f $$dir/Makefile ]; then cd $$dir; $(MAKE) all; cd ..; fi; done

clean-recursive:
	for dir in $(wildcard *); do if [ -d $$dir ] && [ -f $$dir/Makefile ]; then cd $$dir; $(MAKE) clean; cd ..; fi; done
