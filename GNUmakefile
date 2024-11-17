PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename $(PWD))
TGZ     := $(PKGNAME)_$(PKGVERS).tar.gz

# Specify the directory holding R binaries. To use an alternate R build (say a
# pre-prelease version) use `make RBIN=/path/to/other/R/` or `export RBIN=...`
# If no alternate bin folder is specified, the default is to use the folder
# containing the first instance of R on the PATH.
RBIN ?= $(shell dirname "`which R`")
#
# Vignettes are listed in the build target
pkgfiles = \
  GNUmakefile \
	.Rbuildignore \
	data/* \
	DESCRIPTION \
	man/* \
	NAMESPACE \
	NEWS.md \
	README.md \
	R/* \
	tests/* \
	tests/testthat*

all: build

$(TGZ): $(pkgfiles) vignettes
	"$(RBIN)/R" CMD build . 2>&1 | tee build.log

roxy:
	Rscript -e "roxygen2::roxygenize(roclets = c('rd', 'collate', 'namespace'))"

build: roxy $(TGZ)

README.html: README.rmd
	"$(RBIN)/Rscript" -e "rmarkdown::render('README.rmd', clean = FALSE)"
	mv README.knit.md README.md

install: roxy build
	"$(RBIN)/R" CMD INSTALL $(TGZ)

check: roxy build
	"$(RBIN)/R" CMD check --as-cran $(TGZ) 2>&1 | tee check.log

vignettes/%.html: vignettes/%.Rmd vignettes/refs.bib
	"$(RBIN)/Rscript" -e "tools::buildVignette(file = 'vignettes/$*.Rmd', dir = 'vignettes')"

vignettes: vignettes/chemCal.html

pd:
	"$(RBIN)/Rscript" -e "pkgdown::build_site()"
	git add -A
	git commit -m 'Static documentation rebuilt by pkgdown::build_site()' -e

winbuilder: build
	@echo "Uploading to R-release on win-builder"
	curl -T $(TGZ) ftp://anonymous@win-builder.r-project.org/R-release/
	@echo "Uploading to R-devel on win-builder"
	curl -T $(TGZ) ftp://anonymous@win-builder.r-project.org/R-devel/

test: install
	NOT_CRAN=true "$(RBIN)/Rscript" -e 'options(cli.dynamic = TRUE); devtools::test()' 2>&1 | tee test.log
	sed -i -e "s/\r.*\r//" test.log

clean:
	$(RM) -r vignettes/*_cache
	$(RM) -r vignettes/*_files
	$(RM) -r vignettes/*.R
	$(RM) Rplots.pdf


.PHONY: roxy build install check pd winbuilder test clean
