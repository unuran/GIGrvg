#############################################################################
#
#  Makefile for building and checking R package 'GIGrvg'
#
#############################################################################

# --- Constants -------------------------------------------------------------

# name of project
project = GIGrvg

# name of R program
R = R

# --- Default target --------------------------------------------------------

all: help

# --- Help ------------------------------------------------------------------

help:
	@echo ""
	@echo "build  ... build package '${project}'"
	@echo "check  ... check package '${project}'"
	@echo "clean  ... clear working space"
	@echo ""
	@echo "valgrind ... check package '${project}' using valgrind (slow!)"
	@echo ""
	@echo "CAPI-check ... check C API of package '${project}'"
	@echo "CAPI-valgrind ... check C API of package '${project}' using valgrind (slow!)"
	@echo ""

# --- Phony targets ---------------------------------------------------------

.PHONY: all help clean maintainer-clean clean build check

# --- GIGrvg ----------------------------------------------------------------

build:
	${R} CMD build ${project}

check:
	(unset TEXINPUTS; ${R} CMD check --as-cran ${project}_*.tar.gz)

valgrind:
	(unset TEXINPUTS; ${R} CMD check --use-valgrind ${project}_*.tar.gz)
	@echo -e "\n * Valgrind output ..."
	@for Rout in `find ${project}.Rcheck/ -name *.Rout`; \
		do echo -e "\n = $$Rout:\n"; \
		grep -e '^==[0-9]\{3,\}== ' $$Rout; \
	done

pkg-clean:
	@rm -rf ${project}.Rcheck
	@rm -fv ${project}_*.tar.gz
	@rm -fv ./${project}/src/*.o ./${project}/src/*.so


# --- GIGrvg C API test -----------------------------------------------------

CAPI-build:
	@echo -e "\n * Checking C API of package '${project}'!\n"
	@echo "Ensure that package '${project}' is installed!" | sed 'h;s/./=/g;p;x;p;x'
	@echo -e "\n * Building package ...\n"
	${R} CMD build test_CAPI_${project}

CAPI-check: CAPI-build
	@echo -e "\n * Checking package ...\n"
	(unset TEXINPUTS; ${R} CMD check test.CAPI.${project}_*.tar.gz)

CAPI-valgrind: CAPI-build
	@echo -e "\n * Checking package ...\n"
	(unset TEXINPUTS; ${R} CMD check --use-valgrind test.CAPI.${project}_*.tar.gz)
	@echo -e "\n * Valgrind output ..."
	@for Rout in `find test.CAPI.${project}.Rcheck/ -name *.Rout`; \
		do echo -e "\n = $$Rout:\n"; \
		grep -e '^==[0-9]\{3,\}== ' $$Rout; \
	done

CAPI-clean:
	@rm -rf test.CAPI.${project}.Rcheck
	@rm -fv test.CAPI.${project}_*.tar.gz

# --- Clear working space ---------------------------------------------------

clean:
	@make pkg-clean
	@make CAPI-clean
	@find -L . -type f -name "*~" -exec rm -v {} ';'

maintainer-clean: clean

# --- End -------------------------------------------------------------------
