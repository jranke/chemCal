PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename $(PWD))
TGZ     := $(PKGNAME)_$(PKGVERS).tar.gz

# Specify the directory holding R binaries. To use an alternate R build (say a
# pre-prelease version) use `make RBIN=/path/to/other/R/` or `export RBIN=...`
# If no alternate bin folder is specified, the default is to use the folder
# containing the first instance of R on the PATH.
RBIN ?= $(shell dirname "`which R`")

.PHONY: help

help:
	@echo "\nExecute development tasks for $(PKGNAME)\n"
	@echo "Usage: \`make <task>\` where <task> is one of:"
	@echo ""
	@echo "Development Tasks"
	@echo "-----------------"
	@echo "  build                   Create the package"
	@echo "  build-no-vignettes      Create the package without rebuilding vignettes"
	@echo "  install                 Invoke build and then install the result"
	@echo "  install-no-vignettes    Invoke build without rebuilding vignettes and then install the result"
	@echo "  check                   Invoke build and then check the package"
	@echo "  check-no-vignettes      Invoke build without rebuilding vignettes, and then check"
	@echo "  sd                      Build static documentation"
	@echo "  winbuilder              Upload the build to winbuilder"
	@echo ""
	@echo "Using R in: $(RBIN)"
	@echo "Set the RBIN environment variable to change this."
	@echo ""


#------------------------------------------------------------------------------
# Development Tasks
#------------------------------------------------------------------------------

build:
	"$(RBIN)/R" CMD build .

build-no-vignettes:
	"$(RBIN)/R" CMD build --no-build-vignettes .

install: build
	"$(RBIN)/R" CMD INSTALL $(TGZ)

install-no-vignettes: build-no-vignettes
	"$(RBIN)/R" CMD INSTALL $(TGZ)

check: build
	"$(RBIN)/R" CMD check --as-cran $(TGZ)

check-no-vignettes: build-no-vignettes
	"$(RBIN)/R" CMD check --as-cran $(TGZ)

sd:
	@echo Now execute
	@echo "\n  staticdocs::build_site()\n"
	$(RBIN)/R

winbuilder: build
	@echo "Uploading to R-release on win-builder"
	curl -T $(TGZ) ftp://anonymous@win-builder.r-project.org/R-release/
	@echo "Uploading to R-devel on win-builder"
	curl -T $(TGZ) ftp://anonymous@win-builder.r-project.org/R-devel/
