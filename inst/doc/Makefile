# Makefile for Sweave documents containing both Latex and R code
# Author:	Johannes Ranke <jranke@uni-bremen.de>
# Last Change: 2006 Mai 11
# based on the Makefile of Nicholas Lewin-Koh
# in turn based on work of Rouben Rostmaian
# SVN: $Id: Makefile.rnoweb 50 2006-04-18 11:13:52Z ranke $

RNWFILES = $(wildcard *.Rnw)
TARGETS = $(patsubst %.Rnw,%.tex,$(RNWFILE)) $(patsubst %.Rnw,%.pdf,$(RNWFILES))

%.tex: %.Rnw
	echo 'Sweave("$<")' | R --no-save --no-restore

%.pdf: %.tex
	pdflatex $<

all: $(TARGETS)

clean: 
	rm -f *.aux *.log *.bbl *.blg *.brf *.cb *.ind *.idx *.ilg  \
          *.inx *.ps *.dvi *.toc *.out *.lot *~ *.lof *.ttt *.fff
