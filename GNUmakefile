PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename $(PWD))

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
	@echo "  check                   Invoke build and then check the package"
	@echo "  check-no-vignettes      Invoke build without rebuilding vignettes, and then check"
	@echo "  install                 Invoke build and then install the result"
	@echo "  install-no-vignettes    Invoke build without rebuilding vignettes and then install the result"
	@echo ""
	@echo "Using R in: $(RBIN)"
	@echo "Set the RBIN environment variable to change this."
	@echo ""


#------------------------------------------------------------------------------
# Development Tasks
#------------------------------------------------------------------------------

build:
	cd ..;\
		"$(RBIN)/R" CMD build $(PKGSRC)

build-no-vignettes:
	cd ..;\
		"$(RBIN)/R" CMD build $(PKGSRC) --no-build-vignettes

install: build
	cd ..;\
		"$(RBIN)/R" CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz

install-no-vignettes: build-no-vignettes
	cd ..;\
		"$(RBIN)/R" CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz

check: build
	cd ..;\
		"$(RBIN)/R" CMD check --as-cran $(PKGNAME)_$(PKGVERS).tar.gz

check-no-vignettes: build-no-vignettes
	cd ..;\
		"$(RBIN)/R" CMD check --as-cran $(PKGNAME)_$(PKGVERS).tar.gz

sd:
	@echo Now execute
	@echo "\n  staticdocs::build_site()\n"
	$(RBIN)/R
