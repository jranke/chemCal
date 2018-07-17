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
	README.html \
	R/* \
	tests/* \
	tests/testthat*

all: build

$(TGZ): $(pkgfiles) vignettes
	"$(RBIN)/R" CMD build . 2>&1 | tee build.log

build: $(TGZ)

README.html: README.md
	"$(RBIN)/Rscript" -e "rmarkdown::render('README.md', output_format = 'html_document')"

install: build
	"$(RBIN)/R" CMD INSTALL $(TGZ)

check: build
	"$(RBIN)/R" CMD check --as-cran $(TGZ)

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
	NOT_CRAN=true "$(RBIN)/Rscript" -e 'devtools::test()'

clean:
	$(RM) -r vignettes/*_cache
	$(RM) -r vignettes/*_files
	$(RM) -r vignettes/*.R
	$(RM) Rplots.pdf
