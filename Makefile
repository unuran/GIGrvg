
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
	@echo "build  ... build package 'GIGrvg'"
	@echo "check  ... check package 'GIGrvg'"
	@echo "clean  ... clear working space"
	@echo ""
	@echo "valgrind ... check package 'GIGrvg' using valgrind"
	@echo ""
	@echo "C_API_check    ... check C API of package 'GIGrvg'"
	@echo "C_API_valgrind ... check C API of package 'GIGrvg' using valgrind"
	@echo ""

# --- Phony targets ---------------------------------------------------------

.PHONY: all help clean maintainer-clean clean build check

# --- rgig ------------------------------------------------------------------

build:
	${R} CMD build ${project}

check:
	(unset TEXINPUTS; _R_CHECK_TIMINGS_=0 ${R} CMD check --as-cran ${project}_*.tar.gz)

valgrind:
	(unset TEXINPUTS; _R_CHECK_TIMINGS_=0 ${R} CMD check --use-valgrind ${project}_*.tar.gz)

# --- C API -----------------------------------------------------------------

C_API_check:
	@echo "Checking C API of package 'GIGrvg'!"
	@echo "You must Package 'GIGrvg' installed!" | sed 'h;s/./=/g;p;x;p;x'
	(cd ./GIGrvg/devel/test_C_export/ && make build check)

C_API_valgrind:
	@echo "Checking C API of package 'GIGrvg'!"
	@echo "You must Package 'GIGrvg' installed!" | sed 'h;s/./=/g;p;x;p;x'
	(cd ./GIGrvg/devel/test_C_export/ && make build valgrind)

C_API_clean:
	@rm -fv ${project}/devel/test_C_export/mypack_*.tar.gz
	@rm -rf ${project}/devel/test_C_export/mypack.Rcheck

# --- Clear working space ---------------------------------------------------

clean:
	@rm -rf ${project}.Rcheck
	@rm -fv ${project}_*.tar.gz
	@rm -fv ${project}/src/*.o ${project}/src/*.so
	@find -L . -type f -name "*~" -exec rm -v {} ';'
	@make C_API_clean

maintainer-clean: clean

# --- End -------------------------------------------------------------------
